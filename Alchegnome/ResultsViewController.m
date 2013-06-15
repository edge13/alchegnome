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
#import "TweetResult.h"

CGFloat const FrameWidth = 48.0f;
CGFloat const FrameHeight = 48.0f;

NSInteger const NumFramesX = 16;
NSInteger const NumFramesY = 20;

NSInteger const OffsetX = 24;
NSInteger const OffsetY = 24;

NSInteger const ExplosionWidth = 5;
NSInteger const ExplosionHeight = 5;

NSInteger const RandomX = 300;
NSInteger const RandomY = 300;

@interface ResultsViewController ()

@property (strong, nonatomic) NSMutableArray *gradientViews;
@property (strong, nonatomic) NSMutableArray *shuffledGradientViews;
@property (strong, nonatomic) NSArray *gradientColors;
@property (strong, nonatomic) NSArray *explodedViews;
@property (strong, nonatomic) UINib *gradientViewNib;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.gradientColors = @[@"aaee23", @"bceb1b", @"c9e916", @"d3e811", @"dde60d", @"e0e60c", @"e7e509", @"f0e305", @"f4e303", @"f9e201", @"f8da01", @"f5cc01", @"f2bd01", @"efb001", @"eca201", @"e89201", @"e58301", @"e17301", @"de6701", @"db5501"];

	
	self.gradientViewNib = [UINib nibWithNibName:@"GradientView" bundle:[NSBundle mainBundle]];
	
	self.results = [self.results sortedArrayUsingComparator:^NSComparisonResult(TweetResult *obj1, TweetResult *obj2) {
		if (obj1.sentimentScore.floatValue > obj2.sentimentScore.floatValue)
			return NSOrderedAscending;
		else
			return NSOrderedDescending;
	}];
	
	NSLog(@"max=%f", [[[self.results objectAtIndex:0] sentimentScore] floatValue]);
	NSLog(@"min=%f", [[[self.results lastObject] sentimentScore] floatValue]);
	
	TweetResult *bestResult = [self.results objectAtIndex:0];
	TweetResult *worstResult = [self.results lastObject];
	
	
	
	
	self.gradientViews = [[NSMutableArray alloc] init];
	for (NSInteger y = 0; y < NumFramesY; y++) {
		
		CGFloat totalScore = 0;
		
		for (NSInteger x = 0; x < NumFramesX; x++) {
			if (y * NumFramesX + x >= self.results.count)
				break;
			
			GradientView *gradientView = [[self.gradientViewNib instantiateWithOwner:nil options:nil] lastObject];
			gradientView.destinationX = x * FrameWidth - OffsetX;
			gradientView.destinationY = y * FrameHeight - OffsetY;
			
			TweetResult *result = [self.results objectAtIndex:y * NumFramesX + x];
			
			totalScore += result.sentimentScore.floatValue;
			

			
			//NSLog(@"tweet score=%f, gradientIndex=%d", result.sentimentScore.floatValue, gradientIndex);
			

			
			CGRect frame = gradientView.frame;
			frame.origin.x = [self randomizeX:gradientView.destinationX];
			frame.origin.y = [self randomizeY:gradientView.destinationY];
			gradientView.frame = frame;
			
			[self.gradientViews addObject:gradientView];
		}
		
		CGFloat averageScore = totalScore / NumFramesX;
		NSInteger gradientIndex = 10;
		if (averageScore > 0) {
			CGFloat ratio = averageScore / bestResult.sentimentScore.floatValue;
			gradientIndex -= 10 * ratio;
		}
		else {
			CGFloat ratio = averageScore / worstResult.sentimentScore.floatValue;
			gradientIndex += 9 * ratio;
		}
		
		for (NSInteger x = 0; x < NumFramesX; x++) {
			if (y * NumFramesX + x >= self.results.count)
				break;
			
			GradientView *gradientView = [self.gradientViews objectAtIndex:y * NumFramesX + x];
			gradientView.overlayView.backgroundColor = [self colorFromHex:[self.gradientColors objectAtIndex:gradientIndex]];
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

- (void)touchEvent:(NSSet *)touches {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchEvent:touches];
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
	
	NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:ExplosionWidth * ExplosionHeight];
	
	for (int x = xIndex - ExplosionWidth / 2; x <= xIndex + ExplosionWidth / 2; x++) {
		for (int y = yIndex - ExplosionHeight / 2; y <= yIndex + ExplosionHeight / 2; y++) {
			if (x >= 0 && x < NumFramesX && y >= 0 && y < NumFramesY) {
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

- (UIColor *)colorFromHex:(NSString*)hexString {
	if (hexString == nil)
		return [UIColor blackColor];
	
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	unsigned hex;
	[scanner scanHexInt:&hex];
	
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0f];
}

@end
