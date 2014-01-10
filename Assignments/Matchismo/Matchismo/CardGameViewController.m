//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "Grid.h"


@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *cardAreaView;
@property (nonatomic) CGRect lastCardAreaViewBounds;
@property (strong, nonatomic) NSMutableArray *cardViews; //of CardViews
@property (strong, nonatomic) NSMutableArray *cardsInPlay; //ofCards
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreCardsButton;
@property (strong, nonatomic) Grid *grid;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    
    if (!_game) _game = [[CardMatchingGame alloc] initUsingDeck:[self createDeck]
                                                 withMatchCount:self.matchCount];
    
    return _game;
}

-(NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc]init];
    return _cardViews;
}

-(NSMutableArray *)cardsInPlay
{
    if (!_cardsInPlay) _cardsInPlay = [[NSMutableArray alloc]init];
    return _cardsInPlay;
}

-(Grid *)grid
{
    if (!_grid) _grid = [[Grid alloc]init];
    
    int numberOfCardViews = self.numberOfVisibleCards;
    
    _grid.size = self.cardAreaView.bounds.size;
    _grid.cellAspectRatio = 2.0/3.0;
    _grid.numberOfCells = numberOfCardViews;
    
    if (_grid.inputsAreValid)
        return _grid;
    else
        return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self updateUI];
    
}

//one time setup and deal first game
- (void)setup
{
    //begin generating device orientation notifications
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:[UIDevice currentDevice]];

    [self dealNewGame];
    
}

//this is invoked at startup and whenever a new game is to be dealt
- (void) dealNewGame
{
    //remove all existing cards
    [self removeAllCardsAndViewsAndDiscard:NO];
    
    //reset the model to start a new game
    [self.game startNewGame];
    
    //ensure that controller state is back to normal
    assert([self.cardViews count] == 0);
    assert([self.cardsInPlay count] == 0);
    //for specified number of cards
    //grab a card and associate it with a view by adding
    //it to the cardsInPlay array
    [self createNewCardsAndCardViews];
}

- (void)createNewCardsAndCardViews
{
    //for specified number of visible cards
    int numberOfCardViews = self.numberOfVisibleCards;
    
    //create cards and cardViews
    for (int i=0; i<numberOfCardViews; i++)
    {
        //create new card and cardView
        [self addNewCardAndViewAtIndex:i];
    }
    
    assert([self.cardViews count] == self.numberOfVisibleCards);
    assert([self.cardsInPlay count] == self.numberOfVisibleCards);
}



-(void)addNewCardAndViewAtIndex:(NSUInteger)index
{
    
    Card *card = [self.game drawCardFromDeck];
    if (card)
    {
        CardView *cardView = [self newCardViewWithFrame:[self.grid frameForCardViewAtIndex:index]
                                                atPoint:[self.grid centerForCardViewAtIndex:index]];
        if (cardView)
        {
            //now that both have been successfully created, add to structures
            [self.cardsInPlay insertObject:card atIndex:index];
            [self.cardViews insertObject:cardView atIndex:index];
            
            //need to add gestureRecognizer for each cardView
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardViewTap:)]];
            
            //add cardView to super view
            [self.cardAreaView addSubview:cardView];
            
            //animate new card being dealt
            
        }
        else
        {
            //this is a major error
        }
        
    }
    
    else
    {
        //no more cards in deck
        //do something graceful
        
        //disable more cards button
        self.moreCardsButton.enabled = NO;
    }
}

- (CardView *)newCardViewWithFrame:(CGRect)frame
                           atPoint:(CGPoint)center
{
    CardView *cardView = [[self.viewCardClass alloc]initWithFrame:frame];
    cardView.center = center;
    return cardView;
}

-(void)removeAllCardsAndViewsAndDiscard:(BOOL)discard
{
    int numberOfCardsToRemove = [self.cardsInPlay count];
    for (int i=0;i<numberOfCardsToRemove;i++)
    {
        //remove last object since both cardViews and cardsInPlay
        //are being modified as we iterate over them
        CardView *cardView = [self.cardViews lastObject];
        Card *card = [self.cardsInPlay lastObject];
        [self removeCard:card andCardView:cardView andDiscard:discard];
    }
    
    assert([self.cardViews count] == 0);
    assert([self.cardsInPlay count] == 0);
    
}

-(void)removeCard:(Card*)card andCardView:(CardView*)cardView andDiscard:(BOOL)discard
{
    //remove card from cardsInPlay
    //optionally add to discard pile
    [self.cardsInPlay removeObject:card];
    card.chosen = NO;
    if (discard)
        [self.game addCardToDiscardPile:card];
    
    [self.cardViews removeObject:cardView];
    
    //remove cardView from superView
    [cardView removeFromSuperview];
    
    //animate removal of cardView here
    
}

