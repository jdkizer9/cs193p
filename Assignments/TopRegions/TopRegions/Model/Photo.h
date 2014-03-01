//
//  Photo.h
//  TopRegions
//
//  Created by James Kizer on 2/28/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer, Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSDate * lastViewedDate;
@property (nonatomic, retain) NSDate * uploadDate;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * place_id;
@property (nonatomic, retain) Photographer *whoTook;
@property (nonatomic, retain) Place *place;

@end
