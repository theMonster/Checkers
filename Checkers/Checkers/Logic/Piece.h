//
//  Piece.h
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LegalMove.h"

@interface Piece : NSObject
@property (nonatomic) CGPoint location;
@property (nonatomic, retain) NSUUID *pieceID;
@property (nonatomic, retain) NSUUID *teamID;
- (LegalMove *)bestLegalMoveForGrid:(id)grid;
- (NSArray *)legalMovesForGrid:(id)grid;
@property (nonatomic) CGFloat legalYDirection;
- (instancetype)init __unavailable;
- (instancetype)initWithLocation:(CGPoint)location teamID:(NSUUID *)teamID legalYDirection:(CGFloat)legalYDirection;
@end
