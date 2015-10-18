//
//  Piece.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "Piece.h"
#import "Grid.h"
#import "CheckerViewController.h"

@implementation Piece

- (instancetype)initWithLocation:(CGPoint)location teamID:(NSUUID *)teamID legalYDirection:(CGFloat)legalYDirection {
    self = [super init];
    self.pieceID = [NSUUID UUID];
    self.location = location;
    self.teamID = teamID;
    self.legalYDirection = legalYDirection;
    return self;
}

- (LegalMove *)bestLegalMoveForGrid:(Grid *)grid {
    NSArray *legalMoves = [self legalMovesForGrid:grid];
    if (legalMoves.count <= 0) return nil;
    int randomMove = arc4random_uniform((u_int32_t)legalMoves.count);
    // check bounds
    if (randomMove >= legalMoves.count) randomMove = (int)legalMoves.count - 1;
    else if (randomMove < 0) randomMove = 0;
    return legalMoves[randomMove];
}

- (NSArray *)legalMovesForGrid:(Grid *)grid {
    NSMutableArray *legalMoves = [NSMutableArray array];
    
    /// Establish Left move:
    CGPoint legalUpLeft = CGPointMake(self.location.x - 1, self.location.y + self.legalYDirection);
    LegalMove *legalUpLeftMove = [self checkPlaceForLegality:legalUpLeft xDirectionOffset:-1 onGrid:grid];
    if (legalUpLeftMove) [legalMoves addObject:legalUpLeftMove];
    /// Establish Right move:
    CGPoint legalUpRight = CGPointMake(self.location.x + 1, self.location.y + self.legalYDirection);
    LegalMove *legalUpRightMove = [self checkPlaceForLegality:legalUpRight xDirectionOffset:1 onGrid:grid];
    if (legalUpRightMove) [legalMoves addObject:legalUpRightMove];
    
    return legalMoves;
}

- (LegalMove *) checkPlaceForLegality:(CGPoint)location xDirectionOffset:(CGFloat)xDirectionOffset onGrid:(Grid *)grid {
    // TODO: Don't assume that location.y is the legal direction! (even though we are and can)
    if ([grid isLocationOnGridValid:location]) {
        Piece *pieceBlockingLocation = [grid getPieceAtLocation:location];
        
        if (!pieceBlockingLocation) { // location doesn't have a unit
            return [[LegalMove alloc] initWithPieceID:self.pieceID newLocation:location];
        } else if (pieceBlockingLocation && ![[[grid getPieceAtLocation:location] teamID] isEqual:self.teamID]) { // location has a unit and is not on the same team
            // we need to move the location to kill the unit
            location.x += xDirectionOffset;
            location.y += self.legalYDirection;
            LegalMove *move = [self checkPlaceForLegality:location xDirectionOffset:xDirectionOffset onGrid:grid];
            if (move) move.killPieceID = pieceBlockingLocation.pieceID;
            return move;
        }
        // else location does have a unit and it's one of ours, location is not valid
    }
    return nil;
}

@end
