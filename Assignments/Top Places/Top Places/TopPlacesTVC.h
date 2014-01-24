//
//  TopPlacesTVC.h
//  Top Places
//
//  Created by James Kizer on 1/22/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentPhotos.h"

@interface TopPlacesTVC : UITableViewController

//access recentPhotos
@property (strong, nonatomic) RecentPhotos *recentPhotos;

@end
