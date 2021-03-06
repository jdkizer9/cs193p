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
#import "CardGameAnimationLog.h"


@interface CardGameViewController () <UIDynamicAnimatorDelegate>
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *cardAreaView;
@property (nonatomic) CGRect lastCardAreaViewBounds;
@property (strong, nonatomic) NSMutableArray *cardViews; //of CardViews
@property (strong, nonatomic) NSMutableArray *cardsInPlay; //ofCards
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreCardsButton;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) CardGameAnimationLog *animationLog;


//set to nil every time a new card is added or removed
@property (nonatomic) BOOL generateHints;
@property (strong, nonatomic) NSMutableArray *hintArray;
@property (nonatomic) NSUInteger lastHintIndex;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;
@property (nonatomic) NSUInteger remainingHints;

//dynamic animator stuff
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *pileAttachment;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tapPileGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panPileGesture;


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

-(CardGameAnimationLog *)animationLog
{
    if (!_animationLog) _animationLog = [[CardGameAnimationLog alloc]init];
    return _animationLog;
}

-(NSMutableArray *)hintArray
{
    if(!_hintArray) _hintArray=[[NSMutableArray alloc]init];
    return _hintArray;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardAreaView];
        _animator.delegate = self;
    }
    return _animator;
}

- (UIPinchGestureRecognizer *)pinchGesture
{
    if(!_pinchGesture) _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    return _pinchGesture;
}

- (UITapGestureRecognizer *)tapPileGesture
{
    if (!_tapPileGesture) _tapPileGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPile:)];
    return _tapPileGesture;
}

- (UIPanGestureRecognizer *)panPileGesture
{
    if (!_panPileGesture) _panPileGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPile:)];
    return _panPileGesture;
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
    [self dealNewGame];
}

//this is invoked at startup and whenever a new game is to be dealt
- (void) dealNewGame
{
    //remove all existing cards
    //[self removeAllCardsAndViewsAndDiscard:NO];
    
    //reset the model to start a new game
    [self.game startNewGame];
    
    //reset number of remainigHints
    self.remainingHints = 3;
    
    
    
    //ensure that controller state is back to normal
    assert([self.cardViews count] == 0);
    assert([self.cardsInPlay count] == 0);
    //for specified number of cards
    //grab a card and associate it with a view by adding
    //it to the cardsInPlay array
    [self createNewCardsAndCardViews];
    //activate pinch gesture
    [self activatePinchGesture];
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



-(BOOL)addNewCardAndViewAtIndex:(NSUInteger)index
{
    
    //need to recompute hints
    self.generateHints = YES;
    
    Card *card = [self.game drawCardFromDeck];
    if (card)
    {
        CardView *cardView = [self newCardViewWithFrame:[self.grid frameForCellAtIndex:index]
                                                atPoint:[self.grid centerForCellAtIndex:index]
                                       withDisplayIndex:index];
        if (cardView)
        {
            //now that both have been successfully created, add to structures
            [self.cardsInPlay insertObject:card atIndex:index];
            [self.cardViews insertObject:cardView atIndex:index];
            
            //need to initialize tapCardGesture for each cardView
            cardView.tapCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardViewTap:)];
            [cardView addGestureRecognizer: cardView.tapCardGesture];
            
            //add cardView to super view
            [self.cardAreaView addSubview:cardView];
            
            return YES;
            
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
    return NO;
}

- (CardView *)newCardViewWithFrame:(CGRect)frame
                           atPoint:(CGPoint)center
                  withDisplayIndex:(NSUInteger)displayIndex
{
    CardView *cardView = [[self.viewCardClass alloc]initWithFrame:frame
                                                  andDisplayIndex:displayIndex];
    
    //this will be configured to the acutal deal location
    //prior to animation
    CGPoint dealLocation = CGPointMake(self.cardAreaView.bounds.origin.x + (self.cardAreaView.bounds.size.width)/2, self.cardAreaView.bounds.origin.y + (self.cardAreaView.bounds.size.height)*2);
    cardView.center = dealLocation;
    
    //animate dealing from point below screen
    //setting moveToPoint causes animation
    [self moveCardView:cardView
               toPoint:center];
    
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
    [self moveCardView:cardView
               toPoint:ADD_REMOVE_POINT];
    
    //need to recompute hints
    self.generateHints = YES;
}

//this updates all cardViews centers and frames
//this should be invoked when orientation has been updated
- (void)updateCardViewsCentersAndFrames
{
    
    if (self.animationLog.animating)
        return;
    
    __weak CardGameViewController *weakself = self;
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         for (int i=0; i<[weakself.cardViews count];i++)
                         {
                             CardView *cardView = weakself.cardViews[i];
                             
                             cardView.frame = [weakself.grid frameForCellAtIndex:cardView.displayIndex];
                             cardView.center = [weakself.grid centerForCellAtIndex:cardView.displayIndex];
                         }
                     }
                     completion:^(BOOL completed){
                         [weakself updateUI];
                     }];
    
    
    
    
}

