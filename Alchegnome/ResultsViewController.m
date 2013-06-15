//
//  ResultsViewController.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ResultsViewController.h"
#import "GradientView.h"
#import "AFNetworking.h"

CGFloat const FrameWidth = 48.0f;
CGFloat const FrameHeight = 48.0f;

NSInteger const NumFramesX = 16;
NSInteger const NumFramesY = 20;

NSInteger const OffsetX = 0;//24;
NSInteger const OffsetY = 0;//24;

NSInteger const ExplosionWidth = 5;
NSInteger const ExplosionHeight = 5;

NSInteger const RandomX = 300;
NSInteger const RandomY = 300;

@interface ResultsViewController ()

@property (strong, nonatomic) NSMutableArray *gradientViews;
@property (strong, nonatomic) NSMutableArray *shuffledGradientViews;
@property (strong, nonatomic) NSArray *explodedViews;
@property (strong, nonatomic) UINib *gradientViewNib;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	 NSURL *url = [NSURL URLWithString:@""];
	 NSURLRequest *request = [NSURLRequest requestWithURL:url];
	 [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
	 
	 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
	 NSLog(@"Error: %@", error);
	 }];*/
	
	self.gradientViewNib = [UINib nibWithNibName:@"GradientView" bundle:[NSBundle mainBundle]];
	
	
	self.gradientViews = [[NSMutableArray alloc] init];
	for (int y = 0; y < NumFramesY; y++) {
		for (int x = 0; x < NumFramesX; x++) {
			GradientView *gradientView = [[self.gradientViewNib instantiateWithOwner:nil options:nil] lastObject];
			
			NSLog(@"width=%f", gradientView.frame.size.width);
			NSLog(@"position=%f", x * FrameWidth - OffsetX);
			gradientView.destinationX = x * FrameWidth - OffsetX;
			gradientView.destinationY = y * FrameHeight - OffsetY;
			
			CGRect frame = gradientView.frame;
			frame.origin.x = [self randomizeX:gradientView.destinationX];
			frame.origin.y = [self randomizeY:gradientView.destinationY];
			gradientView.frame = frame;
			
			[self.gradientViews addObject:gradientView];
		}
	}
	
	self.shuffledGradientViews = [NSMutableArray arrayWithArray:self.gradientViews];
	[self shuffleArray:self.shuffledGradientViews];
	
	[NSTimer scheduledTimerWithTimeInterval:0.003f target:self selector:@selector(addGradient:) userInfo:nil repeats:YES];
}

- (void)addGradient:(NSTimer *)timer {
	if (self.currentIndex >= self.gradientViews.count) {
		[timer invalidate];
	}
	else {
		GradientView *gradientView = [self.shuffledGradientViews objectAtIndex:self.currentIndex++];
		[self.view addSubview:gradientView];
		[self animateGradientViewIntoPosition:gradientView];
	}
}

- (void)animateGradientViewIntoPosition:(GradientView *)gradientView {
	[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
		CGRect frame = gradientView.frame;
		frame.origin.x = gradientView.destinationX;
		frame.origin.y = gradientView.destinationY;
		gradientView.frame = frame;
		gradientView.alpha = 1.0f;
	} completion:^(BOOL finished) {
		
	}];
	
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
	CATransform3D t = CATransform3DIdentity;
	t = CATransform3DRotate(t, M_PI, 0, 1, 0);
	t = CATransform3DScale(t, 0.5f, 0.5f, 1.0f);
	[anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
	[anim setToValue:[NSValue valueWithCATransform3D:t]];
	anim.removedOnCompletion = NO;
	[anim setDuration:0.3f];
	anim.fillMode = kCAFillModeForwards;
	anim.delegate = self;
	[gradientView.layer addAnimation:anim forKey:@"Rotation"];
}

- (void)shuffleArray:(NSMutableArray *)array {
	for (NSUInteger i = 0; i < array.count; ++i) {
		NSInteger index = arc4random_uniform(array.count - i) + i;
		[array exchangeObjectAtIndex:i withObjectAtIndex:index];
	}
}

- (NSInteger)randomizeX:(NSInteger)destinationX {
	return destinationX + arc4random_uniform(RandomX) - RandomX / 2;
}

