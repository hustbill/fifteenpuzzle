//
//  FifteenPuzzleBoard.m
//  FifteenPuzzle
//
//  Created by Hua Zhang on 2/13/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "FifteenPuzzleBoard.h"


@implementation FifteenPuzzleBoard {
    int state[4][4];
}

// Initialize a new 15-puzzle board with the tiles in the solved configuration
// (only called once when the puzzle is instantiated).
-(id)init {
    self = [super init];
    if (self) {
        int i = 1;
        for(int r = 0; r < 4; r++){         // row
            for(int c = 0; c < 4; c++){     // column
                state[r][c] = i++;                
            }
        }
    }
    state[3][3] = 0; // the value of empty spot position in 15 puzzle is 0
    return self;
};


//Choose one of the “slidable” tiles at random and slide it into the empty space;
//repeat n times. We use this method to start a new game using a large value (e.g., 150) for n.
-(void)scramble:(int)n{
    for(int i = 0; i < n; i++){
        int row, col;
        BOOL left = NO, right = NO, up = NO, down = NO;
        while(left == NO && right == NO && up == NO && down ==NO){
            int move = (arc4random() % 14) + 1; 
            [self getRow:&row Column:&col ForTile:move];
            if([self canSlideTileUpAtRow:row Column:col]){
                up = YES;
            }
            else if([self canSlideTileDownAtRow:row Column:col]){
                down = YES;
            }
            else if([self canSlideTileLeftAtRow:row Column:col]){
                left = YES;
            }
            else if([self canSlideTileRightAtRow:row Column:col]){
                right = YES;
            }
        }
        [self slideTileAtRow:row Column:col];
    }
}

//Fetch the tile at the given position (0 is used for the space).
-(int)getTileAtRow:(int)row Column:(int)col{
    //NSLog(@"%d", state[row][col]);
    return state[row][col];
}

//Find the position of the given tile (0 is used for the space).
-(void)getRow:(int*)row Column:(int*)col ForTile:(int)tile{
      //NSLog(@"exec getRow- row: %d, col: %d", row, col);
    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            if(tile == state[i][j]){
                //NSLog(@"Found at row: %d, col: %d", i, j);
                *row = i;
                *col = j;
            }
        }
    }
}


//Determine if the specified tile can be slid up into the empty space.
-(BOOL)canSlideTileDownAtRow:(int)row Column:(int)col{
    if(row < 3)
        if(state[row+1][col] == 0){
          return YES;
        }
    return NO;
}


-(BOOL)canSlideTileUpAtRow:(int)row Column:(int)col{
    //NSLog(@"exec canSlideTileUpAtRow- row: %d, col: %d", row, col);
    if(row > 0){
        if(state[row-1][col] == 0){
            return YES;
        }
    }
    return NO;
}

//Determine if puzzle is in solved configuration.
-(BOOL)isSolved{
    for (int i = 0; i < 15; i++) {
        int row = i / 4;
        int col = i % 4;
        if (state[row][col] != ((i+1)%16))
            return NO;
    }
    return YES;
}


-(BOOL)canSlideTileLeftAtRow:(int)row Column:(int)col{
     //NSLog(@"exec canSlideTileLeftAtRow- row: %d, col: %d", row, col);
    if(col > 0)
        if(state[row][col-1] == 0){
           return YES;
        }
    return NO;
}

-(BOOL)canSlideTileRightAtRow:(int)row Column:(int)col{
     //NSLog(@"exec canSlideTileRightAtRow- row: %d, col: %d", row, col);
    if(col < 3)
        if(state[row][col+1] == 0){
            return YES;
        }
    return NO;
}

//Slide the tile into the empty space.
-(void)slideTileAtRow:(int)row Column:(int)col{
     //NSLog(@"exec slideTileAtRow- row: %d, col: %d", row, col);
    int tempRow, tempCol, temp;
    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            if(state[i][j] == 0){ // state[i][j]=0 means the empty tile
                tempRow = i;
                tempCol = j;
                break;
            }
        }
    }
    temp = state[tempRow][tempCol]; //do swap now
    state[tempRow][tempCol] = state[row][col];
    state[row][col] = temp;
    if([self isSolved])
        NSLog(@"Fifteen Puzzle solved");
}

@end