- (void)moveCardView:(CardView*)cardView
             toPoint:(CGPoint)point
{
    
    if(CGPointEqualToPoint(point, ADD_REMOVE_POINT))
       [self addAnimationLogEntry:[[CardGameAnimationLogEntry alloc]initWithAnimationType:CardGameAnimationRemoveCard
                                                                             withCardView:cardView
                                                                                withPoint:point]];
    else
        [self addAnimationLogEntry:[[CardGameAnimationLogEntry alloc]initWithAnimationType:CardGameAnimationMoveCard
                                                                              withCardView:cardView
                                                                                 withPoint:point]];
        
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self updateCardViewsCentersAndFrames];
    //[self updateUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
    
    [self updateCardViewsCentersAndFrames];
    //[self updateUI];
}

- (void)addAnimationLogEntry:(CardGameAnimationLogEntry*)entry
{
    [self.animationLog addAnimationEntry:entry];
}

- (void)activateCardViewTapGestures
{
    for (CardView *cardView in self.cardViews)
    {
        if (![cardView.gestureRecognizers containsObject:cardView.tapCardGesture])
            [cardView addGestureRecognizer: cardView.tapCardGesture];
    }
}

- (void)deactivateCardViewTapGestures
{
    for (CardView *cardView in self.cardViews)
    {
        if ([cardView.gestureRecognizers containsObject:cardView.tapCardGesture])
            [cardView removeGestureRecognizer: cardView.tapCardGesture];
    }
}

- (void)handleCardViewTap:(UITapGestureRecognizer *)gesture
{
    if (self.animationLog.isAnimating)
        return;
    
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

- (void)activatePinchGesture
{
    if (![self.cardAreaView.gestureRecognizers containsObject:self.pinchGesture])
        [self.cardAreaView addGestureRecognizer:self.pinchGesture];
}

- (void)deactivatePinchGesture
{
    if ([self.cardAreaView.gestureRecognizers containsObject:self.pinchGesture])
        [self.cardAreaView removeGestureRecognizer:self.pinchGesture];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        //when pinch starts, attach each cardView to center of cardAreaView using
        //(void)attachCardViewToPoint:(CGPoint)anchorPoint withAnimator:(UIDynamicAnimator *)animator;
        //update attachment length using
        //(void)setCardViewAttachmentLengthFactor:(CGFloat)attachmentLengthFactor;
        
        for (CardView *cardView in self.cardViews)
        {
            [cardView attachCardViewToPoint:self.cardAreaView.center withAnimator:self.animator];
            [cardView setCardViewAttachmentLengthFactor:gesture.scale];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        //update attachment length using
        //(void)setCardViewAttachmentLengthFactor:(CGFloat)attachmentLengthFactor;
        for (CardView *cardView in self.cardViews)
        {
            [cardView setCardViewAttachmentLengthFactor:gesture.scale];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        //when ended, if scale > 1, move cards to their original position
        //if scale < 1, deactive pinch gesture
        //remove tap gesture from all cards, move cards into the middle
        
        
        
        //remove attachment behavior from all cardViews
        for (CardView *cardView in self.cardViews)
        {
            [cardView removeCardViewFromAttachmentWithAnimator:self.animator];
        }
        
        if ( (gesture.state == UIGestureRecognizerStateEnded && gesture.scale > 1.0) || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled )
        {
            [self updateCardViewsCentersAndFrames];
        }
        else
        {
            [self deactivatePinchGesture];
            [self deactivateCardViewTapGestures];
            
            __weak CardGameViewController *weakself = self;
            [UIView animateWithDuration:.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 for (int i=0; i<[weakself.cardViews count];i++)
                                 {
                                     CardView *cardView = weakself.cardViews[i];
                                     
                                     cardView.frame = [weakself.grid frameForCellAtIndex:cardView.displayIndex];
                                     cardView.center = self.cardAreaView.center;
                                 }
                             }
                             completion:^(BOOL completed){
                                 [weakself completePinchGesture];
                             }];
            
        }
        
    }
    
    
    
    //when
    
//    if((gesture.state == UIGestureRecognizerStateChanged) || gesture.state == UIGestureRecognizerStateEnded)
//    {
//        self.faceCardScaleFactor *= gesture.scale;
//        gesture.scale = 1.0;
//    }
}

- (void)completePinchGesture
{
    //remove all but top card (creates pile)
    //add tap and pan gestures to pile
    
    //how to determine top card?
    
    //last added card
    CardView *pileCardView = [[self.cardAreaView subviews]lastObject];
    
    for (CardView *cardView in self.cardViews)
    {
        if (cardView == pileCardView)
            continue;
        //try hiding the cards
        cardView.hidden = YES;
    }
    
    [self activatePanPileGesture:pileCardView];
    [self activateTapPileGesture:pileCardView];
    
    [self updateUI];
}

- (void)activateTapPileGesture:(CardView *)cardView
{
    if (![cardView.gestureRecognizers containsObject:self.tapPileGesture])
        [cardView addGestureRecognizer:self.tapPileGesture];
}

- (void)deactivateTapPileGesture:(CardView *)cardView
{
    if ([cardView.gestureRecognizers containsObject:self.tapPileGesture])
        [cardView removeGestureRecognizer:self.tapPileGesture];
}

- (void)tapPile:(UITapGestureRecognizer *)gesture
{
    //remove tapPile and panPile behaviors
    CardView *pileCardView = (CardView *)gesture.view;
    [self deactivateTapPileGesture:pileCardView];
    [self deactivatePanPileGesture:pileCardView];
    
    for (CardView *cardView in self.cardViews)
    {
        if (cardView == pileCardView)
            continue;
        //try unhiding the cards
        cardView.center = pileCardView.center;
        cardView.hidden = NO;
    }
    
    __weak CardGameViewController *weakself = self;
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         for (int i=0; i<[weakself.cardViews count];i++)
                         {
                             CardView *cardView = weakself.cardViews[i];
                             
                             cardView.frame = [weakself.grid frameForCellAtIndex:cardView.displayIndex];
                             cardView.center = [weakself.grid centerForCellAtIndex:cardView.displayIndex];
                         }
                     }
                     completion:^(BOOL completed){
                         [weakself completeTapPileGesture];
                     }];
    
    
}

