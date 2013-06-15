//
//  SearchViewController.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)search:(id)sender {
	ResultsViewController *vc = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
