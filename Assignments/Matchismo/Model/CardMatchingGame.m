//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by James Kizer on 1/1/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of Cards
@property (strong, nonatomic, readwrite) NSString *lastAction;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype) initWithCardCount:(NSUInteger)count
                         usingDeck:(Deck *)deck
{
    self = [super init];
    if (self)
    {
        for(int i=0; i<count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                [self.cards addObject:card];
                
            } else
            {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.lastCard = card;
    self.lastScore = 0;
    self.lastOtherCards = nil;
    
    if (!card.isMatched)
    {
        if (card.isChosen)
        {
            card.chosen = NO;
        }
        else
        {
            //match against other card(s)
            NSMutableArray *matchArray = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isChosen && !otherCard.isMatched)
                {
                    //add to matchArray
                    [matchArray addObject:otherCard];
                    
                    //if correct number of cards have been chosen, try to match
                    if ([matchArray count] == (self.matchCount-1))
                    {
                        int matchScore = [card match:matchArray];
                        if (matchScore)
                        {
                            //if a match was found, update score
                            self.lastScore = matchScore * MATCH_BONUS;
                            card.matched = YES;
                            for (Card *anotherCard in matchArray)
                            {
                                anotherCard.matched = YES;
                            }
                        }
                        else
                        {
                            self.lastScore = -MISMATCH_PENALTY;
                            for (Card *anotherCard in matchArray)
                            {
                                anotherCard.chosen = NO;
                            }

                        }
                        
                        self.score += self.lastScore;
                        self.lastOtherCards = [NSArray arrayWithArray:matchArray];
                        break;
                        
                    }
                    
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
}


@end