- (void) completeTapPileGesture
{
    //activate tap behaviors
    [self activateCardViewTapGestures];
    //activate pinch behavior
    [self activatePinchGesture];
}

- (void)activatePanPileGesture:(CardView *)cardView
{
    if (![cardView.gestureRecognizers containsObject:self.panPileGesture])
        [cardView addGestureRecognizer:self.panPileGesture];
}

- (void)deactivatePanPileGesture:(CardView *)cardView
{
    if ([cardView.gestureRecognizers containsObject:self.panPileGesture])
        [cardView removeGestureRecognizer:self.panPileGesture];
}

- (void)panPile:(UIPanGestureRecognizer *)gesture
{
    //pan gesture moves the pile of cards around cardViewArea
    
    CGPoint gesturePoint = [gesture locationInView:self.cardAreaView];
    CardView *cardView = (CardView *)gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.pileAttachment = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:gesturePoint];
        [self.animator addBehavior:self.pileAttachment];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.pileAttachment.anchorPoint = gesturePoint;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.pileAttachment];
        for (CardView *cv in self.cardViews)
        {
            cv.center = cardView.center;
        }
    }
}

- (IBAction)touchDealButton:(UIButton *)sender {
    
    if (self.animationLog.isAnimating)
        return;
    
    //reset state of the game
    [self removeAllCardsAndViewsAndDiscard:NO];
    [self dealNewGame];
    [self updateUI];
    
}

- (IBAction)touchMoreCardsButton:(UIButton *)sender {
    
    if (self.animationLog.isAnimating)
        return;
    
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
        if (![self addNewCardAndViewAtIndex:index])
            break;
        i++;
    }
    
    //penalized based on the number of possible moves
    [self.game hintPenalty:[self.hintArray count]];
    
    [self updateUI];
}

