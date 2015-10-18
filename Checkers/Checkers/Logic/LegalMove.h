//
//  LegalMove.h
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegalMove : NSObject
@property (nonatomic, retain) NSUUID *pieceID;
@property (nonatomic, retain) NSUUID *killPieceID;
@property (nonatomic) CGPoint newLocation;
- (instancetype)init __unavailable;
- (instancetype)initWithPieceID:(NSUUID *)pieceID newLocation:(CGPoint)newLocation;
- (NSString *)description;
@end
