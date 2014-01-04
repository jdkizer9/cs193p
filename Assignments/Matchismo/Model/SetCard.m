//
//  SetCard.m
//  Matchismo
//
//  Created by James Kizer on 1/3/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (void)setNumber:(SetCardNumber)number
{
    if (number > SetCardNumberNone &&  number < SetCardNumberMax) {
        _number = number;
    }
}

- (void)setSymbol:(SetCardSymbol)symbol
{
    if (symbol > SetCardSymbolNone &&  symbol < SetCardSymbolMax) {
        _symbol = symbol;
    }
}

- (void)setShading:(SetCardShading)shading
{
    if (shading > SetCardShadingNone &&  shading < SetCardShadingMax) {
        _shading = shading;
    }
}

- (void)setColor:(SetCardColor)color
{
    if (color > SetCardColorNone &&  color < SetCardColorMax) {
        _color = color;
    }
}

- (NSDictionary *)attributes
{
    return @{@"number": @(self.number),
             @"symbol": @(self.symbol),
             @"shading": @(self.shading),
             @"color": @(self.color)};
}


//this matching algorithm takes n >= 1 SetCards in otherCards
//with each card containing an m length dictionary
//match is essentially boolean
//match occurs if for each attribute:
//  -all three cards match OR all three cards are different
static const int SET_MATCH=4;
- (int)match:(NSArray *)otherCards
{
    assert([otherCards count] > 0);
    
    //loop through all attributes, keep track of the number of "matched" attributes
    //a "set match" occurs when an attribute for all cards are identical
    //or none are the same
    int matchCount = 0;
    for (id key in self.attributes)
    {
        BOOL allMatch = [self allAttributesMatch:key otherCards:otherCards];
        BOOL noneMatch = [self noAttributesMatch:key otherCards:otherCards];
        if (allMatch || noneMatch)
            matchCount++;
    }
    
    if (matchCount == [self.attributes count])
        return SET_MATCH;
    else
        return 0;
}

- (BOOL) allAttributesMatch:(id)key otherCards:(NSArray *)otherCards
{
    BOOL match = YES;
    for (SetCard *otherCard in otherCards)
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:self.attributes];
        NSDictionary *dic2 = [[NSDictionary alloc] initWithDictionary:otherCard.attributes];
        id att1 = [dic1 objectForKey:key];
        id att2 = [dic2 objectForKey:key];
        if (![att1 isEqual: att2])
        {
            match = NO;
            break;
        }
    }
    
    return match;
}

- (BOOL) noAttributesMatch:(id)key otherCards:(NSArray *)otherCards
{
    return ![self anyAttributesMatch:key otherCards:otherCards];
}
            
- (BOOL) anyAttributesMatch:(id)key otherCards:(NSArray *)otherCards
{
    //if otherCards contains more than one card, recurse before continuing
    if ([otherCards count] > 1)
    {
        SetCard *otherCard = [otherCards firstObject];
        NSArray *otherArray = [otherCards subarrayWithRange:NSMakeRange(1, [otherCards count]-1)];
        if ([otherCard anyAttributesMatch:key otherCards:otherArray])
            return YES;
    }
    
    //check current card against all other cards
    //if attribute specified by key matches any of the cards
    //return YES
    for (SetCard *otherCard in otherCards)
        if ([[self.attributes objectForKey:key]  isEqual:[otherCard.attributes objectForKey:key]])
            return YES;
    
    //otherwise, no match has been found
    return NO;
}

@end
