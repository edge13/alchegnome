//
//  ResultsViewController.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface ResultsViewController : UIViewController

@property (strong, nonatomic) NSArray *results;
@property (weak, nonatomic) SearchViewController *delegate;

@end
