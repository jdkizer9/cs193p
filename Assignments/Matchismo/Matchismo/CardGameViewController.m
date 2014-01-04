//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardGameHistoryViewController.h"
#import "CardGameHistoryLog.h"
#import "CardGameHistoryEntry.h"


@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
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
                                                          usingDeck:[self createDeck]
                                                         matchCount:[self matchCount]];
    return _game;
}



- (IBAction)touchCardButton:(UIButton *)sender
{
    
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
    
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[self historySegueIDName]])
    {
        if ([segue.destinationViewController isKindOfClass:[CardGameHistoryViewController class]])
        {
            CardGameHistoryViewController *cghVC = (CardGameHistoryViewController *)segue.destinationViewController;
            
            NSMutableAttributedString *historyAS = [[NSMutableAttributedString alloc] init];
            
            //iterate over all entries in the log
            int i=0;
            for (CardGameHistoryEntry *entry in self.game.historyLog.log)
            {
                i++;
                [historyAS appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d: ", i] attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}]];
                [historyAS appendAttributedString:[self attributedStringFromCardGameHistoryEntry:entry]];
                [historyAS appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
            if (i==0)
                [historyAS appendAttributedString:[[NSAttributedString alloc] initWithString:@"New Game"]];
            
            cghVC.historyText = historyAS;
        }
    }
}

//going to try to only touch the UI here
//use game state data for anything that needs to be updated
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [self updateCardButton:cardButton forCard:card];
        
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

}

//ABSTRACT METHODS
//abstract
- (Deck *)createDeck
{
    return nil;
}

//abstract
- (void)updateCardButton:(UIButton *)cardButton
                 forCard:(Card*)card
{
    
}

//abstract
- (NSAttributedString *) attributedStringFromCardGameHistoryEntry:(CardGameHistoryEntry *)entry
{
    return nil;
}

//abstract
- (NSString *)historySegueIDName
{
    return nil;
}
//END ABSTRACT METHODS




@end
