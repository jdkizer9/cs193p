//
//  PhotoList.m
//  Top Places
//
//  Created by James Kizer on 1/24/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface PhotoListTVC ()

@end

@implementation PhotoListTVC


// whenever our Model is set, must update our View
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void) clearModel
{
    self.photos = nil;
}

#pragma mark - UITableViewDataSource

// the methods in this protocol are what provides the View its data
// (remember that Views are not allowed to own their data)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section (we only have one)
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we must be sure to use the same identifier here as in the storyboard!
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // get the photo out of our Model
    NSDictionary *photo = self.photos[indexPath.row];
    
    // update UILabels in the UITableViewCell
    // valueForKeyPath: supports "dot notation" to look inside dictionaries at other dictionaries
    NSString *title = [[NSString alloc]initWithString:[photo valueForKeyPath:FLICKR_PHOTO_TITLE]];
    
    //if title is empty, populate with description
    if ([title length] == 0)
    {
        title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        //if no description either, populate with unknown
        if ([title length] == 0)
            title = @"Unknown";
        
        //clear subtitle
        cell.detailTextLabel.text = @"";
    }
    else
    {
        cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    cell.textLabel.text = title;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchPhotos];
}

#pragma mark - Navigation

// prepares the given ImageViewController to show the given photo
// used either when segueing to an ImageViewController
//   or when our UISplitViewController's Detail view controller is an ImageViewController

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    //add to recents
    if ([self shouldAddToRecents])
        [RecentPhotos updateRecentPhotosWithImageDictionary:photo];
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
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}

- (IBAction)fetchPhotoAction
{
    [self clearModel];
    [self fetchPhotos];
}

- (BOOL)shouldAddToRecents
{
    return YES;
}

#pragma mark - Abstract
//this must be defined by the subclass
//this method must populate the photos array
- (void)fetchPhotos
{
}


@end
