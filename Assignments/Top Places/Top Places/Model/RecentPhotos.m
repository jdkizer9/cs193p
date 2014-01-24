//
//  RecentPhotos.m
//  Top Places
//
//  Created by James Kizer on 1/22/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "RecentPhotos.h"

@interface RecentPhotos()

@property (strong, nonatomic) NSMutableArray *recentPhotosMutableArray; //of dictionary entries

@end

@implementation RecentPhotos


- (NSArray *)recentPhotosArray
{
    return [NSArray arrayWithArray:self.recentPhotosMutableArray];
}

- (NSMutableArray *)recentPhotosMutableArray
{
    if (!_recentPhotosMutableArray) _recentPhotosMutableArray = [[NSMutableArray alloc]init];
    return _recentPhotosMutableArray;
}

+ (instancetype)sharedRecentPhotos
{
    static RecentPhotos *sharedRecentPhotos = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRecentPhotos = [[self alloc] init];
    });
    return sharedRecentPhotos;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //load recentPhotosArray with values from NSUserDefaults
        
    }
    return self;
}

- (void)updateRecentPhotosWithImageDictionary:(NSDictionary*)imageDictionary
{
    //if imageDictionary is in recentPhotosArray, remove it from the array and
    //add it to the front of the array
    
    //if imageDictionary is not in recentPhotosArray
    // - add it to the front of the array
    // - if recentPhotosArray is at maximum capacity (NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY)
    //   - remove the last entry so that there are only
    //     NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY dictionaries in the arrray
}


@end
