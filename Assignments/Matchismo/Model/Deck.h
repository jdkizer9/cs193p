//
//  Deck.h
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface Deck : NSObject <NSCopying>

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;
- (NSUInteger)cardsInDeck;

@end
