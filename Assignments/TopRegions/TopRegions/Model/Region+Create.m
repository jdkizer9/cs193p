//
//  Region+Create.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Region+Create.h"

@implementation Region (Create)


+ (Region *)regionWithRegionName:(NSString *)regionName
          inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Region *region = nil;
    
    if([regionName length])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", regionName];
        
        NSError *error;
        NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
        
        //check for error
        if(!matches || error || ([matches count] > 1))
        {
            //handle error
        } else if ([matches count])
        {
            //found the photographer, return it
            region = [matches firstObject];
        } else
        {
            //Region does not exist
            //need to go to flickr get place info
            region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:managedObjectContext];
            
            region.name = regionName;
            //region.region = region;
        }
    }
    
    return region;
}

- (NSComparisonResult)regionCompare:(Region *)aRegion
{
    if (self.numberOfPhotographers == aRegion.numberOfPhotographers)
        return NSOrderedSame;
    else if (self.numberOfPhotographers < aRegion.numberOfPhotographers)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
}

- (void) synchronizeNumberOfPhotographers
{
    NSInteger computedNumberOfPhotographers = [[self valueForKeyPath:@"places.@distinctUnionOfSets.photos.whoTook"]count];
    if (computedNumberOfPhotographers != [self.numberOfPhotographers integerValue])
        self.numberOfPhotographers = @(computedNumberOfPhotographers);
}

+ (void) synchronizeAllRegionsNumberOfPhotographersInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = nil;
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    
    //check for error
    if(!matches || error || ([matches count] > 1))
    {
        //handle error
    }
    else
    {
        for (Region *region in matches)
        {
            [region synchronizeNumberOfPhotographers];
        }
    }
    
}

@end
