//
//  Photo+Flickr.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"
#import "Place+Create.h"
#import "Region+Create.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Photo *photo = nil;
    
    //determine if the photo exists in the db
    NSString *unique = [photoDictionary valueForKeyPath:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    
    //check for error
    if(!matches || error || ([matches count] > 1))
    {
        //handle error
    } else if ([matches count])
    {
        //found the photo, return it
        photo = [matches firstObject];
    } else
    {
        //photo does not exist
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:managedObjectContext];
        
        //initialize the photo
        photo.unique = unique;
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.photoDescription = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.thumbnailURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        photo.thumbnailData = nil;
        
        //initilize last viewed date to 0
        //RecentPhotos will query to return all images
        //whose lastViewedDate does not match this
        photo.lastViewedDate = [NSDate dateWithTimeIntervalSince1970:0];
        
        //upload date in seconds since since 1970
        NSString *uploadDate = [photoDictionary valueForKeyPath:FLICKR_PHOTO_UPLOAD_DATE];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *timeInterval = [formatter numberFromString:uploadDate];
        photo.uploadDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]];
        
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        photo.whoTook = [Photographer photographerWithName:photographerName inManagedObjectContext:managedObjectContext];
        
        //get the region name
        photo.place = [Place placeWithPlaceID:[photoDictionary valueForKeyPath:FLICKR_PHOTO_PLACE_ID]
                          inManagedObjectContext:managedObjectContext];
        
        [photo.place.region synchronizeNumberOfPhotographers];
    }
    
    return photo;
    
}


+ (void)loadPhotosFromFlickrArray:(NSArray *)photos //of Flickr Dictionaries
         intoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    for (id photo in photos)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self photoWithFlickrInfo:photo inManagedObjectContext:managedObjectContext];
        });
        
    }
}

- (void) downloadThumbnailWithCompletionBlock:(dispatch_block_t)completionBlock
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc]initWithString: self.thumbnailURL]];
    
    // another configuration option is backgroundSessionConfiguration (multitasking API required though)
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    // create the session without specifying a queue to run completion handler on (thus, not main queue)
    // we also don't specify a delegate (since completion handler is all we need)
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSString *thumbnailURLString = [NSString stringWithString:self.thumbnailURL];    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                        // this handler is not executing on the main queue, so we can't do UI directly here
                                                        if (!error) {
                                                            if ([request.URL.absoluteString isEqual:thumbnailURLString]) {
                                                                
                                                                [self.managedObjectContext performBlockAndWait:^{
                                                                    self.thumbnailData = [NSData dataWithContentsOfURL:localfile];
                                                                    [self.managedObjectContext save:NULL];
                                                                }];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), completionBlock);
                                                            }
                                                        }
                                                    }];
    [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    
}



@end
