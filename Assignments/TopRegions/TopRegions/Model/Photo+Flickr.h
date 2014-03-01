//
//  Photo+Flickr.h
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos //of Flickr Dictionaries
         intoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void) downloadThumbnailWithCompletionBlock:(dispatch_block_t)completionBlock;


@end
