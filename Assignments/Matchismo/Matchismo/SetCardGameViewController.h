//
//  SetCardGameViewController.h
//  Matchismo
//
//  Created by James Kizer on 1/3/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameViewController.h"

@interface SetCardGameViewController : CardGameViewController

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


#define SET_CARD_GAME_MATCH_COUNT 3
#define MAX_NUMBER_OF_CARDS_IN_PLAY 12

@end
