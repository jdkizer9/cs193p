//
//  SuperCardViewController.h
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Deck.h"
#import "CardView.h"
#import "Card.h"

@interface SuperCardViewController : UIViewController

- (Deck *)createDeck;
- (void)updateCardView:(CardView *)cardView forCard:(Card*)card;
- (void)handleCardViewTap:(UITapGestureRecognizer *)gesture;

@end
