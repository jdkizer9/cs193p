//
//  SuperPlayingCardViewController.m
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SuperPlayingCardViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface SuperPlayingCardViewController ()

@end

@implementation SuperPlayingCardViewController

#pragma mark - Abstract functions requrire by super

- (void)updateCardView:(CardView *)cardView forCard:(Card*)card
{
    if ([cardView isKindOfClass:[PlayingCardView class]] && [card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
    }
    
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
