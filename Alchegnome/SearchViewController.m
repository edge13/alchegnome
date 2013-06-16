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
#import "FilterView.h"

NSInteger const BubbleFrames = 9;
NSInteger const HairFrames = 10;
NSInteger const SmokeFrames = 10;
NSInteger const BeakerFrames = 6;

@interface SearchViewController ()

@property (assign, nonatomic) NSInteger bubblesLeftFrame;
@property (assign, nonatomic) NSInteger bubblesRightFrame;
@property (assign, nonatomic) NSInteger hairFrame;
@property (assign, nonatomic) NSInteger smokeFrame;
@property (assign, nonatomic) NSInteger beakerFrame;

@property (assign, nonatomic) NSInteger greenBubblesFrame;
@property (assign, nonatomic) NSInteger yellowBubblesFrame;
@property (assign, nonatomic) NSInteger orangeBubblesFrame;

@property (strong, nonatomic) ResultsViewController *resultsController;
@property (assign, nonatomic) BOOL resultsVisible;

@property (strong, nonatomic) NSTimer *smokeTimer;
@property (strong, nonatomic) NSTimer *hairTimer;
@property (strong, nonatomic) NSTimer *leftBubbleTimer;
@property (strong, nonatomic) NSTimer *rightBubbleTimer;
@property (strong, nonatomic) NSTimer *beakerTimer;
@property (strong, nonatomic) NSTimer *greenBubblesTimer;
@property (strong, nonatomic) NSTimer *yellowBubblesTimer;
@property (strong, nonatomic) NSTimer *orangeBubblesTimer;

@property (strong, nonatomic) NSDateFormatter *formatter;

@property (strong, nonatomic) FilterView *filterView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
	
	self.searchField.font = [UIFont fontWithName:@"Klinic Slab 2" size:30.0f];
	self.formatter = [[NSDateFormatter alloc] init];
	self.formatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZ yyyy";
	
	[self animateGearImageView:self.gearLeft duration:3.0f angle:-M_PI*2];
	[self animateGearImageView:self.gearMiddle duration:2.0f angle:-M_PI*2];
	[self animateGearImageView:self.gearRight duration:4.0f angle:M_PI*2];
	
	[self initializeBubbles];
	[self initializeHairView];
	[self initializeSmokeView];
	[self initializeFilterView];
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	
	NSLog(@"%@", [UIFont familyNames]);
}

- (void)initializeFilterView {
	UINib *nib = [UINib nibWithNibName:@"FilterView" bundle:[NSBundle mainBundle]];
	self.filterView = [[nib instantiateWithOwner:nil options:nil] lastObject];
	
	CGRect frame = self.filterView.frame;
	frame.origin.x = -frame.size.width;
	frame.origin.y = 476.0f;
	
	self.filterView.frame = frame;
	self.filterView.delegate = self;
	[self.view addSubview:self.filterView];
}

- (void)initializeSmokeView {
	self.smokeFrame = 1;
	self.smokeTimer = [NSTimer scheduledTimerWithTimeInterval:0.14f target:self selector:@selector(updateSmoke:) userInfo:nil repeats:YES];
}

- (void)initializeBubbles {
	self.bubblesLeftFrame = 1;
	self.leftBubbleTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateLeftBubbles:) userInfo:nil repeats:YES];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.bubblesRightFrame = 1;
		self.rightBubbleTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateRightBubbles:) userInfo:nil repeats:YES];
	});
	
}

- (void)initializeLoadingBubbles {
	[self.greenBubblesTimer invalidate];
	[self.orangeBubblesTimer invalidate];
	[self.yellowBubblesTimer invalidate];
	
	self.greenBubblesFrame = 1;
	self.greenBubblesTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateGreenBubbles:) userInfo:nil repeats:YES];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.yellowBubblesFrame = 1;
		self.yellowBubblesTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateYellowBubbles:) userInfo:nil repeats:YES];
	});
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.orangeBubblesFrame = 1;
		self.orangeBubblesTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateOrangeBubbles:) userInfo:nil repeats:YES];
	});
}

- (void)initializeHairView {
	[self.hairTimer invalidate];
	self.hairFrame = 1;
	self.hairTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateHair:) userInfo:nil repeats:YES];
}

- (void)initializeBeakerView {
	[self.beakerTimer invalidate];
	
	self.beakerFrame = 1;
	self.beakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.18f target:self selector:@selector(updateBeaker:) userInfo:nil repeats:YES];
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
			self.leftBubbleTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateLeftBubbles:) userInfo:nil repeats:YES];
		});
	}
}

