//
//  ViewController.h
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"

#define SIZE_OF_BOARD 8

@interface CheckerViewController : UIViewController
@property (weak, nonatomic) IBOutlet GridView *gridView;
@end