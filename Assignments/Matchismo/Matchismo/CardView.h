//
//  CardView.h
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView


@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic, getter = isChosen) BOOL chosen;


- (void) drawCard;//abstract


- (void)pinch:(UIPinchGestureRecognizer *)gesture;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)pushContext;
- (void)pushContextAndRotateUpsideDown;
- (void)popContext;

-(UIColor *)cardBackgroundColor;


@end
