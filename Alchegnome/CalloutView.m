//
//  CalloutView.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import "CalloutView.h"

@implementation CalloutView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	UIColor *textColor = [self colorFromHex:@"3a3a3a"];
	
	self.tweetLabel.textColor = textColor;
	self.nameLabel.textColor = textColor;
	self.twitterHandleLabel.textColor = textColor;
	self.timeLabel.textColor = textColor;
	self.locationLabel.textColor = textColor;
	self.retweetsLabel.textColor = textColor;
	self.favoritesLabel.textColor = textColor;
	self.retweetsMarker.textColor = textColor;
	self.favoritesMarker.textColor = textColor;
	
	self.tweetLabel.font = [UIFont fontWithName:@"Klinic Slab 2" size:self.tweetLabel.font.pointSize];
	self.nameLabel.font = [UIFont fontWithName:@"Klinic Slab 2" size:self.nameLabel.font.pointSize];
	self.twitterHandleLabel.font = [UIFont fontWithName:@"Klinic Slab" size:self.twitterHandleLabel.font.pointSize];
	self.timeLabel.font = [UIFont fontWithName:@"Klinic Slab" size:self.timeLabel.font.pointSize];
	self.locationLabel.font = [UIFont fontWithName:@"Klinic Slab" size:self.locationLabel.font.pointSize];
	self.retweetsLabel.font = [UIFont fontWithName:@"Klinic Slab 2" size:self.retweetsLabel.font.pointSize];
	self.favoritesLabel.font = [UIFont fontWithName:@"Klinic Slab 2" size:self.favoritesLabel.font.pointSize];
	self.retweetsMarker.font = [UIFont fontWithName:@"Klinic Slab" size:self.retweetsMarker.font.pointSize];
	self.favoritesMarker.font = [UIFont fontWithName:@"Klinic Slab" size:self.favoritesMarker.font.pointSize];
	self.kloutLabel.font = [UIFont fontWithName:@"DIN-Bold" size:self.kloutLabel.font.pointSize];
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
