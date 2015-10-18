//
//  Grid.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "Grid.h"

@interface Grid ()
@property (nonatomic, retain) NSArray *teams;
@end

@implementation Grid

- (instancetype)initWithSizeOfBoard:(uint)sizeOfBoard teams:(NSArray *)teams delegate:(id<GridDelegate>)delegate {
    self = [super init];
    self.teams = teams;
    self.delegate = delegate;
    self.sizeOfBoard = CGSizeMake(sizeOfBoard ,sizeOfBoard);
    // loop through pieces
    for (Piece *piece in self.pieces) {
        [self.delegate shouldInstantiatePiece:piece];
    }
    return self;
}

- (NSArray *)pieces {
    NSArray *arr = [NSArray array];
    for (Team *t in self.teams) {
        arr = [arr arrayByAddingObjectsFromArray:t.pieces];
    }
    return arr;
}

- (Piece *)getPieceAtLocation:(CGPoint)location {
    for (Piece *piece in self.pieces) {
        if (CGPointEqualToPoint(piece.location, location)) {
            return piece;
        }
    }
    return nil;
}

- (Piece *)getPieceWithPieceID:(NSUUID *)pieceID {
    for (Piece *piece in self.pieces) {
        if ([piece.pieceID isEqual:pieceID]) {
            return piece;
        }
    }
    return nil;
}

- (Team *)getTeamForTeamID:(NSUUID *)teamID {
    for (Team *t in self.teams) {
        if ([t.teamId isEqual:teamID]) {
            return t;
        }
    }
    return nil;
}

- (void)makeMove:(LegalMove *)legalMove {
    Piece *piece = [self getPieceWithPieceID:legalMove.pieceID];
    NSLog(@"moved piece at location: %@ to location: %@", NSStringFromCGPoint(piece.location), NSStringFromCGPoint(legalMove.newLocation));
    [piece setLocation:legalMove.newLocation];
    [self.delegate didMovePiece:[self getPieceWithPieceID:legalMove.pieceID]];
    // destory any pieces that were killed
    if (legalMove.killPieceID) {
        Piece *killPiece = [self getPieceWithPieceID:legalMove.killPieceID];
        Team *teamOfKillPiece = [self getTeamForTeamID:killPiece.teamID];
        [teamOfKillPiece pieceWasKilled:killPiece];
        [self.delegate pieceDidGetKilled:killPiece];
    }
    // check for win
    NSMutableArray *teamsStillStanding = [NSMutableArray array];
    for (Team *t in self.teams) {
        if ([t legalMovesForAllPiecesOnTeamForGrid:self].count > 0) {
            [teamsStillStanding addObject:t];
        }
    }
    // if there's only one team standing, that team is the winner
    if (teamsStillStanding.count == 1) {
        [self.delegate teamDidWinGame:teamsStillStanding.firstObject];
    } else if (teamsStillStanding.count <= 0) { // stale mate
        [self.delegate teamDidWinGame:nil];
    }
}

- (BOOL)isLocationOnGridValid:(CGPoint)location {
    return CGRectContainsPoint(CGRectMake(0, 0, self.sizeOfBoard.width, self.sizeOfBoard.height), location);
}

@end
