//
//  TweetResult.h
//  Alchegnome
//
//  Created by Joel Angelone on 6/15/13.
//  Copyright (c) 2013 Sporting Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetResult : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *sentimentType;
@property (strong, nonatomic) NSNumber *sentimentScore;

@end
