//
//  FifteenPuzzleViewController.h
//  FifteenPuzzle
//
//  Created by Hua Zhang on 2/13/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FifteenPuzzleViewController : UIViewController


- (IBAction)tileSelected:(UIButton *)sender;
- (IBAction)scrambleTiles:(id)sender;

-(void)arrangeBoardView;



@end
