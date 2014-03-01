//
//  PhotoListForRecentsCDTVC.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListForRecentsCDTVC.h"
#import "RegionsDatabaseAvailabilityNotification.h"

@interface PhotoListForRecentsCDTVC ()

@end

@implementation PhotoListForRecentsCDTVC

- (BOOL) shouldUpdateLastViewedDate
{
    return NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RegionsDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[RegionsDatabaseAvailabilityContext];
                                                  }];
}

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Photo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"lastViewedDate != %@", [NSDate dateWithTimeIntervalSince1970:0]];
    
    NSSortDescriptor *sortDescriptorUploadDate = [[NSSortDescriptor alloc]initWithKey:@"lastViewedDate" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptorUploadDate];
    
    fetchRequest.fetchLimit = RECENT_PHOTOS_FETCH_LIMIT;
    
    //set up fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
}

@end
