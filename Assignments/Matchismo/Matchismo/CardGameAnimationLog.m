//
//  CardGameAnimationLog.m
//  Matchismo
//
//  Created by James Kizer on 1/10/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameAnimationLog.h"
#import "CardGameAnimationLogEntry.h"

@interface CardGameAnimationLog()

@property (strong, nonatomic) NSMutableArray *flipCardLog;
@property (strong, nonatomic) NSMutableArray *moveCardLog;
@property (strong, nonatomic) NSMutableArray *removeCardLog;
@property (strong, nonatomic) NSMutableArray *hintCardLog;
@property (atomic) BOOL animatingFlips;
@property (atomic) BOOL animatingMoves;
@property (atomic) BOOL animatingRemoves;
@property (atomic) BOOL animatingHints;

@end

@implementation CardGameAnimationLog

typedef void (^completion_block_t)(BOOL);

-(NSMutableArray *)flipCardLog
{
    if (!_flipCardLog) _flipCardLog = [[NSMutableArray alloc]init];
    return _flipCardLog;
}

-(NSMutableArray *)moveCardLog
{
    if (!_moveCardLog) _moveCardLog = [[NSMutableArray alloc]init];
    return _moveCardLog;
}

-(NSMutableArray *)removeCardLog
{
    if (!_removeCardLog) _removeCardLog = [[NSMutableArray alloc]init];
    return _removeCardLog;
}

-(NSMutableArray *)hintCardLog
{
    if (!_hintCardLog) _hintCardLog = [[NSMutableArray alloc]init];
    return _hintCardLog;
}

- (BOOL)isAnimating
{
    if (self.animatingFlips ||
        self.animatingMoves ||
        self.animatingRemoves ||
        self.animatingHints )
        return YES;
    else
        return NO;
}


-(void)addAnimationEntry:(CardGameAnimationLogEntry*)logEntry
{
    
    switch (logEntry.animationType) {
        case CardGameAnimationFlipCard:
            assert(!self.animatingFlips);
            [self.flipCardLog addObject:logEntry];
            break;
        case CardGameAnimationMoveCard:
            assert(!self.animatingMoves);
            [self.moveCardLog addObject:logEntry];
            break;
        case CardGameAnimationRemoveCard:
            assert(!self.animatingRemoves);
            [self.removeCardLog addObject:logEntry];
            break;
        case CardGameAnimationHintCard:
            assert(!self.animatingHints);
            [self.hintCardLog addObject:logEntry];
            break;
            
        default:
            assert(0);
    }
}

//performAnimations kicks off the animations
// 1) if there are flip animations, perform all flip animations simultaneously
// 2) if there are remove animations, chain them
// 3) if there are add animations, chain them
// 4) hint animations are never performed in chains
-(void)performAnimations
{
    
    if ([self.flipCardLog count] && !self.animatingFlips)
        [self performFlipAnimations];
    else if ([self.removeCardLog count] && !self.animatingRemoves)
        [self performRemoveAnimationsWithDelay:0.0];
    else if ([self.moveCardLog count] && !self.animatingMoves)
        [self performMoveAnimations];
    
    if ([self.hintCardLog count] && !self.animatingHints)
        [self performHintAnimations];
}



-(void)performFlipAnimations
{
    assert(!self.animatingFlips);
    self.animatingFlips = YES;
    int numberOfFlipCardAnimations = [self.flipCardLog count];
    for(int i=0; i<numberOfFlipCardAnimations; i++)
    {
        CardGameAnimationLogEntry *entry = self.flipCardLog[0];
        CardView *cardView = entry.cardView;
        
        [self.flipCardLog removeObjectAtIndex:0];
        
        //if i is last entry, make sure to begin next animations
        completion_block_t completionBlock;
        if (i == (numberOfFlipCardAnimations-1))
        {
            if ([self.removeCardLog count])
            {
                //perform pause
                __weak CardGameAnimationLog *weakSelf = self;
                completionBlock = ^(BOOL completed) {
                    [weakSelf performRemoveAnimationsWithDelay:.5];
                    weakSelf.animatingFlips = NO;
                };
                
            } else if ([self.moveCardLog count])
            {
                __weak CardGameAnimationLog *weakSelf = self;
                completionBlock = ^(BOOL completed) {
                    [weakSelf performMoveAnimations];
                    weakSelf.animatingFlips = NO;
                };
                
            } else
            {
                __weak CardGameAnimationLog *weakSelf = self;
                completionBlock = ^(BOOL completed) {
                    weakSelf.animatingFlips = NO;
                };
            }
        }
        else
        {
            __weak CardGameAnimationLog *weakSelf = self;
            completionBlock = ^(BOOL completed) {
                weakSelf.animatingFlips = NO;
            };
        }
        
        [UIView transitionWithView:cardView
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            //this causes a flip
                            cardView.backgroundColor = [UIColor clearColor];
                           } completion:completionBlock];
    }
    
}

