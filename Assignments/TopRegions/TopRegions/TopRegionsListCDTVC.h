//
//  TopRegionsListCDTVC.h
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopRegionsCDTVC.h"

@interface TopRegionsListCDTVC : TopRegionsCDTVC

//This view controller shows the 50 most popular regions in Flickr
//Regions are ranked by the number of distinct photographers
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

#define TOP_REGIONS_FETCH_LIMIT 50

@end
