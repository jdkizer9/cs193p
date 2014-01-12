//
//  CardGameAnimationLogEntry.m
//  Matchismo
//
//  Created by James Kizer on 1/10/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameAnimationLogEntry.h"

@implementation CardGameAnimationLogEntry

-(instancetype) initWithAnimationType:(CardGameAnimationType)animationType
                         withCardView:(CardView *)cardView
                            withPoint:(CGPoint)moveToPoint;
{
    self = [super init];
    if (self)
    {
        self.animationType = animationType;
        self.cardView = cardView;
        self.moveToPoint = moveToPoint;
    }
    return self;
}

@end
