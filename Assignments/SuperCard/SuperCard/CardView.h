//
//  CardView.h
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView


@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;


- (void) drawCard;//abstract


- (void)pinch:(UIPinchGestureRecognizer *)gesture;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)pushContextAndRotateUpsideDown;
- (void)popContext;


@end
