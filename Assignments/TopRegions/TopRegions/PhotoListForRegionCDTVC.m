//
//  PhotoListForRegionCDTVC.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListForRegionCDTVC.h"
#import "Region.h"

@interface PhotoListForRegionCDTVC ()

@end

@implementation PhotoListForRegionCDTVC

- (BOOL) shouldUpdateLastViewedDate
{
    return YES;
}

- (void) setRegion:(Region *)region
{
    _region = region;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Photo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"place.region.name = %@", region.name];
    
    NSSortDescriptor *sortDescriptorUploadDate = [[NSSortDescriptor alloc]initWithKey:@"uploadDate" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptorUploadDate];
    
    //set up fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:region.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
}

@end
