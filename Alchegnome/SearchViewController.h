//
//  SearchViewController.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *gearLeft;
@property (weak, nonatomic) IBOutlet UIImageView *gearMiddle;
@property (weak, nonatomic) IBOutlet UIImageView *gearRight;

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet UIImageView *hairView;
@property (weak, nonatomic) IBOutlet UIImageView *bubblesLeft;
@property (weak, nonatomic) IBOutlet UIImageView *bubblesRight;
@property (weak, nonatomic) IBOutlet UIImageView *smokeView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

- (IBAction)search:(id)sender;

@end
