//
//  GradientView.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

@property (assign, nonatomic) NSInteger destinationX;
@property (assign, nonatomic) NSInteger destinationY;

@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end
