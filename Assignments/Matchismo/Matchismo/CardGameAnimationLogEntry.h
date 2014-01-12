//
//  CardGameAnimationLogEntry.h
//  Matchismo
//
//  Created by James Kizer on 1/10/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardView.h"
#import "Card.h"

@interface CardGameAnimationLogEntry : NSObject

typedef NS_ENUM(NSInteger, CardGameAnimationType) {
    CardGameAnimationNone = 0,
    CardGameAnimationFlipCard,
    CardGameAnimationRemoveCard,
    CardGameAnimationMoveCard,
    CardGameAnimationHintCard,
    CardGameAnimationMax
};

-(instancetype) initWithAnimationType:(CardGameAnimationType)animationType
                         withCardView:(CardView *)cardView
                            withPoint:(CGPoint)moveToPoint;

@property (nonatomic) CardGameAnimationType animationType;
@property (weak, nonatomic) CardView *cardView;
@property (nonatomic) CGPoint moveToPoint;

@end
