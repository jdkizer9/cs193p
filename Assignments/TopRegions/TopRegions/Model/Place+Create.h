//
//  Place+Create.h
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Place.h"

@interface Place (Create)
+ (Place *)placeWithPlaceID:(NSString *)placeID
     inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
