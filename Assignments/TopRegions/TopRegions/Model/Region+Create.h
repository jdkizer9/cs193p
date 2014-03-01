//
//  Region+Create.h
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Region.h"

@interface Region (Create)

+ (Region *)regionWithRegionName:(NSString *)regionName
       inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void) synchronizeAllRegionsNumberOfPhotographersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void) synchronizeNumberOfPhotographers;

@end
