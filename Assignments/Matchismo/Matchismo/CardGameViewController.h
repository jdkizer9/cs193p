//
//  CardGameViewController.h
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//
// This class is abstract. Must impliment methods as described below

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"

@interface CardGameViewController : UIViewController

// protected
// subclass must implement
- (Deck *)createDeck; //abstract
- (NSString *)textDescriptionOfCard:(Card*)card;

@end
