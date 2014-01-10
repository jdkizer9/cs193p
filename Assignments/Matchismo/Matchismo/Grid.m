//
//  Grid.m
//
//  CS193p Fall 2013
//  Copyright (c) 2013 Stanford University.
//  All rights reserved.
//

#import "Grid.h"

@interface Grid()
@property (nonatomic) BOOL resolved;
@property (nonatomic) BOOL unresolvable;
@property (nonatomic, readwrite) NSUInteger rowCount;
@property (nonatomic, readwrite) NSUInteger columnCount;
@property (nonatomic, readwrite) CGSize cellSize;

@end

@implementation Grid

- (void)validate
{
    if (self.resolved) return;    // already valid, nothing to do
    if (self.unresolvable) return;  // already tried to validate and couldn't

    double overallWidth = ABS(self.size.width);
    double overallHeight = ABS(self.size.height);
    double aspectRatio = ABS(self.cellAspectRatio);

    if (!self.numberOfCells || !aspectRatio || !overallWidth || !overallHeight) {
        self.unresolvable = YES;
        return; // invalid inputs
    }

    double minCellWidth = self.minCellWidth;
    double minCellHeight = self.minCellHeight;
    double maxCellWidth = self.maxCellWidth;
    double maxCellHeight = self.maxCellHeight;
    
    BOOL flipped = NO;
    if (aspectRatio > 1) {
        flipped = YES;
        overallHeight = ABS(self.size.width);
        overallWidth = ABS(self.size.height);
        aspectRatio = 1.0/aspectRatio;
        minCellWidth = self.minCellHeight;
        minCellHeight = self.minCellWidth;
        maxCellWidth = self.maxCellHeight;
        maxCellHeight = self.maxCellWidth;
    }
    
    if (minCellWidth < 0) minCellWidth = 0;
    if (minCellHeight < 0) minCellHeight = 0;

    int columnCount = 1;
    while (!self.resolved && !self.unresolvable) {
        double cellWidth = overallWidth / (double)columnCount;
        if (cellWidth <= minCellWidth) {
            self.unresolvable = YES;
        } else {
            double cellHeight = cellWidth / aspectRatio;
            if (cellHeight <= minCellHeight) {
                self.unresolvable = YES;
            } else {
                int rowCount = (int)(overallHeight / cellHeight);
                if ((rowCount * columnCount >= self.numberOfCells) &&
                    ((maxCellWidth <= minCellWidth) || (cellWidth <= maxCellWidth)) &&
                    ((maxCellHeight <= minCellHeight) || (cellHeight <= maxCellHeight))) {
                    if (flipped) {
                        self.rowCount = columnCount;
                        self.columnCount = rowCount;
                        self.cellSize = CGSizeMake(cellHeight, cellWidth);
                    } else {
                        self.rowCount = rowCount;
                        self.columnCount = columnCount;
                        self.cellSize = CGSizeMake(cellWidth, cellHeight);
                    }
                    self.resolved = YES;
                }
                columnCount++;
            }
        }
    }
    
    //check to see if we have empty spaces in last row
    //if so, attempt to move cards into last row
    if (self.rowCount*self.columnCount != self.numberOfCells)
    {
        //must be at least one card in last row
        //assert(((self.rowCount*self.columnCount)-self.numberOfCells) < self.columnCount);
        
        
        int emptySpaces = (self.rowCount*self.columnCount) - self.numberOfCells;
        //determine how many columns to remove
        while (emptySpaces >= (self.rowCount-1))
        {
            self.columnCount--;
            emptySpaces = (self.rowCount*self.columnCount) - self.numberOfCells;
        }
    }
    
    if (!self.resolved) {
        self.rowCount = 0;
        self.columnCount = 0;
        self.cellSize = CGSizeZero;
    }
}

- (void)setResolved:(BOOL)resolved
{
    self.unresolvable = NO;
    _resolved = resolved;
}

- (BOOL)inputsAreValid
{
    [self validate];
    return self.resolved;
}


- (CGFloat)emptySpaceInRow:(NSUInteger)row
{
    int numberOfCardsInRow;
    
    if (row == (self.rowCount-1) && ((self.rowCount*self.columnCount) != self.numberOfCells))
        //possible larger gaps in this row
        numberOfCardsInRow = (self.rowCount*self.columnCount)-self.numberOfCells;
    else
        numberOfCardsInRow = self.columnCount;
    
    // (total width - (width of cards)*(numberOfCardsInRow))/(numberOfCardsInRow+1)
    CGFloat gapWidth = (self.size.width - (self.cellSize.width*numberOfCardsInRow))/(numberOfCardsInRow+1);
    
    return gapWidth;
}
- (CGPoint)centerOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    CGPoint center = CGPointMake(self.cellSize.width/2, self.cellSize.height/2);
    center.x += column * self.cellSize.width;
    //account for any spaces
    center.x += [self emptySpaceInRow:row]*(column+1);
    center.y += row * self.cellSize.height;
    return center;
}

- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    CGRect frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
    frame.origin.x += column * self.cellSize.width;
    frame.origin.y += row * self.cellSize.height;
    return frame;
}

- (void)setNumberOfCells:(NSUInteger)numberOfCells
{
    if (numberOfCells != _numberOfCells) self.resolved = NO;
    _numberOfCells = numberOfCells;
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(size, _size)) self.resolved = NO;
    _size = size;
}

- (void)setCellAspectRatio:(CGFloat)cellAspectRatio
{
    if (ABS(cellAspectRatio) != ABS(_cellAspectRatio)) self.resolved = NO;
    _cellAspectRatio = cellAspectRatio;
}

- (void)setMinCellHeight:(CGFloat)minCellHeight
{
    if (minCellHeight != _minCellHeight) self.resolved = NO;
    _minCellHeight = minCellHeight;
}

- (void)setMaxCellHeight:(CGFloat)maxCellHeight
{
    if (maxCellHeight != _maxCellHeight) self.resolved = NO;
    _maxCellHeight = maxCellHeight;
}

- (void)setMinCellWidth:(CGFloat)minCellWidth
{
    if (minCellWidth != _minCellHeight) self.resolved = NO;
    _minCellWidth = minCellWidth;
}

- (void)setMaxCellWidth:(CGFloat)maxCellWidth
{
    if (maxCellWidth != _maxCellWidth) self.resolved = NO;
    _maxCellWidth = maxCellWidth;
}

- (NSUInteger)rowCount
{
    [self validate];
    return _rowCount;
}

- (NSUInteger)columnCount
{
    [self validate];
    return _columnCount;
}

- (CGSize)cellSize
{
    [self validate];
    return _cellSize;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"[%@] fitting %lu cells with aspect ratio %g into %@ -> ", NSStringFromClass([self class]), (unsigned long)self.numberOfCells, self.cellAspectRatio, NSStringFromCGSize(self.size)];
    
    if (!self.rowCount) {
        description = [description stringByAppendingString:@"invalid input: "];
        if (!self.numberOfCells || !self.cellAspectRatio || !self.size.width || !self.size.height) {
            if (!self.numberOfCells) description = [description stringByAppendingString:@"numberOfCells = 0;"];
            if (!self.cellAspectRatio) description = [description stringByAppendingString:@"cellAspectRatio = 0;"];
            if (!self.size.width) description = [description stringByAppendingString:@"size.width = 0;"];
            if (!self.size.height) description = [description stringByAppendingString:@"size.height = 0;"];
        } else {
            
            if (self.minCellWidth || self.minCellHeight) {
                description = [description stringByAppendingString:@"minimum width or height restricts grid to impossibility"];
                if (self.minCellWidth && self.minCellHeight) {
                    description = [description stringByAppendingFormat:@" (minCellWidth = %g, minCellHeight = %g)", self.minCellWidth, self.minCellHeight];
                } else if (self.minCellWidth) {
                    description = [description stringByAppendingFormat:@" (minCellWidth = %g)", self.minCellWidth];
                } else {
                    description = [description stringByAppendingFormat:@" (minCellHeight = %g)", self.minCellHeight];
                }
            } else {
                description = [description stringByAppendingString:@"internal error"];
            }
        }
    } else {
        description = [description stringByAppendingFormat:@"%luc x %lur at %@ each", (unsigned long)self.columnCount, (unsigned long)self.rowCount, NSStringFromCGSize(self.cellSize)];
    }
    
    return description;
}

-(CGRect)frameForCardViewAtIndex:(NSUInteger)index
{
    
    if (self.inputsAreValid)
    {
        //row major order
        //determine row and column
        NSUInteger row = index / self.columnCount;
        NSUInteger column = index % self.columnCount;
        
        return [self frameOfCellAtRow:row inColumn:column];
    }
    else
        return CGRectMake(0, 0, 0, 0);
}

-(CGPoint)centerForCardViewAtIndex:(NSUInteger)index
{
    
    if (self.inputsAreValid)
    {
        //row major order
        //determine row and column
        NSUInteger row = index / self.columnCount;
        NSUInteger column = index % self.columnCount;
        
        return [self centerOfCellAtRow:row inColumn:column];
    }
    else
        return CGPointMake(0, 0);
}

@end
