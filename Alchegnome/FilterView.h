//
//  FilterView.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/16/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface FilterView : UIView

@property (weak, nonatomic) SearchViewController *delegate;

@property (weak, nonatomic) IBOutlet UIImageView *allApis;
@property (weak, nonatomic) IBOutlet UIImageView *twitter;
@property (weak, nonatomic) IBOutlet UIImageView *context;

@property (weak, nonatomic) IBOutlet UIImageView *allTime;
@property (weak, nonatomic) IBOutlet UIImageView *today;
@property (weak, nonatomic) IBOutlet UIImageView *yesterday;
@property (weak, nonatomic) IBOutlet UIImageView *pastWeek;
@property (weak, nonatomic) IBOutlet UIImageView *pastMonth;

- (IBAction)close:(id)sender;

- (IBAction)onAllApis:(id)sender;
- (IBAction)onTwitter:(id)sender;
- (IBAction)onContext:(id)sender;

- (IBAction)onAllTime:(id)sender;
- (IBAction)onToday:(id)sender;
- (IBAction)onYesterday:(id)sender;
- (IBAction)onPastWeek:(id)sender;
- (IBAction)onPastMonth:(id)sender;

@end
