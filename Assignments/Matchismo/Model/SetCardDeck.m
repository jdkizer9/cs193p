//
//  SetCardDeck.m
//  Matchismo
//
//  Created by James Kizer on 1/3/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        for (SetCardNumber num = SetCardNumberOne; num < SetCardNumberMax; num++)
            for (SetCardSymbol sym = SetCardSymbolDiamond; sym < SetCardSymbolMax; sym++)
                for (SetCardShading shad = SetCardShadingSolid; shad < SetCardShadingMax; shad++)
                    for (SetCardColor col = SetCardColorRed; col < SetCardColorMax; col++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = num;
                        card.symbol = sym;
                        card.shading = shad;
                        card.color = col;
                        [self addCard:card];
                    }
            
    }
    return self;
}

@end