//this updates all cardViews centers and frames
//this should be invoked when orientation has been updated
- (void)updateCardViewsCentersAndFrames
{
    for (int i=0; i<self.numberOfVisibleCards;i++)
    {
        CardView *cardView = self.cardViews[i];
        cardView.frame = [self.grid frameForCardViewAtIndex:i];
        cardView.center = [self.grid centerForCardViewAtIndex:i];
        //notify that the card should be redrawn
        [cardView setNeedsDisplay];
    }
}

-(BOOL)cardAreaViewBoundsChanged
{
    CGRect cardAreaViewBounds = self.cardAreaView.bounds;
    
    BOOL originChanged = (self.lastCardAreaViewBounds.origin.x != cardAreaViewBounds.origin.x) || (self.lastCardAreaViewBounds.origin.y != cardAreaViewBounds.origin.y);
    
    BOOL sizeChanged = (self.lastCardAreaViewBounds.size.height != cardAreaViewBounds.size.height) ||
    (self.lastCardAreaViewBounds.size.width != cardAreaViewBounds.size.width);
    
    if (originChanged || sizeChanged)
        return YES;
    else
        return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self updateCardViewsCentersAndFrames];
    [self updateUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateCardViewsCentersAndFrames];
    [self updateUI];
}

- (void)handleCardViewTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CardView *cardView= (CardView *)gesture.view;
        Card *card = [self cardFromCardView:cardView];
        if (card)
        {
            [self.game chooseCard:card];
        }
        [self updateUI];
    }
}

- (IBAction)touchDealButton:(UIButton *)sender {
    //reset state of the game
    [self dealNewGame];
    [self updateUI];
    
}
- (IBAction)touchMoreCardsButton:(UIButton *)sender {
    
    
    //this should only be enabled if there are no empty spaces on the board
    //and there are available cards left in the deck
    assert(self.numberOfVisibleCards == [self.cardViews count]);
    assert(self.numberOfVisibleCards == [self.cardsInPlay count]);
    assert([self.game numberOfUndrawnCards] > 0);
    int numberOfNewCardsToDraw = [self numberOfNewCardsToDraw];
    
    //select n cards at random to replace
    NSMutableArray *cardIndexArray = [[NSMutableArray alloc]init];
    
    int i=0;
    while (i<numberOfNewCardsToDraw)
    {
        //NSUInteger index = arc4random() % [self.cardViews count];
        int index = (arc4random() % [self.cardViews count]);
        NSNumber *cardIndexNumber = [[NSNumber alloc] initWithInt:index];
        
        if ([cardIndexArray containsObject:cardIndexNumber])
            continue;
        
        [cardIndexArray addObject:cardIndexNumber];

        //remove card
        [self removeCard:self.cardsInPlay[index] andCardView:self.cardViews[index] andDiscard:NO];
        
        //add new card
        [self addNewCardAndViewAtIndex:index];
        i++;
    }
    
    [self updateUI];
}



- (Card*)cardFromCardView:(CardView*)cardView
{
    Card *card = nil;
    
    assert([self.cardViews count] == [self.cardsInPlay count]);
    
    for (int i=0; i<[self.cardViews count]; i++)
    {
        if (self.cardViews[i] == cardView)
        {
            card = self.cardsInPlay[i];
            break;
        }
    }
   
    return card;
}

//going to try to only touch the UI here
//use game state data for anything that needs to be updated
- (void)updateUI
{
    assert([self.cardViews count] == [self.cardsInPlay count]);

    int cardViewCount = [self.cardViews count];
    for (int i=0; i<cardViewCount; i++)
    {
        
        CardView *cardView = self.cardViews[i];
        Card *card = self.cardsInPlay[i];
        
        if (card.isMatched)
        {
            //remove card
            [self removeCard:card andCardView:cardView andDiscard:NO];
            
            //add new card
            [self addNewCardAndViewAtIndex:i];
            
            cardView = self.cardViews[i];
            card = self.cardsInPlay[i];
        }
        
        //not sure I need to do this every time
        [self updateCardView:cardView forCard:card];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    //save off cardAreaView bounds
    self.lastCardAreaViewBounds = self.cardAreaView.bounds;
    
    self.moreCardsButton.enabled = ([self.game numberOfUndrawnCards] != 0);
    
}



//ABSTRACT METHODS
//abstract
- (Deck *)createDeck
{
    return nil;
}

//abstract
- (void)updateCardView:(CardView *)cardView
               forCard:(Card*)card
{
    
}

//abstract
- (NSInteger)numberOfVisibleCards
{
    return 0;    
}

- (NSInteger)numberOfNewCardsToDraw
{
    return 3;
}

- (Class)viewCardClass
{
    return nil;
}



//END ABSTRACT METHODS




@end
