//
//  PlayingCardGameViewController.h
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController : CardGameViewController

//inherits from CardGameViewController
//must implement the following methods and properties
//- (Deck *)createDeck; //abstract
//- (void)updateCardView:(CardView *)cardView
//               forCard:(Card*)card; //abstract
//
////abstract property
//@property (nonatomic, readonly) NSInteger matchCount;
//@property (nonatomic, readonly) NSInteger numberOfVisibleCards;
//@property (nonatomic, readonly) NSInteger numberOfNewCardsToDraw;
//@property (nonatomic, readonly) Class viewCardClass;


#define PLAYING_CARD_GAME_MATCH_COUNT 2

@end
