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

#define SET_CHARACTER_X_OFFSET_FACTOR .2
#define SET_CHARACTER_Y_OFFSET_FACTOR .4
#define SET_CHARACTER_X_SIZE_FACTOR .6
#define SET_CHARACTER_Y_SIZE_FACTOR .2
#define SET_CHARACTER_VERITCAL_GAP_FACTOR .1

#define STRIPE_GAP 2.0

- (void) drawCard
{
    
    if (self.faceUp)
    {
        //draw image(s), return path
        //determine initial rect
        CGRect setImageRect;
        setImageRect.origin.x = self.bounds.origin.x+(SET_CHARACTER_X_OFFSET_FACTOR*self.bounds.size.width);
        CGFloat numberOfChacters = self.number;
        CGFloat yOffsetFactor = (1.0-(SET_CHARACTER_Y_SIZE_FACTOR*numberOfChacters + SET_CHARACTER_VERITCAL_GAP_FACTOR*(numberOfChacters-1.0)))/2.0;
        
        
        
        setImageRect.origin.y = self.bounds.origin.y+(yOffsetFactor*self.bounds.size.height);
        setImageRect.size.width = (SET_CHARACTER_X_SIZE_FACTOR*self.bounds.size.width);
        setImageRect.size.height = (SET_CHARACTER_Y_SIZE_FACTOR*self.bounds.size.height);
        
        for (SetCardNumber i = SetCardNumberOne; i<=self.number; i++)
        {
            UIBezierPath *path = [self drawSetCardImageInRect:setImageRect];
            //[path addClip];
            
            //color
            UIColor *color;
            if (self.color == SetCardColorRed)
                color = [UIColor redColor];
            else if (self.color == SetCardColorGreen)
                color = [UIColor greenColor];
            else if (self.color == SetCardColorPurple)
                color = [UIColor purpleColor];
            else
                color = [UIColor whiteColor];
            
            [color setStroke];
            [color setFill];
            
            //in order to clip for shading, need to save context
            [self pushContext];
            
            //shading
            if (self.shading == SetCardShadingSolid)
            {
                [path fill];
            } else if (self.shading == SetCardShadingStriped)
            {
                
                [path addClip];
                for (CGFloat x=setImageRect.origin.x; x<setImageRect.origin.x+setImageRect.size.width;x+=STRIPE_GAP)
                {
                    [path moveToPoint:CGPointMake(x, setImageRect.origin.y)];
                    [path addLineToPoint:CGPointMake(x, setImageRect.origin.y+setImageRect.size.height)];
                }
            } else if (self.shading == SetCardShadingOpen)
            {
                path.lineWidth = 2.0;
            }
            [path stroke];
            
            //restore context
            [self popContext];
            
            //set new image location for next iteration
            setImageRect.origin.y += (SET_CHARACTER_Y_SIZE_FACTOR + SET_CHARACTER_VERITCAL_GAP_FACTOR) * self.bounds.size.height;
        }
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
    
}

#define CURVE_1_X_OP_SCALE .2
#define CURVE_1_Y_OP_SCALE .2

#define CURVE_1_DP_X_SCALE .8
#define CURVE_1_DP_Y_SCALE .085
#define CURVE_1_CP1_X_SCALE .4
#define CURVE_1_CP1_Y_SCALE -.275
#define CURVE_1_CP2_X_SCALE .525
#define CURVE_1_CP2_Y_SCALE .35

#define CURVE_2_DP_X_SCALE 1.0
#define CURVE_2_DP_Y_SCALE .33
#define CURVE_2_CP1_X_SCALE 1.03
#define CURVE_2_CP1_Y_SCALE -.2
#define CURVE_2_CP2_X_SCALE .925
#define CURVE_2_CP2_Y_SCALE .525

- (UIBezierPath *) drawSetCardImageInRect:(CGRect)rect
{

    if (self.symbol == SetCardSymbolDiamond)
    {
        UIBezierPath *diamond = [[UIBezierPath alloc]init];
        //top point
        [diamond moveToPoint:CGPointMake(rect.size.width/2+rect.origin.x, rect.origin.y)];
        //draw line clockwise
        [diamond addLineToPoint:CGPointMake(rect.size.width+rect.origin.x, rect.size.height/2+rect.origin.y)];
        //draw line clockwise
        [diamond addLineToPoint:CGPointMake(rect.size.width/2+rect.origin.x, rect.size.height+rect.origin.y)];
        //draw line clockwise
        [diamond addLineToPoint:CGPointMake(rect.origin.x, rect.size.height/2+rect.origin.y)];
        [diamond closePath];
        return diamond;
        
    } else if (self.symbol == SetCardSymbolSquiggle)
    {
        UIBezierPath *squiggle = [[UIBezierPath alloc]init];
        CGRect flippedRect = CGRectMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height, -rect.size.width, -rect.size.height);
        
        [squiggle moveToPoint:CGPointMake(rect.origin.x+(CURVE_1_X_OP_SCALE*rect.size.width), rect.origin.y+(CURVE_1_X_OP_SCALE*rect.size.height))];
        [self drawPartialSquiggleWithPath:squiggle InRect:rect];
        [self drawPartialSquiggleWithPath:squiggle InRect:flippedRect];
        [squiggle closePath];
        
        return squiggle;
    } else if (self.symbol == SetCardSymbolOval)
    {
        return [UIBezierPath bezierPathWithOvalInRect:rect];
    }else
        return nil;
    
}

- (void) drawPartialSquiggleWithPath:(UIBezierPath *)path InRect:(CGRect)rect
{
    
    [path addCurveToPoint:CGPointMake(rect.origin.x+(CURVE_1_DP_X_SCALE*rect.size.width), rect.origin.y+(CURVE_1_DP_Y_SCALE*rect.size.height))
            controlPoint1:CGPointMake(rect.origin.x+(CURVE_1_CP1_X_SCALE*rect.size.width), rect.origin.y+(CURVE_1_CP1_Y_SCALE*rect.size.height))
            controlPoint2:CGPointMake(rect.origin.x+(CURVE_1_CP2_X_SCALE*rect.size.width), rect.origin.y+(CURVE_1_CP2_Y_SCALE*rect.size.height))];
    
    [path addCurveToPoint:CGPointMake(rect.origin.x+((1-CURVE_1_X_OP_SCALE)*rect.size.width), rect.origin.y+((1-CURVE_1_Y_OP_SCALE)*rect.size.height))
            controlPoint1:CGPointMake(rect.origin.x+(CURVE_2_CP1_X_SCALE*rect.size.width), rect.origin.y+(CURVE_2_CP1_Y_SCALE*rect.size.height))
            controlPoint2:CGPointMake(rect.origin.x+(CURVE_2_CP2_X_SCALE*rect.size.width), rect.origin.y+(CURVE_2_CP2_Y_SCALE*rect.size.height))];
    
}

@end