-(void)performHintAnimations
{
    assert(!self.animatingHints);
    self.animatingHints = YES;
    int numberOfHintAnimations = [self.hintCardLog count];
    
    NSMutableArray *cardViewArray = [[NSMutableArray alloc] init];
    for(int i=0; i<numberOfHintAnimations; i++)
    {
        CardGameAnimationLogEntry *entry = self.hintCardLog[i];
        [cardViewArray addObject:entry.cardView];
    }
    
    self.hintCardLog = nil;
    
    __weak CardGameAnimationLog *weakSelf = self;    
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         [UIView setAnimationRepeatCount:2];
                         for (id obj in cardViewArray)
                             ((CardView*)obj).alpha = 0.0;
                     }
                     completion:^(BOOL completed){
                         weakSelf.animatingHints = NO;
                         for (id obj in cardViewArray)
                             ((CardView*)obj).alpha = 1.0;}];
}

-(void)performRemoveAnimationsWithDelay:(NSTimeInterval)delay
{
    assert([self.removeCardLog count]>0);
    self.animatingRemoves = YES;
    
    CardGameAnimationLogEntry *entry = self.removeCardLog[0];
    CardView *cardView = entry.cardView;
    //Card *card = entry.card;
    
    [self.removeCardLog removeObjectAtIndex:0];
    
    //if there are more remove card animations, chain them
    //if there are no more remove card animations, chain
    //add card animations if ther are any
    //otherwise we are done
    completion_block_t completionBlock;
    if ([self.removeCardLog count])
    {
        __weak CardGameAnimationLog *weakSelf = self;
        completionBlock = ^(BOOL completed) {
            [cardView removeFromSuperview];
            [weakSelf performRemoveAnimationsWithDelay:0.0];
        };
    } else if ([self.moveCardLog count])
    {
        __weak CardGameAnimationLog *weakSelf = self;
        completionBlock = ^(BOOL completed) {
            [cardView removeFromSuperview];
            [weakSelf performMoveAnimations];
            weakSelf.animatingRemoves = NO;
        };
    }
    else
    {
        __weak CardGameAnimationLog *weakSelf = self;
        completionBlock = ^(BOOL completed) {
            [cardView removeFromSuperview];
            weakSelf.animatingRemoves = NO;
        };
    }
    
    __weak CardGameAnimationLog *weakSelf = self;
    [UIView animateWithDuration:.25
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //set remove to point based on superview
                         cardView.center = [weakSelf dealLocationForCardView:cardView];
                     }
                     completion:completionBlock];
}

-(CGPoint)dealLocationForCardView:(CardView *)cardView
{
    return CGPointMake(cardView.superview.bounds.origin.x + (cardView.superview.bounds.size.width)/2, cardView.superview.bounds.origin.y + (cardView.superview.bounds.size.height)*2);
}

-(void)performMoveAnimations
{
    assert([self.moveCardLog count]>0);
    self.animatingMoves = YES;
    
    CardGameAnimationLogEntry *entry = self.moveCardLog[0];
    CardView *cardView = entry.cardView;
//    Card *card = entry.card;
    
    [self.moveCardLog removeObjectAtIndex:0];
    
    //if there are more add animations, chain them
    //otherwise, we are done animating
    completion_block_t completionBlock;
    if ([self.moveCardLog count])
    {
        __weak CardGameAnimationLog *weakSelf = self;
        completionBlock = ^(BOOL completed) {
            [weakSelf performMoveAnimations];
        };
    }
    else
    {
        __weak CardGameAnimationLog *weakSelf = self;
        completionBlock = ^(BOOL completed) {
            weakSelf.animatingMoves = NO;
        };
    }
    
    //if center is currently (0,0), need to set center
    //to dealing location outside of the animator
    if (CGPointEqualToPoint(cardView.center, ADD_REMOVE_POINT))
        cardView.center = [self dealLocationForCardView:cardView];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cardView.center = entry.moveToPoint;
                     }
                     completion:completionBlock];
    
    
}

@end
