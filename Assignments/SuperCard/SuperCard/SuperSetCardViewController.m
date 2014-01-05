//
//  SuperSetCardViewController.m
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SuperSetCardViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SuperSetCardViewController ()

@end

@implementation SuperSetCardViewController

- (void)updateCardView:(CardView *)cardView forCard:(Card*)card
{
    if ([cardView isKindOfClass:[SetCardView class]] && [card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        SetCardView *setCardView = (SetCardView *)cardView;
        setCardView.number = setCard.number;
        setCardView.symbol = setCard.symbol;
        setCardView.shading = setCard.shading;
        setCardView.color = setCard.color;
    }
    
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

@end
