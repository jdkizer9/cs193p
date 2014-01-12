//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 1/3/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()


@end

@implementation SetCardGameViewController

//BEGIN METHODS REQUIRED BY CardGameViewController
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateCardView:(CardView *)cardView
               forCard:(Card*)card
{
    if ([cardView isKindOfClass:[SetCardView class]]  &&
        [card isKindOfClass:[SetCard class]])
    {
        SetCardView *setCardView = (SetCardView*)cardView;
        SetCard *setCard = (SetCard *)card;
        
        setCardView.number = setCard.number;
        setCardView.symbol = setCard.symbol;
        setCardView.shading = setCard.shading;
        setCardView.color = setCard.color;
        
        //when selected / deselected, animate the transistion
        //card should transition from white BG to blue BG
        if (setCardView.chosen != setCard.isChosen)
        {
            setCardView.chosen = setCard.isChosen;
        }
    }
}



- (NSInteger)matchCount
{
    return SET_CARD_GAME_MATCH_COUNT;
}

- (NSInteger)numberOfVisibleCards
{
    return MAX_NUMBER_OF_CARDS_IN_PLAY;
}

- (Class)viewCardClass
{
    return [SetCardView class];
}

//END METHODS REQUIRED BY CardGameViewController

@end
