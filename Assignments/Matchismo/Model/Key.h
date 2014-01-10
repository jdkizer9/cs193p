//
//  CardKey.h
//  Matchismo
//
//  Created by James Kizer on 1/7/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Key : NSObject <NSCopying>

//this class is used to create a key
//for dictionaries using CardView objects
//intent is to map Cards to CardViews

//designated initializer
- (instancetype)initWithObject:(id)object;
@property (strong, nonatomic) id object;

@end
