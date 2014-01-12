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
#import "CardView.h"
#import "CardGameAnimationLogEntry.h"

@interface CardGameViewController : UIViewController

//for the subclasses
- (void)addAnimationLogEntry:(CardGameAnimationLogEntry*)entry;

// protected
// subclass must implement
- (Deck *)createDeck; //abstract
- (void)updateCardView:(CardView *)cardView
               forCard:(Card*)card; //abstract

//abstract property
@property (nonatomic, readonly) NSInteger matchCount;
@property (nonatomic, readonly) NSInteger numberOfVisibleCards;
@property (nonatomic, readonly) NSInteger numberOfNewCardsToDraw;
@property (nonatomic, readonly) Class viewCardClass;

@end
