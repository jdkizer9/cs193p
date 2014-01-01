//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by James Kizer on 1/1/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "card.h"

@interface CardMatchingGame : NSObject

//designated Initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSInteger matchCount;
@property (nonatomic, getter = isBegun) BOOL begun;
//@property (strong, nonatomic, readonly) NSString *lastAction;
@property (nonatomic) NSInteger lastScore;
@property (strong, nonatomic) Card *lastCard;
@property (strong, nonatomic) NSArray *lastOtherCards;


@end
