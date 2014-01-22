//
//  CardView.h
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CardGameAnimationLog.h"

@interface CardView : UIView

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic, getter = isChosen) BOOL chosen;

@property (nonatomic, getter = shouldRedraw) BOOL redraw;
@property (nonatomic, readonly) NSUInteger displayIndex;
@property (nonatomic) BOOL hinting;

//@property (nonatomic) CGPoint realCenter;
@property (nonatomic) CGPoint removeCenter;
//@property (nonatomic) CGPoint moveToPoint;

@property (nonatomic) UIColor *cardBackgroundColor;

- (instancetype)initWithFrame:(CGRect)frame andDisplayIndex:(NSUInteger)displayIndex;

- (void) drawCard;//abstract


- (void)pinch:(UIPinchGestureRecognizer *)gesture;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)pushContext;
- (void)pushContextAndRotateUpsideDown;
- (void)popContext;

//-(UIColor *)cardBackgroundColor;

@property (strong, nonatomic) UITapGestureRecognizer *tapCardGesture;

//dynamic animator stuff
- (void)attachCardViewToPoint:(CGPoint)anchorPoint withAnimator:(UIDynamicAnimator *)animator;
- (void)setCardViewAttachmentLengthFactor:(CGFloat)attachmentLengthFactor;
- (void)removeCardViewFromAttachmentWithAnimator:(UIDynamicAnimator *)animator;


@end
