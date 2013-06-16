//
//  CalloutView.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalloutView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *kloutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *kloutBackground;

@property (weak, nonatomic) IBOutlet UILabel *retweetsMarker;
@property (weak, nonatomic) IBOutlet UILabel *favoritesMarker;

@property (weak, nonatomic) IBOutlet UIView *mainDivider;
@property (weak, nonatomic) IBOutlet UIView *smallDividerLeft;
@property (weak, nonatomic) IBOutlet UIView *smallDividerRight;

@end
