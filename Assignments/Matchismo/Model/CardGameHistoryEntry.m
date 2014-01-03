//
//  CardGameHistoryEntry.m
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameHistoryEntry.h"

@implementation CardGameHistoryEntry

- (instancetype) initEntryWithCards:(NSArray *)cards
                              score:(NSInteger) score
{
    if (!cards)
        return nil;
    
    self = [super init];
    
    if (self)
    {
        self.cards = [NSArray arrayWithArray:cards];
        self.score = score;
    }
    
    return self;
}

//- (instancetype) initEntryWithEntry:(CardGameHistoryEntry *) entry
//{
//    if (!entry)
//        return nil;
//    
//    self = [super init];
//    
//    if (self)
//    {
//        self.cards = [NSArray arrayWithArray:entry.cards];
//        self.score = entry.score;
//    }
//    
//    return self;
//}

+ (instancetype) cardGameHistoryEntryWithCards: (NSArray *)cards
                                         score:(NSInteger) score
{
    if (!cards)
        return nil;
    
    CardGameHistoryEntry *entry = [[CardGameHistoryEntry alloc] init];
    
    entry.cards = [NSArray arrayWithArray:cards];
    entry.score = score;
    
    return entry;
}

@end