- (void)updateRightBubbles:(NSTimer *)timer {
	self.bubblesRight.image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_animation_%d", self.bubblesRightFrame]];
	self.bubblesRightFrame++;
	if (self.bubblesRightFrame > BubbleFrames) {
		self.bubblesRightFrame = 1;
		[timer invalidate];
		CGFloat randomDelay = 0.5f + arc4random_uniform(10) / 15.0f;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			self.rightBubbleTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateRightBubbles:) userInfo:nil repeats:YES];
		});
	}
}

- (void)updateGreenBubbles:(NSTimer *)timer {
	self.greenBubbles.image = [UIImage imageNamed:[NSString stringWithFormat:@"green_animation_%d", self.greenBubblesFrame]];
	self.greenBubblesFrame++;
	if (self.greenBubblesFrame > BubbleFrames) {
		self.greenBubblesFrame = 1;
		[timer invalidate];
		CGFloat randomDelay = 1.0f + arc4random_uniform(10) / 15.0f;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if (!self.resultsVisible)
				self.greenBubblesTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateGreenBubbles:) userInfo:nil repeats:YES];
		});
	}
}

- (void)updateYellowBubbles:(NSTimer *)timer {
	self.yellowBubbles.image = [UIImage imageNamed:[NSString stringWithFormat:@"yellow_animation_%d", self.yellowBubblesFrame]];
	self.yellowBubblesFrame++;
	if (self.yellowBubblesFrame > BubbleFrames) {
		self.yellowBubblesFrame = 1;
		[timer invalidate];
		CGFloat randomDelay = 1.0f + arc4random_uniform(10) / 15.0f;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if (!self.resultsVisible)
				self.yellowBubblesTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateYellowBubbles:) userInfo:nil repeats:YES];
		});
	}
}

- (void)updateOrangeBubbles:(NSTimer *)timer {
	
	self.orangeBubbles.image = [UIImage imageNamed:[NSString stringWithFormat:@"orange_animation_%d", self.orangeBubblesFrame]];
	self.orangeBubblesFrame++;
	if (self.orangeBubblesFrame > BubbleFrames) {
		self.orangeBubblesFrame = 1;
		[timer invalidate];
		CGFloat randomDelay = 1.0f + arc4random_uniform(10) / 15.0f;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if (!self.resultsVisible)
				self.orangeBubblesTimer = [NSTimer scheduledTimerWithTimeInterval:0.12f target:self selector:@selector(updateOrangeBubbles:) userInfo:nil repeats:YES];
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

- (void)updateBeaker:(NSTimer *)timer {
	self.beakerView.image = [UIImage imageNamed:[NSString stringWithFormat:@"beakers_animation_%d", self.beakerFrame]];
	self.beakerFrame++;
	if (self.beakerFrame > BeakerFrames)
		self.beakerFrame = 1;
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
	
	[UIView animateWithDuration:1.0f animations:^{
		self.searchField.alpha = 0.0f;
		self.searchButton.alpha = 0.0f;
		self.bubblesLeft.alpha = 0.0f;
		self.bubblesRight.alpha = 0.0f;
		self.gearLeft.alpha = 0.0f;
		self.gearMiddle.alpha = 0.0f;
		self.gearRight.alpha = 0.0f;
		self.machineImage.alpha = 0.0f;
		self.filterButton.alpha = 0.0f;
		self.smokeView.alpha = 0.0f;
		
		self.beakerView.alpha = 1.0f;
		self.greenBubbles.alpha = 1.0f;
		self.yellowBubbles.alpha = 1.0f;
		self.orangeBubbles.alpha = 1.0f;
		
		CGRect frame = self.hairView.frame;
		frame.origin.y = 200.0f;
		self.hairView.frame = frame;
	} completion:^(BOOL finished) {
		[self.gearLeft.layer removeAllAnimations];
		[self.gearRight.layer removeAllAnimations];
		[self.gearMiddle.layer removeAllAnimations];
		
		[self.leftBubbleTimer invalidate];
		[self.rightBubbleTimer invalidate];
		[self.smokeTimer invalidate];
	}];
	
	[self initializeBeakerView];
	[self initializeLoadingBubbles];
	[self initializeLoadingBubbles];
	
	NSString *path = [NSString stringWithFormat:@"http://alchegnome.herokuapp.com/api/search?q=%@", self.searchField.text];
	NSString *encodedPath = [path stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:encodedPath];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSLog(@"invoking: %@", encodedPath);
	
	NSDate *startTime = [NSDate date];
	
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
			tweet.handle = [[dictionary objectForKey:@"user"] objectForKey:@"screen_name"];
			tweet.profileImageUrl = [[dictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
			tweet.kloutScore = [dictionary objectForKey:@"klout_score"];
			tweet.tweetLocation = [dictionary objectForKey:@"location"];
			tweet.tweetTime = [self.formatter dateFromString:[dictionary objectForKey:@"created_at"]];
			
			[results addObject:tweet];
		}
		
		NSTimeInterval timeInterval = [startTime timeIntervalSinceNow];
		NSInteger wait = MAX(4 - timeInterval, 0);
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, wait * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			self.resultsController = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:[NSBundle mainBundle]];
			self.resultsController.results = results;
			self.resultsController.delegate = self;
			
			self.resultsController.view.alpha = 0.0f;
			[self.view addSubview:self.resultsController.view];
			
			[UIView animateWithDuration:2.0f animations:^{
				self.resultsController.view.alpha = 1.0f;
				self.backgroundGradient.alpha = 0.0f;
				self.beakerView.alpha = 0.0f;
				self.greenBubbles.alpha = 0.0f;
				self.yellowBubbles.alpha = 0.0f;
				self.orangeBubbles.alpha = 0.0f;
				self.hairView.alpha = 0.0f;
			} completion:^(BOOL finished) {
				self.resultsVisible = YES;
				[self.beakerTimer invalidate];
				[self.yellowBubblesTimer invalidate];
				[self.greenBubblesTimer invalidate];
				[self.orangeBubblesTimer invalidate];
				[self.hairTimer invalidate];
				
				self.hairFrame = 1;
				self.yellowBubblesFrame = 1;
				self.greenBubblesFrame = 1;
				self.orangeBubblesFrame = 1;
				self.beakerFrame = 1;
			}];
		});
		

		
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		NSLog(@"Error: %@", error);
		[self closeResults];
	}];
	
	[operation start];
}

