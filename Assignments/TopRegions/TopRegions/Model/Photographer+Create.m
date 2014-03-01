//
//  Photographer+Create.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)


+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Photographer *photographer = nil;
    
    if([name length])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
        
        //check for error
        if(!matches || error || ([matches count] > 1))
        {
            //handle error
        } else if ([matches count])
        {
            //found the photographer, return it
            photographer = [matches firstObject];
        } else
        {
            //photographer does not exist
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:managedObjectContext];
            photographer.name = name;
        }
    }
    
    return photographer;
}
@end
