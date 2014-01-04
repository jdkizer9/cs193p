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
//- (Deck *)createDeck;
//- (void)updateCardButton:(UIButton *)cardButton forCard:(Card*)card;
//- (NSAttributedString *) attributedStringFromCardGameHistoryEntry:(CardGameHistoryEntry *)entry;
//- (NSString *)historySegueIDName;
//@property (nonatomic, readonly) NSInteger matchCount;


#define SET_CARD_GAME_MATCH_COUNT 3

@end
