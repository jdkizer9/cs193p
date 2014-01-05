//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SuperCardViewController.h"
#import "PlayingCardView.h"
//#import "PlayingCardDeck.h"
//#import "PlayingCard.h"
//#import "SetCardDeck.h"
//#import "SetCard.h"

@interface SuperCardViewController ()
@property (weak, nonatomic) IBOutlet CardView *cardView;
@property (strong, nonatomic) Deck *deck;

@end

@implementation SuperCardViewController


- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    self.cardView.faceUp = !self.cardView.faceUp;
    if (!self.cardView.faceUp) [self drawRandomCard];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self drawRandomCard];
    
    [self.cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.cardView action:@selector(pinch:)]];
}


- (void)drawRandomCard
{
    Card *card = [self.deck drawRandomCard];
    [self updateCardView:self.cardView forCard:card];
}

#pragma mark - Begin Abstract Methods
- (Deck *)createDeck
{
    return nil;
}

- (CardView *)createCardView
{
    return nil;
}

- (void)updateCardView:(CardView *)cardView forCard:(Card*)card
{
}

#pragma mark - End Abstract Methods

@end
