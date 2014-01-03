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
//- (Deck *)createDeck;
//- (void)updateCardButton:(UIButton *)cardButton forCard:(Card*)card;
//- (NSAttributedString *) attributedStringFromCardGameHistoryEntry:(CardGameHistoryEntry *)entry;
//- (NSString *)historySegueIDName;
//@property (nonatomic, readonly) NSInteger matchCount;


#define PLAYING_CARD_GAME_MATCH_COUNT 2

@end
