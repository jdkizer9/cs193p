//
//  PlayingCard.m
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠",@"♣",@"♥",@"♦"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

//this matching algorithm takes n>=1 PlayingCards in otherCards
//it recursively computes the match score between cards in the array
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] > 1)
    {
        //slice first object off array and recurse
        PlayingCard *otherCard = [otherCards firstObject];
        NSArray *otherArray = [otherCards subarrayWithRange:NSMakeRange(1, [otherCards count]-1)];
        score += [otherCard match:otherArray];
    }
    for (PlayingCard *otherCard in otherCards)
    {
        score += ([self suitMatch:otherCard] + [self rankMatch:otherCard]);
    }
    return score;
}

static const int SUIT_MATCH=1;
- (int)suitMatch:(PlayingCard *)otherCard
{
    return [self.suit isEqualToString:otherCard.suit] ? SUIT_MATCH : 0;
}

static const int RANK_MATCH=4;
- (int)rankMatch:(PlayingCard *)otherCard
{
    return (self.rank == otherCard.rank) ? RANK_MATCH : 0;
}


@end
