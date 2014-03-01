//
//  PhotoListCDTVC.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListCDTVC.h"
#import "Photo.h"
#import "ImageViewController.h"
#import "Photo+Flickr.h"

@interface PhotoListCDTVC ()

@end

@implementation PhotoListCDTVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.rowHeight = 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we must be sure to use the same identifier here as in the storyboard!
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = photo.title;
    //cell.detailTextLabel.text = photo.photoDescription;
    
    //check to see if the thumbnail has been downloaded
    //if the thumbnail has been downloaded, set it
    //otherwise, kick off the download and set the cell image later
    if (photo.thumbnailData)
        cell.imageView.image = [UIImage imageWithData:photo.thumbnailData];
    else
    {
        
        cell.imageView.image = nil;
        [photo downloadThumbnailWithCompletionBlock:^{
            if ([cell.textLabel.text isEqualToString:photo.title])
                cell.imageView.image = [UIImage imageWithData:photo.thumbnailData];
        }];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //this obtains the detail viewController in a splitViewController
    //if the current viewController is not in a splitViewController, detail will be nil
    id detail = self.splitViewController.viewControllers[1];
    //remember, our detail is a UINavigationController
    if ([detail isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)detail;
        //viewController 0 in a UINavicationController is the root
        id ivc = [nav.viewControllers firstObject];
        if ([ivc isKindOfClass:[ImageViewController class]])
        {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self prepareImageViewController:ivc
                              toDisplayPhoto:photo];
        }
    }
}

#pragma mark - Navigation

// prepares the given ImageViewController to show the given photo
// used either when segueing to an ImageViewController
//   or when our UISplitViewController's Detail view controller is an ImageViewController

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(Photo *)photo
{
    ivc.imageURL = [[NSURL alloc]initWithString: photo.imageURL];
    ivc.title = photo.title;
    //add to recents
    if ([self shouldUpdateLastViewedDate])
        [photo.managedObjectContext performBlockAndWait:^{
            photo.lastViewedDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
            [photo.managedObjectContext save:NULL];
        }];
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
            // found it ... are we doing the Display Photo segue?
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    // yes ... then we know how to prepare for that segue!
                    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:photo];
                }
            }
        }
    }
}

@end
