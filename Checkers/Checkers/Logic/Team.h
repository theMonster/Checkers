//
//  Team.h
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "LegalMove.h"

typedef enum : NSUInteger {
    OnTop,
    OnBottom
} StartingPositions;

@interface Team : NSObject
@property (nonatomic, retain) NSArray *pieces;
@property (nonatomic, retain) NSUUID *teamId;
- (NSArray *)legalMovesForAllPiecesOnTeamForGrid:(id)grid;
- (LegalMove *)bestMoveToMakeForGrid:(id)grid;
- (instancetype)init __unavailable;
- (instancetype)initWithTeamStartingPosition:(StartingPositions)startPosition;
- (void) pieceWasKilled:(Piece *)piece;
@end
