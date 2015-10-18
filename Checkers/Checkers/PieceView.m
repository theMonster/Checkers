//
//  PieceView.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/15/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "PieceView.h"

@implementation PieceView

// TODO: We only do this now because I don't want to take the time to allow the user to move the piece around (and snap to positions)
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}

@end