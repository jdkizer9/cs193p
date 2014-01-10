//
//  Card.h
//  Matchismo
//
//  Created by James Kizer on 12/31/13.
//  Copyright (c) 2013 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;
@property (nonatomic, getter = isDrawn) BOOL drawn;
@property (nonatomic, getter = isDiscarded) BOOL discarded;

- (int)match:(NSArray *)otherCards;

@end
