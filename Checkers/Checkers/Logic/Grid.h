//
//  Grid.h
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
@protocol GridDelegate <NSObject>
- (void) didMovePiece:(Piece *)piece;
- (void) shouldInstantiatePiece:(Piece *)piece;
- (void)pieceDidGetKilled:(Piece *)piece;
- (void) teamDidWinGame:(Team *)team;
@end

@interface Grid : NSObject
@property (nonatomic) CGSize sizeOfBoard;
@property (nonatomic, weak) id<GridDelegate> delegate;
@property (readonly, nonatomic, retain) NSArray *pieces;
- (instancetype)init __unavailable;
- (instancetype)initWithSizeOfBoard:(uint)sizeOfBoard teams:(NSArray *)teams delegate:(id<GridDelegate>)delegate;
- (Piece *) getPieceAtLocation:(CGPoint)location;
- (Piece *)getPieceWithPieceID:(NSUUID *)pieceID;
- (Team *) getTeamForTeamID:(NSUUID *)teamID;
- (void)makeMove:(LegalMove *)legalMove;
- (BOOL)isLocationOnGridValid:(CGPoint)location;
@end
