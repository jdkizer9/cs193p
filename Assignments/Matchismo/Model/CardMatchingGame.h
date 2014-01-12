//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by James Kizer on 1/1/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

//designated Initializer
- (instancetype)initUsingDeck:(Deck *)deck
               withMatchCount:(NSInteger)matchCount;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (void)chooseCard:(Card*)card;
- (Card *)cardAtIndex:(NSUInteger)index;
- (Card *)drawCardFromDeck;
- (void)startNewGame;
//- (void)shuffleDeckAndReset:(BOOL)reset;
- (NSUInteger)numberOfUndrawnCards;
- (void)addCardToDiscardPile:(Card *)card;
- (BOOL)matchForHint:(NSMutableArray *)cardArray;
- (void)hintPenalty:(NSUInteger)penalty;

@property (nonatomic, readonly) NSInteger score;
//@property (strong, nonatomic) CardGameHistoryLog* historyLog;


@end
