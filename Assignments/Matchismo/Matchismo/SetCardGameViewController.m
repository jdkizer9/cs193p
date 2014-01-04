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

@interface SetCardGameViewController ()


@end

@implementation SetCardGameViewController

//BEGIN METHODS REQUIRED BY CardGameViewController
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateCardButton:(UIButton *)cardButton
                 forCard:(Card*)card
{
    [super updateCardButton:cardButton forCard:card];
    
    [cardButton setAttributedTitle:[self attributedTitleForCard:card]
                forState:UIControlStateNormal];
    
    [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                          forState:UIControlStateNormal];
    
}

- (NSAttributedString *) attributedStringFromCardGameHistoryEntry:(CardGameHistoryEntry *)entry
{
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] init];
    NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    //[attributes addEntriesFromDictionary:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    
    if (entry.score == 0)
    {
        SetCard *card = [entry.cards lastObject];
        assert([card isKindOfClass:[SetCard class]]);
        
        [labelString appendAttributedString:[self attributedStringDescriptionOfCard:card forCardButton:NO]];
        
        //[description appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
    }
    else if(entry.score > 0)
    {
        //labelString = @"Matched ";
        [labelString appendAttributedString:[[NSAttributedString alloc]initWithString:@"Matched " attributes:normalAttributes]];
        for (Card *card in entry.cards)
        {
            assert([card isKindOfClass:[SetCard class]]);
            [labelString appendAttributedString:[self attributedStringDescriptionOfCard:card forCardButton:NO]];
            [labelString appendAttributedString:[[NSAttributedString alloc]initWithString:@" " attributes:normalAttributes]];
        }
        //labelString = [labelString stringByAppendingFormat:@"for %d points.", entry.score];
        [labelString appendAttributedString:[[NSAttributedString alloc]initWithString: [NSString stringWithFormat:@"for %d points.", entry.score] attributes:normalAttributes]];
    }
    else
    {
        //labelString = @"";
        for (Card *card in entry.cards)
        {
            assert([card isKindOfClass:[SetCard class]]);
            //labelString = [labelString stringByAppendingFormat:@"%@ ", [self textDescriptionOfCard:card]];
            [labelString appendAttributedString:[self attributedStringDescriptionOfCard:card forCardButton:NO]];
            [labelString appendAttributedString:[[NSAttributedString alloc]initWithString:@" " attributes:normalAttributes]];
        }
        //labelString = [labelString stringByAppendingFormat:@"don't match! %d point penalty!", entry.score];
        [labelString appendAttributedString:[[NSAttributedString alloc]initWithString: [NSString stringWithFormat:@"don't match! %d point penalty!", -entry.score] attributes:normalAttributes]];
    }
    //SetCard *card = [entry.cards lastObject];
    return labelString;
}

- (NSString *)historySegueIDName
{
    return @"Set Card Game History";
}

- (NSInteger)matchCount
{
    return SET_CARD_GAME_MATCH_COUNT;
}

//END METHODS REQUIRED BY CardGameViewController

- (NSAttributedString *)attributedTitleForCard:(Card *)card
{
    //return [self attributedStringDescriptionOfCard: card forCardButton:YES];
    NSMutableAttributedString *cardTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringDescriptionOfCard: card forCardButton:YES]];
    
    
    return cardTitle;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen ? @"setSelected" :@"setNotSelected")];
}

- (NSAttributedString *)attributedStringDescriptionOfCard:(Card*)card forCardButton:(BOOL)forButton
{
    
    //check to see if PlayingCard
    if ([card isKindOfClass:[SetCard class]])
    {
        SetCard * setCard = (SetCard *)card;
        NSMutableAttributedString *singleSymbol = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedSymbolForSetCard:setCard]];
        NSMutableAttributedString *description = [[NSMutableAttributedString alloc] init];
        
        
        for (int i = SetCardNumberOne; i <= setCard.number; i++)
        {
            [description appendAttributedString:singleSymbol];
            if (forButton)
            {
                //description.string = [description.string stringByAppendingString:@"\n"];
                [description appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
            }
        }
        //NSLog(@"%@",description);
        return description;
    } else
        return nil;
}

//- (NSString *)titleForCard:(Card *)card
//{
//    return (card.isChosen ? card.contents : @"");
//}

- (NSAttributedString*) attributedSymbolForSetCard:(SetCard *)card
{
    return [[NSAttributedString alloc] initWithString:[self symbolForSetCard:card] attributes:[self attributesForSetCard:card]];
}


- (NSString*) symbolForSetCard:(SetCard *)card
{
    NSDictionary *setCardSymbols = @{@(SetCardSymbolDiamond): @"▲",
                                     @(SetCardSymbolSquiggle): @"●",
                                     @(SetCardSymbolOval): @"◼︎"};
    
    return [setCardSymbols objectForKey:@(card.symbol)];
}


//handles color and shading
- (NSDictionary *) colorsForSetCard:(SetCard *)card
{
    NSDictionary *setCardColor = @{@(SetCardColorRed): [UIColor redColor],
                                     @(SetCardColorGreen): [UIColor greenColor],
                                     @(SetCardColorPurple): [UIColor purpleColor]};
    
    NSDictionary *setCardAlpha = @{@(SetCardShadingSolid): @(1.0),
                                   @(SetCardShadingStriped): @(.5),
                                   @(SetCardShadingOpen): @(0.0)};
    
    UIColor *strokeColor = [setCardColor objectForKey:@(card.color)];
    UIColor *foregroundColor = [strokeColor colorWithAlphaComponent:[[setCardAlpha objectForKey:@(card.shading)] floatValue]];
    
    NSMutableDictionary *colorAttributes = [[NSMutableDictionary alloc]init];
    //set NSStrokeWidthAttributeName
    //NSSStrokeColorAttributeNAme
    //NSForegroundColorAttributeName
    [colorAttributes addEntriesFromDictionary:@{NSStrokeWidthAttributeName : @-5,
                                                NSStrokeColorAttributeName : strokeColor,
                                                NSForegroundColorAttributeName : foregroundColor}];
    
    return colorAttributes;
    
}

- (NSDictionary *) attributesForSetCard:(SetCard *)card
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    
    //add normal font
    [attributes addEntriesFromDictionary:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    
    //return attributes based on SetCardShading and SetCardColor
    //For SetCardColor, set both stroke color and body color to be same
    //Can probably use constant stroke width
    [attributes addEntriesFromDictionary:[self colorsForSetCard:card]];
    
    return attributes;
    
}
     
//- (NSAttributedString*) attributedSymbolForSetCard:(SetCard *)card
//{
//    
//    
//    
//    
//}

@end
