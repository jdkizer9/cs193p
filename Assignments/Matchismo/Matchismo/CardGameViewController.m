//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardGameHistoryLog.h"
#import "CardGameHistoryEntry.h"


@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchCountSegCon;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@end

@implementation CardGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    
}
- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

//abstract
- (Deck *)createDeck
{
    return nil;
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
    
    [self updateLastLabel];

}


//abstract
- (NSString *)textDescriptionOfCard:(Card*)card
{
    return nil;
}

- (void)updateLastLabel
{
    CardGameHistoryEntry *entry = [self.game.historyLog.log lastObject];
    self.lastActionLabel.text = @"New Game!!";
    
    if (entry)
    {
        NSString *labelString;
        if (entry.score == 0)
        {
            Card *card = [entry.cards lastObject];
            
            //generic CardGameViewController has no idea how to represent whatever
            //type of card it is. Ensure the subclass view controller translates
            labelString = [self textDescriptionOfCard:card];
        }
        else if(entry.score > 0)
        {
            labelString = @"Matched ";
            for (Card *card in entry.cards)
                labelString = [labelString stringByAppendingFormat:@"%@ ", [self textDescriptionOfCard:card]];
            labelString = [labelString stringByAppendingFormat:@"for %d points.", entry.score];
        }
        else
        {
            labelString = @"";
            for (Card *card in entry.cards)
                labelString = [labelString stringByAppendingFormat:@"%@ ", [self textDescriptionOfCard:card]];
            labelString = [labelString stringByAppendingFormat:@"don't match! %d point penalty!", entry.score];
        }
        
        self.lastActionLabel.text = labelString;
        
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



@end
