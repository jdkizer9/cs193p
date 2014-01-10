//
//  CardKey.m
//  Matchismo
//
//  Created by James Kizer on 1/7/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Key.h"
#import "CardView.h"

@implementation Key

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self)
        self.object = object;
    return self;
}

- (BOOL) isEqual:(id)obj
{
    assert(self.object);
    BOOL returnVal = NO;
    
    
    if ([obj isKindOfClass:[Key class]])
    {
        Key *key = (Key*)obj;
        if ([self.object isKindOfClass:[CardView class]] &&
            [key.object isKindOfClass:[CardView class]])
        {
            CardView *cardView1 = (CardView *)self.object;
            CardView *cardView2 = (CardView *)key.object;
            if (cardView1 == cardView2)
                returnVal = YES;
        }
    }
    
    return returnVal;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithObject:self.object];
}


@end
