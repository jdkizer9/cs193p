//
//  PhotoListForPlaceTVC.h
//  Top Places
//
//  Created by James Kizer on 1/23/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "Place.h"
#import "PhotoListTVC.h"

@interface PhotoListForPlaceTVC : PhotoListTVC

@property (strong, nonatomic) Place *place;
#define MAXIMUM_NUMBER_OF_PHOTOS 50

@end
