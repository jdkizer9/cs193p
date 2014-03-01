//
//  TopRegionsCDTVC.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopRegionsCDTVC.h"
#import "TopRegionsAppDelegate.h"

@interface TopRegionsCDTVC ()

@end

@implementation TopRegionsCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    [refreshControl addTarget:[[UIApplication sharedApplication] delegate]
                       action:@selector(loadMoreFlickrData:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}



@end
