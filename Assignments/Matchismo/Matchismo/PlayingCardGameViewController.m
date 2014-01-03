//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PlayingCardGameViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (NSString *)textDescriptionOfCard:(Card*)card
{
    //check to see if PlayingCard
    if ([card isKindOfClass:[PlayingCard class]])
    {
        return [NSString stringWithString: card.contents];
    } else
        return nil;
}

@end
