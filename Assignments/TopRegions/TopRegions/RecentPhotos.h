//
//  RecentPhotos.h
//  Top Regions
//
//  Created by James Kizer on 1/22/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+ (NSArray *)recentPhotos;
+ (void)updateRecentPhotosWithImageDictionary:(NSDictionary*)imageDictionary;

#define NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY 20

@end
