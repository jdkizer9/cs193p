//
//  RecentPhotos.m
//  Top Regions
//
//  Created by James Kizer on 1/22/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrFetcher.h"

@interface RecentPhotos()

@property (strong, nonatomic) NSMutableArray *recentPhotosMutableArray; //of dictionary entries

#define RECENT_PHOTOS_NSUSERDEFAULTS_KEY @"Recent Photos Array"

@end

@implementation RecentPhotos


- (NSArray *)recentPhotosArray
{
    return [NSArray arrayWithArray:self.recentPhotosMutableArray];
}

- (NSMutableArray *)recentPhotosMutableArray
{
    //if nil, load from NSUserDefaults
    if (!_recentPhotosMutableArray)
    {
        NSArray *savedRecentPhotosArray = [[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_NSUSERDEFAULTS_KEY];
        
        //if savedRecentPhotosArray is nil, this is the first time running the app
        if (savedRecentPhotosArray)
            _recentPhotosMutableArray = [[NSMutableArray alloc]initWithArray:savedRecentPhotosArray];
        else
            _recentPhotosMutableArray = [[NSMutableArray alloc]init];
    }
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

+ (NSArray *)recentPhotos
{
    return [RecentPhotos sharedRecentPhotos].recentPhotosMutableArray;
}

+ (void)updateRecentPhotosWithImageDictionary:(NSDictionary*)imageDictionary
{
    //use shared instance
    RecentPhotos *recentPhotos = [RecentPhotos sharedRecentPhotos];
    
    //determine if imageDictionary is in the recentPhotosArray
    BOOL foundImageDictionaryInRecentPhotosArray = NO;
    NSDictionary *foundPhoto = nil;
    for (id obj in recentPhotos.recentPhotosArray)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *recentPhoto = (NSDictionary *)obj;
            //compare FLICKR_PHOTO_ID
            if ([recentPhoto objectForKey:FLICKR_PHOTO_ID] &&
                [recentPhoto objectForKey:FLICKR_PHOTO_ID] == [imageDictionary objectForKey:FLICKR_PHOTO_ID])
            {
                foundImageDictionaryInRecentPhotosArray = YES;
                foundPhoto = recentPhoto;
                break;
            }
        }
    }
    
    
    if (foundImageDictionaryInRecentPhotosArray)
    {
        //if imageDictionary is in recentPhotosArray, remove it from the array and
        //add it to the front of the array
        [recentPhotos.recentPhotosMutableArray removeObject:foundPhoto];
        [recentPhotos.recentPhotosMutableArray insertObject:imageDictionary atIndex:0];
    }
    else
    {
        //if imageDictionary is not in recentPhotosArray
        // - add it to the front of the array
        // - if recentPhotosArray is at maximum capacity (NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY)
        //   - remove the last entry so that there are only
        //     NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY dictionaries in the arrray
        [recentPhotos.recentPhotosMutableArray insertObject:imageDictionary atIndex:0];
        if ([recentPhotos.recentPhotosMutableArray count] > NUMBER_OF_RECENT_PHOTOS_TO_DISPLAY)
            [recentPhotos.recentPhotosMutableArray removeLastObject];
    }
    
    //update user defaults
    //[[NSUserDefaults standardUserDefaults] arrayForKey:RECENT_PHOTOS_NSUSERDEFAULTS_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSArray alloc] initWithArray:recentPhotos.recentPhotosMutableArray] forKey:RECENT_PHOTOS_NSUSERDEFAULTS_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}




@end
