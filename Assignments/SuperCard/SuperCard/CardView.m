//
//  CardView.m
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardView.h"

@interface CardView()

@end

@implementation CardView


#pragma mark - Properties


#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
@synthesize faceCardScaleFactor = _faceCardScaleFactor;
- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Gesture Handlers

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) || gesture.state == UIGestureRecognizerStateEnded)
    {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;}
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0;}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //draw outside of card, draw rounded rect
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    //turn on clipping for this roundedRect
    //only fill inside
    [roundedRect addClip];
    
    //fill inside of roundedRect to white
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    //stroke boundary of roundedRect
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    //give subclass opportunity to
    //draw the card
    [self pushContext];
    [self drawCard];
    [self popContext];
    
}

- (void)pushContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}
- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void) drawCard
{
    
}

- (void) setup
{
    //clears background color
    self.backgroundColor = nil;
    
    //sets turns opaque off
    self.opaque = NO;
    
    //redraw when bounds change
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}


@end
