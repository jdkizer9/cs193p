//
//  Place.m
//  Top Places
//
//  Created by James Kizer on 1/23/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "Place.h"
#import "FlickrFetcher.h"

@interface Place()

@property (strong, nonatomic, readwrite) NSString *country;
@property (strong, nonatomic, readwrite) NSString *state;
@property (strong, nonatomic, readwrite) NSString *city;
@property (strong, nonatomic, readwrite) NSDictionary *placeData;


@end

@implementation Place

- (NSDictionary *)placeData
{
    if (!_placeData) _placeData = [[NSDictionary alloc]init];
    return _placeData;
}

- (instancetype) initWithPlaceData:(NSDictionary *)placeData
{
    
    self = [super init];
    
    if (self)
    {
        
        self.placeData = [[NSDictionary alloc]initWithDictionary:placeData];
        
        //extract city, state, country
        //get _content
        NSString *placeContent = [self.placeData objectForKey:FLICKR_PLACE_NAME];
        //NSLog(@"initWithPlaceData _content: %@", placeContent);
        
        //extract city, state (if applicable), country
        NSArray *placeArray = [placeContent componentsSeparatedByString:@", "];
        //NSLog(@"initWithPlaceData placeArray: %@", placeArray);
        
        if ([placeArray count] == 3)
        {
            if ([placeArray[0] isKindOfClass:[NSString class]])
                 self.city = placeArray[0];
            if ([placeArray[1] isKindOfClass:[NSString class]])
                self.state = placeArray[1];
            if ([placeArray[2] isKindOfClass:[NSString class]])
                self.country = placeArray[2];
        } else if ([placeArray count] == 2)
        {
            if ([placeArray[0] isKindOfClass:[NSString class]])
                self.city = placeArray[0];
            if ([placeArray[1] isKindOfClass:[NSString class]])
                self.country = placeArray[1];
        }
        else
        {
            NSLog(@"initWithPlaceData placeArray invalid: %@", placeArray);
        }
        
    }
    return self;
    
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Country: %@\nState: %@\nCity: %@\n%@",
            self.country, self.state, self.city, self.placeData];
}

- (NSComparisonResult)compareCity:(Place *)aPlace
{
    return [self.city compare:aPlace.city];
}




@end
