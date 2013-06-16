//
//  SearchViewController.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SearchViewController.h"
#import "ResultsViewController.h"
#import "TweetResult.h"
#import "AFNetworking.h"

NSInteger const BubbleFrames = 9;
NSInteger const HairFrames = 10;
NSInteger const SmokeFrames = 10;

@interface SearchViewController ()

@property (assign, nonatomic) NSInteger bubblesLeftFrame;
@property (assign, nonatomic) NSInteger bubblesRightFrame;
@property (assign, nonatomic) NSInteger hairFrame;
@property (assign, nonatomic) NSInteger smokeFrame;

@property (strong, nonatomic) ResultsViewController *resultsController;
@property (assign, nonatomic) BOOL resultsVisible;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
	
	self.searchField.font = [UIFont fontWithName:@"Klinic Slab" size:30.0f];
	
	[self animateGearImageView:self.gearLeft duration:3.0f angle:-M_PI*2];
	[self animateGearImageView:self.gearMiddle duration:2.0f angle:-M_PI*2];
	[self animateGearImageView:self.gearRight duration:4.0f angle:M_PI*2];
	
	[self initializeBubbles];
	[self initializeHairView];
	[self initializeSmokeView];
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)initializeSmokeView {
	self.smokeFrame = 1;
	[NSTimer scheduledTimerWithTimeInterval:0.14f target:self selector:@selector(updateSmoke:) userInfo:nil repeats:YES];
}

- (void)initializeBubbles {
	self.bubblesLeftFrame = 1;
	[NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateLeftBubbles:) userInfo:nil repeats:YES];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.bubblesRightFrame = 1;
		[NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateRightBubbles:) userInfo:nil repeats:YES];
	});
	
}

- (void)initializeHairView {
	self.hairFrame = 1;
	[NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateHair:) userInfo:nil repeats:YES];
}

- (void)updateSmoke:(NSTimer *)timer {
	self.smokeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"smoke_animation_%d", self.smokeFrame]];
	self.smokeFrame++;
	if (self.smokeFrame > SmokeFrames) {
		self.smokeFrame = 1;
	}
}

- (void)updateLeftBubbles:(NSTimer *)timer {
	self.bubblesLeft.image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_animation_%d", self.bubblesLeftFrame]];
	self.bubblesLeftFrame++;
	if (self.bubblesLeftFrame > BubbleFrames) {
		self.bubblesLeftFrame = 1;
		[timer invalidate];
		CGFloat randomDelay = 0.5f + arc4random_uniform(10) / 15.0f;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateLeftBubbles:) userInfo:nil repeats:YES];
		});
	}
}

- (void)updateRightBubbles:(NSTimer *)timer {
	self.bubblesRight.image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble2_animation_%d", self.bubblesRightFrame]];
	self.bubblesRightFrame++;
	if (self.bubblesRightFrame > BubbleFrames) {
		self.bubblesRightFrame = 1;
		[timer invalidate];
		CGFloat randomDelay = 1.0f + arc4random_uniform(10) / 15.0f;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateRightBubbles:) userInfo:nil repeats:YES];
		});
	}
}

- (void)updateHair:(NSTimer *)timer {
	self.hairView.image = [UIImage imageNamed:[NSString stringWithFormat:@"hair_animation_%d", self.hairFrame]];
	self.hairFrame++;
	if (self.hairFrame > HairFrames) {
		self.hairFrame = 1;
	}
}

- (void)animateGearImageView:(UIImageView *)gearImageView duration:(CGFloat)duration angle:(CGFloat)angle {
	CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotation.byValue = @(angle);
	rotation.duration = duration;
	rotation.repeatCount = HUGE_VALF;
	[gearImageView.layer addAnimation:rotation forKey:@"rotationAnimation"];
}

- (IBAction)search:(id)sender {
	[self.view endEditing:NO];
	
	NSString *path = [NSString stringWithFormat:@"http://alchegnome.herokuapp.com/api/search?q=%@", self.searchField.text];
	NSString *encodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:encodedPath];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSLog(@"invoking: %@", encodedPath);
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		NSMutableArray *results = [[NSMutableArray alloc] init];
		NSLog(@"operation complete");
		for (NSDictionary *dictionary in JSON) {
			TweetResult *tweet = [[TweetResult alloc] init];
			tweet.text = [dictionary objectForKey:@"text"];
			tweet.sentimentType = [[dictionary objectForKey:@"sentiment"] objectForKey:@"type"];
			tweet.sentimentScore = [[dictionary objectForKey:@"sentiment"] objectForKey:@"score"];
			tweet.retweetCount = [dictionary objectForKey:@"retweet_count"];
			tweet.favoriteCount = [dictionary objectForKey:@"favorite_count"];
			tweet.location = [[dictionary objectForKey:@"user"] objectForKey:@"location"];
			tweet.fullName = [[dictionary objectForKey:@"user"] objectForKey:@"name"];
			tweet.profileImageUrl = [[dictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
			
			[results addObject:tweet];
		}
		
		self.resultsController = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:[NSBundle mainBundle]];
		self.resultsController.results = results;
		
		[self.view addSubview:self.resultsController.view];
		self.resultsVisible = YES;
		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
	}];
	
	[operation start];
}

- (BOOL)shouldAutorotate {
	return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.resultsVisible)
		[self.resultsController touchesBegan:touches withEvent:event];
	else
		[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.resultsVisible)
		[self.resultsController touchesMoved:touches withEvent:event];
	else
		[super touchesMoved:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self search:nil];
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	self.searchButton.selected = newString.length > 0;
	return YES;
}

@end