- (IBAction)touchHintButton:(UIButton *)sender {
    
    if (self.animationLog.isAnimating)
        return;
    
    assert([self.hintArray count] > 0);
    
    NSMutableArray *hint = self.hintArray[self.lastHintIndex];
    for (Card *card in hint)
    {
        CardView *cardView = [self cardViewFromCard:card];
        [self addAnimationLogEntry:[[CardGameAnimationLogEntry alloc]initWithAnimationType:CardGameAnimationHintCard
                                                                              withCardView:cardView
                                                                                 withPoint:CGPointMake(0, 0)]];
    }
    
    self.lastHintIndex = (self.lastHintIndex + 1)%[self.hintArray count];
    self.remainingHints--;
    
    //penalized based on the number of possible moves
    [self.game hintPenalty:[self.hintArray count]];
    
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

- (CardView*)cardViewFromCard:(Card*)card
{
    CardView *cardView = nil;
    
    assert([self.cardViews count] == [self.cardsInPlay count]);
    
    for (int i=0; i<[self.cardsInPlay count]; i++)
    {
        if (self.cardsInPlay[i] == card)
        {
            cardView = self.cardViews[i];
            break;
        }
    }
    
    return cardView;
}

//going to try to only touch the UI here
//use game state data for anything that needs to be updated
- (void)updateUI
{
    assert([self.cardViews count] == [self.cardsInPlay count]);

    int cardViewCount = [self.cardViews count];
    
    //need to iterate over this backwards, as some objects could be removed
    //from the arrays
    for (int i=(cardViewCount-1); i>=0; i--)
    {
        assert([self.cardViews count] > i);
        assert([self.cardsInPlay count] > i);
        CardView *cardView = self.cardViews[i];
        Card *card = self.cardsInPlay[i];
        
        [self updateCardView:cardView forCard:card];
        
        if (card.isMatched)
        {
            //remove card
            [self removeCard:card andCardView:cardView andDiscard:NO];
            
            card = nil;
            cardView = nil;
            
            //add new card
            if ([self addNewCardAndViewAtIndex:i])
            {
                cardView = self.cardViews[i];
                card = self.cardsInPlay[i];
            }
        }
        
        //not sure I need to do this every time
        if (card && cardView)
            [self updateCardView:cardView forCard:card];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    //save off cardAreaView bounds
    self.lastCardAreaViewBounds = self.cardAreaView.bounds;
    
    self.moreCardsButton.enabled = ([self.game numberOfUndrawnCards] != 0);
    
    [self performHintGeneration];
    if ([self.hintArray count] && (self.remainingHints>0))
        self.hintButton.enabled = YES;
    else
        self.hintButton.enabled = NO;
    [self.animationLog performAnimations];
    
}

- (void)performHintGeneration
{
    if (!self.generateHints)
        return;
    
    self.generateHints = NO;
    self.lastHintIndex = 0;
    self.hintArray = nil;
    
    int cardCount = [self.cardsInPlay count];
    
    if (cardCount < self.matchCount)
        return;
    
    NSArray *hintTryArray = [[NSArray alloc] initWithArray:[self combinationHelper:self.cardsInPlay withChooseCount:[self matchCount]]];
    
    for (id obj in hintTryArray)
    {
        if ([self.game matchForHint:obj])
            [self.hintArray addObject:obj];
    }
}



//this function returns an array containg an array of objects for each possible combination
//of the objects
- (NSArray *)generateCombinations:(NSArray *)objects withChooseCount:(NSUInteger)chooseCount
{
    NSMutableArray *combinationArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<=([objects count]-chooseCount); i++)
    {
        NSRange slicedArrayRange;
        slicedArrayRange.location = i+1;
        slicedArrayRange.length = [objects count]-(i+1);
        NSArray *subArray = [[NSArray alloc]initWithArray:[objects subarrayWithRange:slicedArrayRange]];
        
        NSMutableArray *returnedArray = [[NSMutableArray alloc]initWithArray:[self combinationHelper:subArray
                                                                                     withChooseCount:chooseCount-1]];
        
        //for each item in returned array, add the sliced off object
        for (id obj in returnedArray)
        {
            assert([obj isKindOfClass:[NSMutableArray class]]);
            if ([obj isKindOfClass:[NSMutableArray class]])
                [obj insertObject:objects[i] atIndex:0];
            
            assert([obj count] == chooseCount);
            [combinationArray addObject:obj];
        }
    }
    return combinationArray;
}


- (NSArray *)combinationHelper:(NSArray *)objects withChooseCount:(NSUInteger)chooseCount
{
    
    assert([objects count] >= chooseCount);
    assert(chooseCount > 0);
    
    if([objects count] == chooseCount)
    {
        NSMutableArray *returnArray = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc]initWithArray:objects], nil];
        return returnArray;
    }
    
    //if 1, return array of 1 object arrays
    if (chooseCount == 1)
    {
        NSMutableArray *objectArray = [[NSMutableArray alloc]init];
        for (id obj in objects)
            [objectArray addObject:[[NSMutableArray alloc]initWithObjects:obj, nil]];
        
        return objectArray;
    }
    
    NSMutableArray *combinationArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<=([objects count]-chooseCount); i++)
    {
        //else, slice off an object and recurse
        NSRange slicedArrayRange;
        slicedArrayRange.location = i+1;
        slicedArrayRange.length = [objects count]-(i+1);
        NSArray *subArray = [[NSArray alloc]initWithArray:[objects subarrayWithRange:slicedArrayRange]];
        NSMutableArray *returnedArray = [[NSMutableArray alloc]initWithArray:[self combinationHelper:subArray
                                                                                     withChooseCount:chooseCount-1]];
        
        //for each item in returned array, add the sliced off object
        for (id obj in returnedArray)
        {
            assert([obj isKindOfClass:[NSMutableArray class]]);
            if ([obj isKindOfClass:[NSMutableArray class]])
                [obj insertObject:objects[i] atIndex:0];
            
            assert([obj count] == chooseCount);
            [combinationArray addObject:obj];
        }
    }
    return combinationArray;
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
