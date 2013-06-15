//
//  SearchViewController.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"
#import "TweetResult.h"
#import "AFNetworking.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)search:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://alchegnome.herokuapp.com/api/adamchura"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSMutableArray *results = [[NSMutableArray alloc] init];
		for (NSDictionary *dictionary in JSON) {
			TweetResult *tweet = [[TweetResult alloc] init];
			tweet.text = [dictionary objectForKey:@"text"];
			tweet.sentimentType = [[dictionary objectForKey:@"sentiment"] objectForKey:@"type"];
			tweet.sentimentScore = [[dictionary objectForKey:@"sentiment"] objectForKey:@"score"];
			[results addObject:tweet];
		}
		
		ResultsViewController *vc = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:[NSBundle mainBundle]];
		vc.results = results;
		[self.navigationController pushViewController:vc animated:YES];
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

@end
