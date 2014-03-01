//
//  PhotoListForRecentsCDTVC.h
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListCDTVC.h"

@interface PhotoListForRecentsCDTVC : PhotoListCDTVC

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
#define RECENT_PHOTOS_FETCH_LIMIT 20

@end
