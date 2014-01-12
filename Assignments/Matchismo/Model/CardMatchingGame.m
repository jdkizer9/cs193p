//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by James Kizer on 1/1/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardMatchingGame.h"
//#import "CardGameHistoryEntry.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;

//cards (full deck) is "shuffled" at init
//to simulate "drawing" a card, we have added isDrawn property to card
//a card can be replaced to the deck by removing the card from cards
//adding it to the back of cards and setting drawn to 0
//this would break cardAtIndex and chooseCardAtIndex code
//however, it does not appear that cardAtIndex is used outside of
//chooseCardAtIndex anymore. Perhaps we can pass a Card handle to
//chooseCard instead
@property (nonatomic, strong) NSMutableArray *cards; //of Cards
@property (nonatomic, readwrite) NSInteger matchCount;
@property (nonatomic, strong) Deck *deck;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initUsingDeck:(Deck *)deck
                       withMatchCount:(NSInteger)matchCount


{
    self = [super init];
    if (self)
    {
        //deck is shuffled at init
        self.matchCount = matchCount;
        //make a copy in order to be able to
        //shuffle deck
        self.deck = [deck copy];
        int cardsInDeck = [deck cardsInDeck];
        for(int i=0; i<cardsInDeck; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                [self.cards addObject:card];
                
            } else
            {
                self = nil;
                break;
            }
        }
    }
    return self;
}

//returns the first card in self.cards that is not marked as drawn
- (Card *)drawCardFromDeck
{
    Card *firstUndrawnCard = nil;
    if ([self.cards count])
    {
        for (id obj in self.cards)
        {
            if ([obj isKindOfClass:[Card class]])
            {
                Card *card = (Card*)obj;
                if (!card.isDrawn)
                {
                    card.drawn = YES;
                    assert(!card.isDiscarded);
                    firstUndrawnCard = card;
                    break;
                }
            }
        }
    }
    return firstUndrawnCard;
}

- (NSUInteger)numberOfUndrawnCards
{
    int numberOfUndrawnCards = 0;
    
    if ([self.cards count])
    {
        for (id obj in self.cards)
        {
            if ([obj isKindOfClass:[Card class]])
            {
                Card *card = (Card*)obj;
                if (!card.isDrawn)
                {
                    assert(!card.isDiscarded);
                    numberOfUndrawnCards++;
                }
            }
        }
    }
    return numberOfUndrawnCards;
}

//This function simulates adding a card to the back of the deck
- (void)returnCardToBackOfDeck:(Card*)card
{
    assert(card.isDrawn);
    
    //remove card from self.cards
    [self.cards removeObject:card];
    
    //set drawn to NO
    card.drawn = NO;
    
    //add card to back of self.cards
    //addObject inserts at end of array
    [self.cards addObject:card];
}

- (void)addCardToDiscardPile:(Card *)card
{
    card.discarded = YES;
}

- (void)startNewGame
{
    [self shuffleDeckAndReset:YES];
    self.score = 0;
}

- (void)shuffleDeckAndReset:(BOOL)reset
{
    Deck *copyOfDeck = [self.deck copy];
    
    //reinitialize cards
    self.cards = [[NSMutableArray alloc] init];
    
    //deck still contains the SAME card objects as before
    //I think??
    for(int i=0; i<[self.deck cardsInDeck]; i++)
    {
        Card *card = [copyOfDeck drawRandomCard];
        if (card)
        {
            if (reset)
            {
                card.drawn = NO;
                card.matched = NO;
                card.chosen = NO;
                card.discarded = NO;
            }
            [self.cards addObject:card];
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    [self chooseCard: card];
}

- (void) chooseCard:(Card *)card
{
    NSInteger moveScore = 0;
    
    if (!card.isMatched)
    {
        if (card.isChosen)
        {
            card.chosen = NO;
        }
        else
        {
            //match against other card(s)
            NSMutableArray *matchArray = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isChosen && !otherCard.isMatched)
                {
                    //add to matchArray
                    [matchArray addObject:otherCard];
                    
                    //if correct number of cards have been chosen, try to match
                    if ([matchArray count] == (self.matchCount-1))
                    {
                        int matchScore = [card match:matchArray];
                        if (matchScore)
                        {
                            //if a match was found, update score
                            moveScore = matchScore * MATCH_BONUS;
                            card.matched = YES;
                            for (Card *anotherCard in matchArray)
                            {
                                anotherCard.matched = YES;
                            }
                        }
                        else
                        {
                            moveScore = -MISMATCH_PENALTY;
                            for (Card *anotherCard in matchArray)
                            {
                                anotherCard.chosen = NO;
                            }
                            
                        }
                        self.score += moveScore;
                        break;
                        
                    }
                    
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
}

- (BOOL)matchForHint:(NSArray *)cardArray
{
    assert([cardArray count] == self.matchCount);
    
    Card *card = cardArray[0];
    
    NSRange slicedArrayRange;
    slicedArrayRange.location = 1;
    slicedArrayRange.length = [cardArray count]-1;
    
    if ([card match:[cardArray subarrayWithRange:slicedArrayRange]])
        return YES;
    else
        return NO;
}

- (void)hintPenalty:(NSUInteger)penalty
{
    self.score -= penalty;
}


@end
