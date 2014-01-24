//
//  RecentPhotos.h
//  Top Places
//
//  Created by James Kizer on 1/22/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

//access to singleton object
+ (instancetype)sharedRecentPhotos;

- (void)updateRecentPhotosWithImageDictionary:(NSDictionary*)imageDictionary;
@property (strong, nonatomic, readonly) NSArray *recentPhotosArray;

#define NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY 20

@end
