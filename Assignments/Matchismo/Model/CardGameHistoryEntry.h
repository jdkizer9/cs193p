//
//  CardGameHistoryEntry.h
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "card.h"
@interface CardGameHistoryEntry : NSObject

@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSArray *cards;

//designated initializer
- (instancetype) initEntryWithCards:(NSArray *)cards
                              score:(NSInteger) score;

//- (instancetype) initEntryWithEntry:(CardGameHistoryEntry *) entry;

+ (instancetype) cardGameHistoryEntryWithCards: (NSArray *)cards
                                         score:(NSInteger) score;
           
           
@end
