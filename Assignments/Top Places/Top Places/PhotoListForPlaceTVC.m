//
//  PhotoListForPlaceTVC.m
//  Top Places
//
//  Created by James Kizer on 1/23/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListForPlaceTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "RecentPhotos.h"

@interface PhotoListForPlaceTVC ()

@end

@implementation PhotoListForPlaceTVC



#pragma mark - UITableViewDataSource
// this method is called in viewDidLoad,
//   but also when the user "pulls down" on the table view
//   (because this is the action of self.tableView.refreshControl)



- (void)fetchPhotos
{
    [self.refreshControl beginRefreshing]; // start the spinner
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:[self flickrPlaceIdForPlace:self.place] maxResults:MAXIMUM_NUMBER_OF_PHOTOS];
    // create a (non-main) queue to do fetch on
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    // put a block to do the fetch onto that queue
    dispatch_async(fetchQ, ^{
        // fetch the JSON data from Flickr
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        // convert it to a Property List (NSArray and NSDictionary)
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        
        //NSLog(@"fetchPhotos propertyListResults: %@", propertyListResults);
        // get the NSArray of photo NSDictionarys out of the results
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        // update the Model (and thus our UI), but do so back on the main queue
        NSLog(@"fetchPhotos photos: %@", photos);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing]; // stop the spinner
            self.photos = photos;
        });
    });
}

- (id)flickrPlaceIdForPlace:(Place *)place
{
    return [place.placeData valueForKeyPath:FLICKR_PLACE_ID];
}
@end
