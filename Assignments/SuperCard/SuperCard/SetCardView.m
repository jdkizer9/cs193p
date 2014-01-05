//
//  SetCardView.m
//  SuperCard
//
//  Created by James Kizer on 1/4/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView


- (void)setNumber:(SetCardNumber)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(SetCardSymbol)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void) setShading:(SetCardShading)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void) setColor:(SetCardColor)color
{
    _color = color;
    [self setNeedsDisplay];
}

//abstract in super
//need to implement
- (void) drawCard
{
    
    
    if (self.faceUp)
    {
//        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
//        if (faceImage)
//        {
//            CGRect imageRect = CGRectInset(self.bounds,
//                                           self.bounds.size.width * (1.0-self.faceCardScaleFactor),
//                                           self.bounds.size.height * (1.0-self.faceCardScaleFactor) );
//            [faceImage drawInRect:imageRect];
//            
//        } else {
//            [self drawPips];
//        }
//        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
    
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
