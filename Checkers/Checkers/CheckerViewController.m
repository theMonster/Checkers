//
//  ViewController.m
//  Checkers
//
//  Created by Caleb Jonassaint on 10/14/14.
//  Copyright (c) 2014 Caleb Jonassaint. All rights reserved.
//

#import "CheckerViewController.h"
#import "Grid.h"
#import "PieceView.h"

@interface CheckerViewController () <GridViewDelegate, GridDelegate>
@property (nonatomic, retain) Grid *grid;
@property (nonatomic, retain) Team *user;
@property (nonatomic, retain) Team *ai;
@property (nonatomic, retain) NSMutableDictionary *pieceViews;
@property (nonatomic, retain) Piece *activePiece;
@property (nonatomic) BOOL isAIsTurn;
@end

@implementation CheckerViewController

- (void)teamDidWinGame:(Team *)team {
    NSString *message;
    if (!team) {
        message = @"Stale Mate!";
    } else if (team == self.ai) {
        message = @"The Computer Won!";
    } else if (team == self.user) {
        message = @"You Won!";
    }
    [[[UIAlertView alloc] initWithTitle:@"Game Over!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    self.gridView.userInteractionEnabled = NO;
}

- (void)pieceDidGetKilled:(Piece *)piece {
    [self.pieceViews[piece.pieceID] removeFromSuperview];
}

- (void)shouldInstantiatePiece:(Piece *)piece {
    PieceView *view = [[PieceView alloc] initWithImage:[piece.teamID isEqual:self.user.teamId] ? [UIImage imageNamed:@"blackPiece"] : [UIImage imageNamed:@"whitePiece"]];
    view.frame = [self.gridView getRectForGridPosition:piece.location];
    [self.view addSubview:view];
    // save for later
    self.pieceViews[piece.pieceID] = view;
}

- (void)didMovePiece:(Piece *)piece {
    [UIView animateWithDuration:0.3 animations:^{
        [self.pieceViews[piece.pieceID] setFrame:[self.gridView getRectForGridPosition:piece.location]]; // just update the frame
    }];
}

// TODO: adapt so multiple teams can play (which breaks the rules of the game but whatever)
- (void)userDidTapAtGridLocation:(CGPoint)gridLocation {
    Piece *piece = [self.grid getPieceAtLocation:gridLocation];
    if (!piece && self.activePiece) {
        piece = self.activePiece;
        // check if this new location is legal:
        BOOL didFindLegalMove = NO;
        for (LegalMove *move in [piece legalMovesForGrid:self.grid]) {
            if (CGPointEqualToPoint(move.newLocation, gridLocation)) {
                // move the piece
                [self.grid makeMove:move];
                didFindLegalMove = YES;
                // process the AI's turn
                LegalMove *move = [self.ai bestMoveToMakeForGrid:self.grid];
                if (move) [self.grid makeMove:move];
            }
        }
        if (!didFindLegalMove) NSLog(@"Not a legal move!");
        // un-highlight the pieces square
        UIImageView *pieceView = self.pieceViews[piece.pieceID];
        pieceView.layer.borderColor = nil;
        pieceView.layer.borderWidth = 0;
        // reset the active piece
        self.activePiece = nil;
    } else if ([piece.teamID isEqual:self.user.teamId]) { // make sure the user can move the piece
        // TODO: Optimize
        // lazily un-highlight everything else
        for (UIImageView *pieceView in self.pieceViews.allValues) {
            pieceView.layer.borderColor = nil;
            pieceView.layer.borderWidth = 0;
        }
        // highlight the pieces square
        UIImageView *pieceView = self.pieceViews[piece.pieceID];
        pieceView.layer.borderColor = [UIColor blueColor].CGColor;
        pieceView.layer.borderWidth = 2;
        self.activePiece = piece;
        // highlight legal moves
            // if (move.killPiece != nil) // red
            // else // green
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pieceViews = [NSMutableDictionary dictionary];
}

- (void)viewDidAppear:(BOOL)animated {
    self.user = [[Team alloc] initWithTeamStartingPosition:OnTop];
    self.ai = [[Team alloc] initWithTeamStartingPosition:OnBottom];
    self.grid = [[Grid alloc] initWithSizeOfBoard:SIZE_OF_BOARD teams:@[ self.user, self.ai ] delegate:self];
}

- (void)viewDidLayoutSubviews {
    // re-layout all pieces
    for (NSUUID *pieceID in self.pieceViews.allKeys) {
        PieceView *pieceView = self.pieceViews[pieceID];
        Piece *piece = [self.grid getPieceWithPieceID:pieceID]; // TODO: Optimize
        [UIView animateWithDuration:0.3 animations:^{
            pieceView.frame = [self.gridView getRectForGridPosition:piece.location];
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
