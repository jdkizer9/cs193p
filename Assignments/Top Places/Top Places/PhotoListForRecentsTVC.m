//
//  PhotoListForRecentsViewController.m
//  Top Places
//
//  Created by James Kizer on 1/24/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "PhotoListForRecentsTVC.h"
#import "RecentPhotos.h"

@interface PhotoListForRecentsTVC()

@end

@implementation PhotoListForRecentsTVC

- (void)fetchPhotos
{
    self.photos = [RecentPhotos recentPhotos];
    [self.refreshControl endRefreshing]; // stop the spinner
}

- (void)viewDidAppear:(BOOL)animated
{
    self.photos = [RecentPhotos recentPhotos];
    [super viewDidAppear:animated];
}


- (BOOL)shouldAddToRecents
{
    return NO;
}

@end
