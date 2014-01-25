//
//  PhotoList.h
//  Top Places
//
//  Created by James Kizer on 1/24/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopPlacesTVC.h"

@interface PhotoListTVC : TopPlacesTVC

//defaults to YES, subclass should override if
//the viewed photo should not be added
@property (nonatomic) BOOL shouldAddToRecents;
@property (nonatomic, strong) NSArray *photos; // of Flickr photo NSDictionary
//abstracts
- (void)fetchPhotos;

@end