- (void)filter:(id)sender {
	[UIView animateWithDuration:0.8f animations:^{
		CGRect frame = self.filterView.frame;
		frame.origin.x = 0;
		self.filterView.frame = frame;
	}];
}

- (void)closeFilter {
	[UIView animateWithDuration:0.8f animations:^{
		CGRect frame = self.filterView.frame;
		frame.origin.x = -frame.size.width;
		self.filterView.frame = frame;
	}];
}

- (BOOL)shouldAutorotate {
	return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.resultsVisible)
		[self.resultsController touchesBegan:touches withEvent:event];
	else {
		CGPoint touchPoint = [touches.anyObject locationInView:self.view];
		if (self.filterView.frame.origin.x == 0 && !CGRectContainsPoint(self.filterView.frame, touchPoint))
			[self closeFilter];
		else
			[super touchesBegan:touches withEvent:event];
	}
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

- (void)closeResults {
	self.searchField.text = @"";
	self.searchButton.selected = NO;
	
	[self animateGearImageView:self.gearLeft duration:3.0f angle:-M_PI*2];
	[self animateGearImageView:self.gearMiddle duration:2.0f angle:-M_PI*2];
	[self animateGearImageView:self.gearRight duration:4.0f angle:M_PI*2];
	
	[self initializeBubbles];
	[self initializeHairView];
	[self initializeSmokeView];
	
	[UIView animateWithDuration:1.0f animations:^{
		self.searchField.alpha = 1.0f;
		self.searchButton.alpha = 1.0f;
		self.bubblesLeft.alpha = 0.2f;
		self.bubblesRight.alpha = 0.2f;
		self.gearLeft.alpha = 1.0f;
		self.gearMiddle.alpha = 1.0f;
		self.gearRight.alpha = 1.0f;
		self.machineImage.alpha = 1.0f;
		self.filterButton.alpha = 1.0f;
		self.smokeView.alpha = 0.2f;
		self.hairView.alpha = 1.0f;
		self.backgroundGradient.alpha = 1.0f;
		
		CGRect frame = self.hairView.frame;
		frame.origin.y = 92.0f;
		self.hairView.frame = frame;
		
		self.beakerView.alpha = 0.0f;
		self.greenBubbles.alpha = 0.0f;
		self.yellowBubbles.alpha = 0.0f;
		self.orangeBubbles.alpha = 0.0f;
	}];
	
	self.resultsVisible = NO;
}

@end
