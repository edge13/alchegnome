//
//  FilterView.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/16/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

- (IBAction)close:(id)sender {
	[self.delegate closeFilter];
}

- (IBAction)onAllApis:(id)sender {
	self.allApis.hidden = NO;
	self.twitter.hidden = YES;
	self.context.hidden = YES;
}

- (IBAction)onTwitter:(id)sender {
	self.allApis.hidden = YES;
	self.twitter.hidden = NO;
	self.context.hidden = YES;
}

- (IBAction)onContext:(id)sender {
	self.allApis.hidden = YES;
	self.twitter.hidden = YES;
	self.context.hidden = NO;
}

- (IBAction)onAllTime:(id)sender {
	self.allTime.hidden = NO;
	self.today.hidden = YES;
	self.yesterday.hidden = YES;
	self.pastWeek.hidden = YES;
	self.pastMonth.hidden = YES;
}

- (IBAction)onToday:(id)sender {
	self.allTime.hidden = YES;
	self.today.hidden = NO;
	self.yesterday.hidden = YES;
	self.pastWeek.hidden = YES;
	self.pastMonth.hidden = YES;
}

- (IBAction)onYesterday:(id)sender {
	self.allTime.hidden = YES;
	self.today.hidden = YES;
	self.yesterday.hidden = NO;
	self.pastWeek.hidden = YES;
	self.pastMonth.hidden = YES;
}

- (IBAction)onPastWeek:(id)sender {
	self.allTime.hidden = YES;
	self.today.hidden = YES;
	self.yesterday.hidden = YES;
	self.pastWeek.hidden = NO;
	self.pastMonth.hidden = YES;
}

- (IBAction)onPastMonth:(id)sender {
	self.allTime.hidden = YES;
	self.today.hidden = YES;
	self.yesterday.hidden = YES;
	self.pastWeek.hidden = YES;
	self.pastMonth.hidden = NO;
}

@end