- (NSInteger)randomizeY:(NSInteger)destinationY {
	return destinationY + arc4random_uniform(RandomY) - RandomY / 2;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchPoint = [touches.anyObject locationInView:self.view];
	//GradientView *gradientView = [self.gradientViews objectAtIndex:[self indexFromPoint:touchPoint]];
	
	NSArray *explosionViews = [self collectNearbyViewsFromPoint:touchPoint];
	
	for (GradientView *gradientView in explosionViews) {
		if (![self.explodedViews containsObject:gradientView])
			[self explodeGradientView:gradientView];
	}
	
	for (GradientView *gradientView in self.explodedViews) {
		if (![explosionViews containsObject:gradientView]) {
			[self animateGradientViewIntoPosition:gradientView];
		}
	}
	self.explodedViews = explosionViews;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchPoint = [touches.anyObject locationInView:self.view];
	//GradientView *gradientView = [self.gradientViews objectAtIndex:[self indexFromPoint:touchPoint]];
	
	NSArray *explosionViews = [self collectNearbyViewsFromPoint:touchPoint];
	
	for (GradientView *gradientView in explosionViews) {
		if (![self.explodedViews containsObject:gradientView])
			[self explodeGradientView:gradientView];
	}
	
	for (GradientView *gradientView in self.explodedViews) {
		if (![explosionViews containsObject:gradientView]) {
			[self animateGradientViewIntoPosition:gradientView];
		}
	}
	self.explodedViews = explosionViews;
}

- (void)explodeGradientView:(GradientView *)gradientView {
	[self.view bringSubviewToFront:gradientView];
	[UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
		CGRect frame = gradientView.frame;
		frame.origin.x = [self randomizeX:gradientView.destinationX];
		frame.origin.y = [self randomizeY:gradientView.destinationY];
		gradientView.frame = frame;
		gradientView.alpha = 0.4;
	} completion:^(BOOL finished) {
		
	}];
	
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
	CATransform3D t = CATransform3DIdentity;
	t = CATransform3DRotate(t, M_PI, 0, 1, 0);
	t = CATransform3DScale(t, 0.5f, 0.5f, 1.0f);
	[anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
	[anim setToValue:[NSValue valueWithCATransform3D:t]];
	anim.removedOnCompletion = NO;
	[anim setDuration:0.8f];
	anim.fillMode = kCAFillModeForwards;
	anim.delegate = self;
	[gradientView.layer addAnimation:anim forKey:@"Rotation"];
}

- (NSArray *)collectNearbyViewsFromPoint:(CGPoint)point {
	NSInteger yIndex = point.y / FrameHeight;
	NSInteger xIndex = point.x / FrameWidth;
	
	NSLog(@"selected index=%d,%d", xIndex, yIndex);
	
	NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:ExplosionWidth * ExplosionHeight];
	
	for (int x = xIndex - ExplosionWidth / 2; x <= xIndex + ExplosionWidth / 2; x++) {
		for (int y = yIndex - ExplosionHeight / 2; y <= yIndex + ExplosionHeight / 2; y++) {
			if (x >= 0 && x < NumFramesX && y >= 0 && y < NumFramesY) {
				NSLog(@"picking view with x=%d, y=%d", x, y);
				GradientView *gradientView = [self.gradientViews objectAtIndex:NumFramesX * y + x];
				[views addObject:gradientView];
			}
		}
	}
	return views;
}

- (NSInteger)indexFromPoint:(CGPoint)point {
	NSInteger yIndex = point.y / FrameHeight;
	NSInteger xIndex = point.x / FrameWidth;
	return NumFramesX * yIndex + xIndex;
}

/*
- (CGFloat)proximityToCenterWithX:(NSInteger)destinationX y:(NSInteger)destinationY {
	CGFloat xDistance = ABS(destinationX + FrameWidth / 2 - self.view.frame.size.width / 2);
	CGFloat yDistance = ABS(destinationY + FrameHeight / 2 - self.view.frame.size.height / 2);
	
	CGFloat average = xDistance + yDistance / 2;
	
	return MIN(1, average / (self.view.frame.size.width / 2));
}
 */

@end
