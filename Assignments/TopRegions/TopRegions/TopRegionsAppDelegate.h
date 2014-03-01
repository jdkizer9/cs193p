//
//  TopRegionsAppDelegate.h
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopRegionsAppDelegate : UIResponder <UIApplicationDelegate>

- (void)loadMoreFlickrData:(UIRefreshControl *)sender;
@property (strong, nonatomic) UIWindow *window;

@end
