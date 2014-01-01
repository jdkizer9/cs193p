//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchCountSegCon;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    //could move this assignment into the model
    //(e.g., chooseCardAtIndex) and make isBegun readonly
    if (!self.game.isBegun)
    {
        self.game.begun = YES;
        NSString *stringVal = [self.matchCountSegCon titleForSegmentAtIndex:self.matchCountSegCon.selectedSegmentIndex];
        self.game.matchCount = [stringVal integerValue];
    }
    
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
}

- (IBAction)touchDealButton:(id)sender {
    //reset state of the game
    //by stetting game to nil, this will cause game's getter
    //to lazily instantite a new game
    //is this a good solution? better than calling initializer?
    self.game = nil;
    
    //enable segmented control / moved to updateUI
    [self updateUI];
}


//going to try to only touch the UI here
//use game state data for anything that needs to be updated
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    //only enable SegCon if game has not begun
    self.matchCountSegCon.enabled = !self.game.isBegun;
    
    
    //set lastAction label
    if (self.game.lastScore == 0) {
        self.lastActionLabel.text = self.game.lastCard.contents;
    }
    else if (self.game.lastScore > 0)
    {
        self.lastActionLabel.text = [NSString stringWithFormat:@"Matched %@ ",
                                                       self.game.lastCard.contents];
        for (Card *otherCard in self.game.lastOtherCards)
            self.lastActionLabel.text = [self.lastActionLabel.text stringByAppendingFormat:@"%@ ", otherCard.contents];
        
        self.lastActionLabel.text = [self.lastActionLabel.text stringByAppendingFormat:@"for %d points. ", self.game.lastScore];
        
    }
    else
    {
        self.lastActionLabel.text = [NSString stringWithFormat:@"%@ ",
                                     self.game.lastCard.contents];
        for (Card *otherCard in self.game.lastOtherCards)
            self.lastActionLabel.text = [self.lastActionLabel.text stringByAppendingFormat:@"%@ ", otherCard.contents];
        
        self.lastActionLabel.text = [self.lastActionLabel.text stringByAppendingFormat:@"don't match! %d point penalty!", -(self.game.lastScore)];
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return (card.isChosen ? card.contents : @"");
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" :@"cardback")];
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


@end
