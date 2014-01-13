//
//  CardView.m
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "CardView.h"

@interface CardView()

@property (nonatomic, readwrite) NSUInteger displayIndex;

//dynamic animator stuff
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (nonatomic) CGFloat originalAttachmentLength;


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

@synthesize faceUp = _faceUp;
- (BOOL)isFaceUp
{
    return _faceUp;
}

- (void)setFaceUp:(BOOL)faceUp
{
    if (_faceUp != faceUp)
    {
        _faceUp = faceUp;
        self.redraw = YES;
        [self setNeedsDisplay];
    }
}

- (void)setChosen:(BOOL)chosen
{
    if (_chosen != chosen)
    {
        _chosen = chosen;
        self.redraw = YES;
        [self setNeedsDisplay];
    }
}

-(UIColor *)cardBackgroundColor
{
    if (self.hinting)
        return [UIColor redColor];
    return [UIColor whiteColor];
}


- (instancetype)initWithFrame:(CGRect)frame andDisplayIndex:(NSUInteger)displayIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.displayIndex = displayIndex;
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
    
    //fill inside of roundedRect to color specified
    UIColor *backgroundColor = [self cardBackgroundColor];
    [backgroundColor setFill];
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

- (void)attachCardViewToPoint:(CGPoint)anchorPoint withAnimator:(UIDynamicAnimator *)animator
{
    self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:anchorPoint];
    self.originalAttachmentLength = ({CGFloat d1 = self.center.x - anchorPoint.x, d2 = self.center.y - anchorPoint.y; sqrt(d1 * d1 + d2 * d2); });
    [animator addBehavior:self.attachment];
}

- (void)setCardViewAttachmentLengthFactor:(CGFloat)attachmentLengthFactor
{
    CGFloat attachmentLength = self.originalAttachmentLength * attachmentLengthFactor;
    self.attachment.length = attachmentLength;
}

- (void)removeCardViewFromAttachmentWithAnimator:(UIDynamicAnimator *)animator
{
    [animator removeBehavior:self.attachment];
    self.attachment = nil;
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
