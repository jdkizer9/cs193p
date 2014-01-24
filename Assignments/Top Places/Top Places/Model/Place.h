//
//  Place.h
//  Top Places
//
//  Created by James Kizer on 1/23/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

- (instancetype) initWithPlaceData:(NSDictionary *)placeData;

@property (strong, nonatomic, readonly) NSString *country;
//note that state may be nil, meaning that no state provided
@property (strong, nonatomic, readonly) NSString *state;
@property (strong, nonatomic, readonly) NSString *city;
@property (strong, nonatomic, readonly) NSDictionary *placeData;

- (NSComparisonResult)compareCity:(Place *)aPlace;

@end
