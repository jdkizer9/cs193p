//
//  CardGameHistoryLog.m
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardGameHistoryLog.h"

@interface CardGameHistoryLog()

@property (strong, nonatomic) NSMutableArray *updateableLog; //of CardGameHistoryEntries

@end

@implementation CardGameHistoryLog

- (NSMutableArray *)updateableLog
{
    if (!_updateableLog) _updateableLog = [[NSMutableArray alloc] init];
    return _updateableLog;
}

- (NSArray *)log
{
    return [NSArray arrayWithArray:self.updateableLog];
}

- (void) addCardGameHistoryEntry:(CardGameHistoryEntry *)entry
{
    //[self.updateableLog addObject:[[CardGameHistoryEntry alloc]initEntryWithEntry:entry]];
    [self.updateableLog addObject:entry];
}

- (void)clearLog
{
    self.updateableLog = nil;
}

@end
