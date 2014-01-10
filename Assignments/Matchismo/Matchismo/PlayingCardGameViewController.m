//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController


//BEGIN METHODS REQUIRED BY CardGameViewController
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCardView:(CardView *)cardView
               forCard:(Card*)card
{
    if ([cardView isKindOfClass:[PlayingCardView class]]  &&
        [card isKindOfClass:[PlayingCard class]])
    {
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        PlayingCard *playingCard = (PlayingCard *)card;
        
        playingCardView.rank = playingCard.rank;
        playingCardView.suit= playingCard.suit;
        
        playingCardView.faceUp = playingCard.isChosen;
        playingCardView.chosen = playingCard.isChosen;
    }
}

//@property (nonatomic, readonly) NSInteger matchCount;
//@property (nonatomic, readonly) NSInteger numberOfVisibleCards;
//@property (nonatomic, readonly) Class viewCardClass;

- (NSInteger)numberOfVisibleCards
{
    return 12;
}

- (NSInteger)matchCount
{
    return PLAYING_CARD_GAME_MATCH_COUNT;
}

- (Class)viewCardClass
{
    return [PlayingCardView class];
}

//END METHODS REQUIRED BY CardGameViewController



@end
