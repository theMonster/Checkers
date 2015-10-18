//
//  GridView.h
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GridViewDelegate
@required
- (void) userDidTapAtGridLocation:(CGPoint)gridLocation;
@end

@interface GridView : UIImageView
@property (nonatomic, retain) IBOutlet id<GridViewDelegate> delegate;
- (CGRect) getRectForGridPosition:(CGPoint)gridPosition;
@end
