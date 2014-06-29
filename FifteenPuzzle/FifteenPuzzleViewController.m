//
//  FifteenPuzzleViewController.m
//  FifteenPuzzle
//
//  Created by Hua Zhang on 2/13/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "FifteenPuzzleViewController.h"

#import "FifteenPuzzleBoard.h"

@interface FifteenPuzzleViewController ()

@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (strong, nonatomic) FifteenPuzzleBoard *board;


@end

#define NUM_SHUFFLES  50

@implementation FifteenPuzzleViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.board = [[FifteenPuzzleBoard alloc] init]; // create/init board
    [self.board scramble:NUM_SHUFFLES ];            // scramble tiles
    [self arrangeBoardView];                        //sync view with model
    
    
    UIImage *blueImage = [UIImage imageNamed:@"bordered-blue-button"];
    UIImage *stretchyBlueImage =
    [blueImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                              resizingMode:UIImageResizingModeStretch];
    for (int tile = 1; tile <= 15; tile++) {
        UIButton *button = (UIButton *)[self.boardView viewWithTag:tile];
        [button setBackgroundImage:stretchyBlueImage forState:UIControlStateNormal];
    }
    
  
//    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tileSelected:(UIButton *)sender {
    const int tag = [sender tag];
    //NSLog(@"tileSelected: %d", tag);
    int row, col;
    
    [self.board getRow:&row Column:&col ForTile:tag];
    CGRect buttonFrame = sender.frame;
    if([self.board canSlideTileUpAtRow:row Column:col]){
        [self.board slideTileAtRow:row Column:col];
        buttonFrame.origin.y = (row-1)*buttonFrame.size.height;
        [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
    }
    else if([self.board canSlideTileDownAtRow:row Column:col]){
        [self.board slideTileAtRow:row Column:col];
        buttonFrame.origin.y = (row+1)*buttonFrame.size.height;
        [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
    }
    else if([self.board canSlideTileLeftAtRow:row Column:col]){
        [self.board slideTileAtRow:row Column:col];
        buttonFrame.origin.x = (col-1)*buttonFrame.size.width;
        [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
    }
    else if([self.board canSlideTileRightAtRow:row Column:col]){
        [self.board slideTileAtRow:row Column:col];
        buttonFrame.origin.x = (col+1)*buttonFrame.size.width;
        [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
    }
    [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
    
    if ([self.board isSolved]) {
        [self showCongs];
        NSLog(@"Congratulations!");
    }

}


- (IBAction)scrambleTiles:(id)sender {
     NSLog(@"New game");
    
    
    [self.board scramble:NUM_SHUFFLES];
    [self arrangeBoardView];
}



- (IBAction)selectPhoto:(UIBarButtonItem *)sender {
    NSLog(@"select the photo from library");
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        pickerController.sourceType =
                    UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }   else if ([UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerController.sourceType =
                        UIImagePickerControllerSourceTypePhotoLibrary;
     }
     pickerController.allowsEditing = YES;
     pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:NULL];
    

}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Set  background of Buttons with the image
    [self setBackgroundImageOfButtons:image]; // helper method using CG
}

/*Provided by Bo Wang, WSU Vancouver ENCS from Dr. Cochran CS458*/
//Divvy up a background image (using  Core Graphics)
-(void)setBackgroundImageOfButtons:(UIImage*)image {
    const CGFloat imageTileWidth = image.size.width/4;
    const CGFloat imageTileHeight = image.size.height/4;
    for (int row = 0; row < 4; row++)
        for (int col = 0; col < 4; col++) {
            const int tile = [self.board getTileAtRow:row Column:col];
            if (tile > 0) {
                const int r = (tile - 1) / 4;
                const int c = (tile - 1) % 4;
                const CGRect tileFrame = CGRectMake(c*imageTileWidth, r*imageTileHeight,
                                                    imageTileWidth, imageTileHeight);
                CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], tileFrame);
                UIImage* subImage = [UIImage imageWithCGImage: imageRef];
                CGImageRelease(imageRef);
                __weak UIButton *button = (UIButton *)[self.boardView viewWithTag:tile];
                [button setBackgroundImage:subImage forState:UIControlStateNormal];
            }
        }
}

- (void)arrangeBoardView{
    //NSLog(@"exec arrangeBoardView");
    const CGRect boardBounds = self.boardView.bounds;
    const CGFloat tileWidth = boardBounds.size.width / 4;
    const CGFloat tileHeight = boardBounds.size.height / 4;
    for(int row = 0; row < 4; row++){
        for(int col = 0; col < 4; col++){
            const int tile = [self.board getTileAtRow:row Column:col];
            if(tile > 0){
                UIButton *button = (UIButton *)[self.boardView viewWithTag:tile];
                button.frame = CGRectMake(col*tileWidth, row*tileHeight, tileWidth, tileHeight);
                
            }
        }
    }
}

//Show Congratulations after the user finished the game
-(void)showCongs {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                          message:@"You win!"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [message show];
}

@end
