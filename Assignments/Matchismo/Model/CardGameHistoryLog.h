//
//  CardGameHistoryLog.h
//  Matchismo
//
//  Created by James Kizer on 1/2/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGameHistoryEntry.h"

@interface CardGameHistoryLog : NSObject

@property (strong, nonatomic, readonly) NSArray *log; //of CardGameHistoryEntries

- (void) addCardGameHistoryEntry:(CardGameHistoryEntry *)entry;
- (void) clearLog;

@end
