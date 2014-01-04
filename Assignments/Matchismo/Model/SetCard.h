//
//  SetCard.h
//  Matchismo
//
//  Created by James Kizer on 1/3/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Card.h"

typedef NS_ENUM(NSInteger, SetCardNumber) {
    SetCardNumberNone = 0,
    SetCardNumberOne,
    SetCardNumberTwo,
    SetCardNumberThree,
    SetCardNumberMax
};

typedef NS_ENUM(NSInteger, SetCardSymbol) {
    SetCardSymbolNone  = 0,
    SetCardSymbolDiamond,
    SetCardSymbolSquiggle,
    SetCardSymbolOval,
    SetCardSymbolMax
};

typedef NS_ENUM(NSInteger, SetCardShading) {
    SetCardShadingNone  = 0,
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen,
    SetCardShadingMax
};

typedef NS_ENUM(NSInteger, SetCardColor) {
    SetCardColorNone  = 0,
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorPurple,
    SetCardColorMax
};

@interface SetCard : Card

@property (nonatomic) SetCardNumber number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;
@property (strong, nonatomic, readonly) NSDictionary *attributes;

- (BOOL) anyAttributesMatch:(id)key otherCards:(NSArray *)otherCards;
- (BOOL) allAttributesMatch:(id)key otherCards:(NSArray *)otherCards;
- (BOOL) noAttributesMatch:(id)key otherCards:(NSArray *)otherCards;

@end
