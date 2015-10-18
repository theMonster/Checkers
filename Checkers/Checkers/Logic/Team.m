//
//  Team.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "Team.h"
#import "CheckerViewController.h"
#import "Grid.h"

@implementation Team

- (instancetype)initWithTeamStartingPosition:(StartingPositions)startPosition {
    self = [super init];
    self.teamId = [NSUUID UUID];
    // create the pieces
    NSMutableArray *pieces = [NSMutableArray array];
    for (int i = 0; i < SIZE_OF_BOARD; ++i) {
        CGPoint location;
        switch (startPosition) {
            case OnTop:
                switch (i) {
                    case 0:
                        location = CGPointMake(0, 0);
                        break;
                    case 1:
                        location = CGPointMake(2, 0);
                        break;
                    case 2:
                        location = CGPointMake(4, 0);
                        break;
                    case 3:
                        location = CGPointMake(6, 0);
                        break;
                        // second row
                    case 4:
                        location = CGPointMake(1, 1);
                        break;
                    case 5:
                        location = CGPointMake(3, 1);
                        break;
                    case 6:
                        location = CGPointMake(5, 1);
                        break;
                    case 7:
                        location = CGPointMake(7, 1);
                        break;
                    default: NSAssert(false, @"This function was made lazily because of time."); break;
                }
                [pieces addObject:[[Piece alloc] initWithLocation:location teamID:self.teamId legalYDirection:1]];
                break;
            case OnBottom:
                switch (i) {
                    case 0:
                        location = CGPointMake(0, 6);
                        break;
                    case 1:
                        location = CGPointMake(2, 6);
                        break;
                    case 2:
                        location = CGPointMake(4, 6);
                        break;
                    case 3:
                        location = CGPointMake(6, 6);
                        break;
                        // second row
                    case 4:
                        location = CGPointMake(1, 7);
                        break;
                    case 5:
                        location = CGPointMake(3, 7);
                        break;
                    case 6:
                        location = CGPointMake(5, 7);
                        break;
                    case 7:
                        location = CGPointMake(7, 7);
                        break;
                    default: NSAssert(false, @"This function was made lazily because of time."); break;
                }
                [pieces addObject:[[Piece alloc] initWithLocation:location teamID:self.teamId legalYDirection:-1]];
                break;
        }
    }
    self.pieces = pieces;
    return self;
}

- (NSArray *)legalMovesForAllPiecesOnTeamForGrid:(Grid *)grid {
    NSArray *tmp = [NSArray array];
    for (Piece *p in self.pieces) {
        tmp = [tmp arrayByAddingObjectsFromArray:[p legalMovesForGrid:grid]];
    }
    return tmp;
}

- (Piece *)bestMoveToMakeForGrid:(Grid *)grid {
    NSArray *legalMoves = [self legalMovesForAllPiecesOnTeamForGrid:grid];
    if (legalMoves.count <= 0) return nil;
    int randomMove = arc4random_uniform((u_int32_t)legalMoves.count);
    // adapt for bounds
    if (randomMove >= legalMoves.count) randomMove = (int)legalMoves.count - 1;
    else if (randomMove < 0) randomMove = 0;
    return legalMoves[randomMove];
}

- (void)pieceWasKilled:(Piece *)piece {
    NSMutableArray *tmp = self.pieces.mutableCopy;
    [tmp removeObjectAtIndex:[tmp indexOfObject:piece]];
    self.pieces = tmp;
}


@end
