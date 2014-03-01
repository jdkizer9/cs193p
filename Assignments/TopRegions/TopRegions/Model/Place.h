//
//  Place.h
//  TopRegions
//
//  Created by James Kizer on 2/28/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Region;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Region *region;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
