//
//  TopRegionsListCDTVC.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopRegionsListCDTVC.h"
#import "Region.h"
#import "RegionsDatabaseAvailabilityNotification.h"
#import "Place.h"
#import "Photo.h"
#import "Region+Create.h"
#import "PhotoListForRegionCDTVC.h"

@interface TopRegionsListCDTVC ()

@end

@implementation TopRegionsListCDTVC

- (void)awakeFromNib
{
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Region"];
    fetchRequest.predicate = nil;
    
    NSSortDescriptor *sortDescriptorNumberOfPhotogs =
    [[NSSortDescriptor alloc]initWithKey:@"numberOfPhotographers" ascending:NO];
    
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    
    fetchRequest.sortDescriptors = @[sortDescriptorNumberOfPhotogs,sortDescriptorName];
    
    fetchRequest.fetchLimit = TOP_REGIONS_FETCH_LIMIT;
    
    //set up fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we must be sure to use the same identifier here as in the storyboard!
    static NSString *CellIdentifier = @"Region Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = region.name;    
    NSNumber *numberOfPhotographers = [region valueForKey:@"numberOfPhotographers"];
    if ([numberOfPhotographers integerValue] == 1)
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ photographer", numberOfPhotographers];
    else
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ photographers", numberOfPhotographers];
        
    
    return cell;
}

#pragma mark - Navigation

- (void)preparePhotoListForRegionCDTVC:(PhotoListForRegionCDTVC *)plCDTVC forRegion:(Region *)region
{
    plCDTVC.region = region;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // find out which row in which section we're seguing from
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            // found it ... are we doing the Photos For Region segue?
            if ([segue.identifier isEqualToString:@"Photos For Region"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[PhotoListForRegionCDTVC class]]) {
                    // yes ... then we know how to prepare for that segue!
                    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    [self preparePhotoListForRegionCDTVC:segue.destinationViewController
                                               forRegion:region];
                }
            }
        }
    }
}



@end
