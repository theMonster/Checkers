//
//  LegalMove.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "LegalMove.h"

@implementation LegalMove

- (instancetype)initWithPieceID:(NSUUID *)pieceID newLocation:(CGPoint)newLocation {
    self = [super init];
    self.pieceID = pieceID;
    self.newLocation = newLocation;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LegalMove<%p>: new location: %@", self, NSStringFromCGPoint(self.newLocation)];
}

@end
