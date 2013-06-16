//
//  SearchViewController.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundGradient;

@property (weak, nonatomic) IBOutlet UIImageView *gearLeft;
@property (weak, nonatomic) IBOutlet UIImageView *gearMiddle;
@property (weak, nonatomic) IBOutlet UIImageView *gearRight;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIImageView *hairView;
@property (weak, nonatomic) IBOutlet UIImageView *bubblesLeft;
@property (weak, nonatomic) IBOutlet UIImageView *bubblesRight;
@property (weak, nonatomic) IBOutlet UIImageView *smokeView;

@property (weak, nonatomic) IBOutlet UIImageView *machineImage;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIImageView *beakerView;
@property (weak, nonatomic) IBOutlet UIImageView *greenBubbles;
@property (weak, nonatomic) IBOutlet UIImageView *yellowBubbles;
@property (weak, nonatomic) IBOutlet UIImageView *orangeBubbles;

- (IBAction)search:(id)sender;
- (IBAction)filter:(id)sender;

- (void)closeResults;
- (void)closeFilter;

@end
