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
#import "CalloutView.h"

CGFloat const FrameWidth = 48.0f;
CGFloat const FrameHeight = 48.0f;

NSInteger const NumFramesX = 16;
NSInteger const NumFramesY = 20;

NSInteger const OffsetX = 0;
NSInteger const OffsetY = 0;

NSInteger const ExplosionWidth = 9;
NSInteger const ExplosionHeight = 5;

NSInteger const RandomX = 300;
NSInteger const RandomY = 300;

@interface ResultsViewController ()

@property (strong, nonatomic) TweetResult *bestResult;
@property (strong, nonatomic) TweetResult *worstResult;

@property (strong, nonatomic) NSMutableArray *gradientViews;
@property (strong, nonatomic) NSMutableArray *shuffledGradientViews;
@property (strong, nonatomic) NSArray *gradientColors;
@property (strong, nonatomic) NSArray *explodedViews;
@property (strong, nonatomic) UINib *gradientViewNib;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) CalloutView *calloutView;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self sortResultsBySentimentScore];
	
	[self initializeNibs];
	[self initializeGradientPalette];
	[self initializeGradientViews];
	[self initializeCallout];
	
	[self shuffleGradientViews];
	
	[NSTimer scheduledTimerWithTimeInterval:0.004f target:self selector:@selector(gradientAppearTimer:) userInfo:nil repeats:YES];
}

- (void)initializeGradientPalette {
	self.gradientColors = @[@"76EC23",
							@"87ED23",
							@"94ED23",
							@"A1EE23",
							@"AAEE23",
							@"ABEE23",
							@"B0ED21",
							@"BCEB1C",
							@"CFE813",
							@"EBE407",
							@"F9DF01",
							@"F1BA01",
							@"E99801",
							@"E48001",
							@"E07001",
							@"DE6301",
							@"DC5A01",
							@"DB5601",
							@"CE4D05",
							@"C44708"];
}

- (void)initializeCallout {
	UINib *nib = [UINib nibWithNibName:@"CalloutView" bundle:[NSBundle mainBundle]];
	self.calloutView = [[nib instantiateWithOwner:nil options:nil] lastObject];
	//self.calloutView.alpha = 0.0f;
	
	[self.view addSubview:self.calloutView];
}

- (void)initializeNibs {
	self.gradientViewNib = [UINib nibWithNibName:@"GradientView" bundle:[NSBundle mainBundle]];	
}

- (void)sortResultsBySentimentScore {
	self.results = [self.results sortedArrayUsingComparator:^NSComparisonResult(TweetResult *obj1, TweetResult *obj2) {
		if (obj1.sentimentScore.floatValue > obj2.sentimentScore.floatValue)
			return NSOrderedAscending;
		else
			return NSOrderedDescending;
	}];
	
	self.bestResult = [self.results objectAtIndex:0];
	self.worstResult = [self.results lastObject];
}

- (void)initializeGradientViews {
	self.gradientViews = [[NSMutableArray alloc] init];
	for (NSInteger y = 0; y < NumFramesY; y++) {
		for (NSInteger x = 0; x < NumFramesX; x++) {
			if (y * NumFramesX + x >= self.results.count)
				break;
			
			GradientView *gradientView = [[self.gradientViewNib instantiateWithOwner:nil options:nil] lastObject];
			gradientView.destinationX = x * FrameWidth - OffsetX;
			gradientView.destinationY = y * FrameHeight - OffsetY;
			//gradientView.transform = CGAffineTransformMakeScale(2, 2);
			
			TweetResult *result = [self.results objectAtIndex:y * NumFramesX + x];
			
			NSInteger gradientIndex = 10;
			if ([result.sentimentType isEqualToString:@"positive"]) {
				CGFloat ratio = result.sentimentScore.floatValue / self.bestResult.sentimentScore.floatValue;
				gradientIndex -= 10 * ratio;
			}
			else if ([result.sentimentType isEqualToString:@"negative"]) {
				CGFloat ratio = result.sentimentScore.floatValue / self.worstResult.sentimentScore.floatValue;
				gradientIndex += 9 * ratio;
			}
			
			gradientView.overlayView.backgroundColor = [self colorFromHex:[self.gradientColors objectAtIndex:gradientIndex]];
			
			CGRect frame = gradientView.frame;
			frame.origin.x = [self randomizeX:gradientView.destinationX];
			frame.origin.y = [self randomizeY:gradientView.destinationY];
			gradientView.frame = frame;
			
			[self.gradientViews addObject:gradientView];
		}
	}
}

- (void)gradientAppearTimer:(NSTimer *)timer {
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
	[UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
		CGRect frame = gradientView.frame;
		frame.origin.x = gradientView.destinationX;
		frame.origin.y = gradientView.destinationY;
		gradientView.frame = frame;
		gradientView.alpha = 1.0f;
		//gradientView.transform = CGAffineTransformMakeScale(1, 1);
	} completion:^(BOOL finished) {
		
	}];
}

- (void)shuffleGradientViews {
	self.shuffledGradientViews = [NSMutableArray arrayWithArray:self.gradientViews];
	for (NSUInteger i = 0; i < self.shuffledGradientViews.count; ++i) {
		NSInteger index = arc4random_uniform(self.shuffledGradientViews.count - i) + i;
		[self.shuffledGradientViews exchangeObjectAtIndex:i withObjectAtIndex:index];
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
	GradientView *gradientView = [self.gradientViews objectAtIndex:[self indexFromPoint:touchPoint]];
	
	NSArray *explosionViews = [self collectNearbyViewsFromPoint:touchPoint];
	
	
	for (GradientView *gradientView in explosionViews) {
		gradientView.profilePicture.hidden = YES;
		//if (![self.explodedViews containsObject:gradientView])
		//	[self explodeGradientView:gradientView];
	}
	
	for (GradientView *gradientView in self.explodedViews) {
		if (![explosionViews containsObject:gradientView]) {
			gradientView.profilePicture.hidden = NO;
		}
	}
	self.explodedViews = explosionViews;
	
	CGRect frame = self.calloutView.frame;
	frame.origin.x = gradientView.destinationX - self.calloutView.frame.size.width / 2 + FrameWidth / 2;
	frame.origin.y = gradientView.destinationY - self.calloutView.frame.size.height / 2 + FrameHeight / 2;
	
	NSLog(@"gradientview x = %d", gradientView.destinationX);
	
	self.calloutView.frame = frame;
	
	//[UIView animateWithDuration:1.0f animations:^{
	//	self.calloutView.alpha = 1.0f;
	//}];
	
	[self.view bringSubviewToFront:self.calloutView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchEvent:touches];
}

- (void)explodeGradientView:(GradientView *)gradientView {
	//[self.view bringSubviewToFront:gradientView];
	[UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
		CGRect frame = gradientView.frame;
		frame.origin.x = [self randomizeX:gradientView.destinationX];
		frame.origin.y = [self randomizeY:gradientView.destinationY];
		gradientView.frame = frame;
		gradientView.alpha = 0.4;
	} completion:^(BOOL finished) {
		
	}];
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
