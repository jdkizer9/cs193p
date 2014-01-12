//
//  CardGameAnimationLog.h
//  Matchismo
//
//  Created by James Kizer on 1/10/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGameAnimationLogEntry.h"

@interface CardGameAnimationLog : NSObject

-(void)addAnimationEntry:(CardGameAnimationLogEntry *)logEntry;
-(void)performAnimations;

@property (atomic, readonly, getter = isAnimating) BOOL animating;

#define ADD_REMOVE_POINT CGPointMake(-1.0, -1.0)

@end
