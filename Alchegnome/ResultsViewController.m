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

CGFloat const FrameWidth = 32;
CGFloat const FrameHeight = 32;

NSInteger const NumFramesX = 10;
NSInteger const NumFramesY = 16;

NSInteger const RandomX = 200;
NSInteger const RandomY = 200;

@interface ResultsViewController ()

@property (strong, nonatomic) NSMutableArray *gradientViews;
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
			gradientView.destinationX = x * FrameWidth;
			gradientView.destinationY = y * FrameHeight;
			
			CGRect frame = gradientView.frame;
			frame.origin.x = [self randomizeX:gradientView.destinationX];
			frame.origin.y = [self randomizeY:gradientView.destinationY];
			gradientView.frame = frame;
			
			[self.gradientViews addObject:gradientView];
		}
	}
	
	[self shuffleArray:self.gradientViews];
	
	[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(addGradient:) userInfo:nil repeats:YES];
}

- (void)addGradient:(NSTimer *)timer {
	if (self.currentIndex >= self.gradientViews.count) {
		[timer invalidate];
	}
	else {
		GradientView *gradientView = [self.gradientViews objectAtIndex:self.currentIndex++];
		[self.view addSubview:gradientView];
		
		[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
			CGRect frame = gradientView.frame;
			frame.origin.x = gradientView.destinationX - 16;
			frame.origin.y = gradientView.destinationY - 16;
			gradientView.frame = frame;
			
			//gradientView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
			
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

@end
