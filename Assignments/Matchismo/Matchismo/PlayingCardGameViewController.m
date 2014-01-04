//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "CardGameHistoryLog.h"
#import "CardGameHistoryEntry.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController


//BEGIN METHODS REQUIRED BY CardGameViewController
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCardButton:(UIButton *)cardButton
                 forCard:(Card*)card
{
    [super updateCardButton:cardButton forCard:card];
    
    [cardButton setTitle:[self titleForCard:card]
                forState:UIControlStateNormal];
    
    [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                          forState:UIControlStateNormal];
}

- (NSAttributedString *) attributedStringFromCardGameHistoryEntry:(CardGameHistoryEntry *)entry
{
    NSString *labelString;
    
    if (entry.score == 0)
    {
        Card *card = [entry.cards lastObject];
        assert([card isKindOfClass:[PlayingCard class]]);
        
        labelString = [self textDescriptionOfCard:card];
    }
    else if(entry.score > 0)
    {
        labelString = @"Matched ";
        for (Card *card in entry.cards)
        {
            assert([card isKindOfClass:[PlayingCard class]]);
            labelString = [labelString stringByAppendingFormat:@"%@ ", [self textDescriptionOfCard:card]];
        }
        labelString = [labelString stringByAppendingFormat:@"for %d points.", entry.score];
    }
    else
    {
        labelString = @"";
        for (Card *card in entry.cards)
        {
            assert([card isKindOfClass:[PlayingCard class]]);
            labelString = [labelString stringByAppendingFormat:@"%@ ", [self textDescriptionOfCard:card]];
        }
        labelString = [labelString stringByAppendingFormat:@"don't match! %d point penalty!", -entry.score];
    }
    
    return [[NSMutableAttributedString alloc] initWithString:labelString];
}

- (NSString *)historySegueIDName
{
    return @"Playing Card Game History";
}

- (NSInteger)matchCount
{
    return PLAYING_CARD_GAME_MATCH_COUNT;
}

//END METHODS REQUIRED BY CardGameViewController

- (NSString *)textDescriptionOfCard:(Card*)card
{
    //check to see if PlayingCard
    if ([card isKindOfClass:[PlayingCard class]])
    {
        return [NSString stringWithString: card.contents];
    } else
        return nil;
}

- (NSString *)titleForCard:(Card *)card
{
    return (card.isChosen ? card.contents : @"");
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" :@"cardback")];
}

@end
