//
//  SetCardView.h
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardView.h"
#import "SetCard.h"

@interface SetCardView : CardView


//typedef NS_ENUM(NSInteger, SetCardNumber) {
//    SetCardNumberNone = 0,
//    SetCardNumberOne,
//    SetCardNumberTwo,
//    SetCardNumberThree,
//    SetCardNumberMax
//};
//
//typedef NS_ENUM(NSInteger, SetCardSymbol) {
//    SetCardSymbolNone  = 0,
//    SetCardSymbolDiamond,
//    SetCardSymbolSquiggle,
//    SetCardSymbolOval,
//    SetCardSymbolMax
//};
//
//typedef NS_ENUM(NSInteger, SetCardShading) {
//    SetCardShadingNone  = 0,
//    SetCardShadingSolid,
//    SetCardShadingStriped,
//    SetCardShadingOpen,
//    SetCardShadingMax
//};
//
//typedef NS_ENUM(NSInteger, SetCardColor) {
//    SetCardColorNone  = 0,
//    SetCardColorRed,
//    SetCardColorGreen,
//    SetCardColorPurple,
//    SetCardColorMax
//};

@property (nonatomic) SetCardNumber number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;

@end
