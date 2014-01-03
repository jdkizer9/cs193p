//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by James Kizer on 1/1/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CardGameHistoryEntry.h"

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

- (CardGameHistoryLog *)historyLog
{
    if (!_historyLog) _historyLog = [[CardGameHistoryLog alloc] init];
    return _historyLog;
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
    NSInteger moveScore = 0;
    
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
                            moveScore = matchScore * MATCH_BONUS;
                            card.matched = YES;
                            for (Card *anotherCard in matchArray)
                            {
                                anotherCard.matched = YES;
                            }
                        }
                        else
                        {
                            moveScore = -MISMATCH_PENALTY;
                            for (Card *anotherCard in matchArray)
                            {
                                anotherCard.chosen = NO;
                            }

                        }
                        self.score += moveScore;
                        
                        //add card to matchArray for history entry
                        [matchArray addObject:card];
                        CardGameHistoryEntry *entry = [[CardGameHistoryEntry alloc] initEntryWithCards:matchArray score:moveScore];
                        [self.historyLog addCardGameHistoryEntry: entry];
                        break;
                        
                    }
                    
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            
            if (!moveScore)
            {
                //add history entry
                CardGameHistoryEntry *entry = [[CardGameHistoryEntry alloc] initEntryWithCards:@[card] score:moveScore];
                [self.historyLog addCardGameHistoryEntry: entry];
            }
        }
    }
    
}


@end
