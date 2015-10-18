//
//  GridView.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "GridView.h"
#import "CheckerViewController.h"

@implementation GridView

- (void)awakeFromNib {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recievedTap:)];
    [self addGestureRecognizer:recognizer];
}

- (void) recievedTap:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self];
    BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    // since our imageview is using aspect fit, we know the smallest side will be the size of the grid view
    const CGFloat actualGridSize = isLandscape ? self.frame.size.height : self.frame.size.width;
    // adjust the tap for center-ing / aspect fit of grid
    const CGFloat largerSideOfDeviceSize = isLandscape ? self.frame.size.width : self.frame.size.height;
    const CGFloat whiteSpace = (largerSideOfDeviceSize - actualGridSize) / 2;
    if (isLandscape) {
        location.x -= whiteSpace;
    } else {
        location.y -= whiteSpace;
    }
    // check if location is out of bounds
    if (CGRectContainsPoint(CGRectMake(0, 0, actualGridSize, actualGridSize), location)) {
        // call did recieve tap in grid
        const CGFloat cellSize = actualGridSize / SIZE_OF_BOARD;
        location.x = floorf(location.x / cellSize);
        location.y = floorf(location.y / cellSize);
        [self.delegate userDidTapAtGridLocation:location];
    }
}

- (CGRect) getRectForGridPosition:(CGPoint)gridPosition {
    CGPoint location;
    BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    // since our imageview is using aspect fit, we know the smallest side will be the size of the grid view
    const CGFloat actualGridSize = isLandscape ? self.frame.size.height : self.frame.size.width;
    // caluclate location on grid (w/o whitespace)
    const CGFloat cellSize = actualGridSize / SIZE_OF_BOARD;
    location.x = cellSize * gridPosition.x;
    location.y = cellSize * gridPosition.y;
    
    /// Adjust for whitespace:
    // adjust the tap for center-ing / aspect fit of grid
    const CGFloat largerSideOfDeviceSize = isLandscape ? self.frame.size.width : self.frame.size.height;
    const CGFloat whiteSpace = (largerSideOfDeviceSize - actualGridSize) / 2;
    // do actual adjustment
    if (isLandscape) {
        location.x += whiteSpace;
    } else {
        location.y += whiteSpace;
    }
    
    return CGRectMake(location.x, location.y, cellSize, cellSize);
}

@end
