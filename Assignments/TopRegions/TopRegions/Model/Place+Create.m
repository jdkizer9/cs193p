//
//  Place+Create.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Place+Create.h"
#import "FlickrFetcher.h"
#import "Region+Create.h"

@implementation Place (Create)

+ (Place *)placeWithPlaceID:(NSString *)placeID
       inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Place *place = nil;
    
    if([placeID length])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        request.predicate = [NSPredicate predicateWithFormat:@"id = %@", placeID];
        
        NSError *error;
        NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
        
        //check for error
        if(!matches || error || ([matches count] > 1))
        {
            //handle error
        } else if ([matches count])
        {
            //found the photographer, return it
            place = [matches firstObject];
        } else
        {
            
            place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:managedObjectContext];
            place.id = placeID;
            
            
            //update to ImageViewController style of downloading
            NSURL *url = [FlickrFetcher URLforInformationAboutPlace:(id)placeID];
            
            
            // create a (non-main) queue to do fetch on
            dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
            
            
            dispatch_async(fetchQ, ^{
                // fetch the JSON data from Flickr
                NSData *jsonResults = [NSData dataWithContentsOfURL:url];
                NSDictionary *placeInfo = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                          options:0
                                                                            error:NULL];
                
                NSString *regionName = [FlickrFetcher extractRegionNameFromPlaceInformation:placeInfo];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Region does not exist
                    //need to go to flickr get place info
                    place.region = [Region regionWithRegionName:regionName inManagedObjectContext:managedObjectContext];
                    
                    [place.region synchronizeNumberOfPhotographers];
                });
            });
            
            
            
            
            
            
            
            
        }
    }
    
    return place;
}

@end
