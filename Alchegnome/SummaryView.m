//
//  SummaryView.m
//  Alchegnome
//
//  Created by Joel Angelone on 6/16/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import "SummaryView.h"

@implementation SummaryView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.phraseLabel.font = [UIFont fontWithName:@"Klinic Slab 2" size:self.phraseLabel.font.pointSize];
	self.statsLabel.font = [UIFont fontWithName:@"Klinic Slab" size:self.statsLabel.font.pointSize];
}

@end
