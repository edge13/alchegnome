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
@property (strong, nonatomic) NSString *handle;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *retweetCount;
@property (strong, nonatomic) NSString *favoriteCount;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *sentimentType;
@property (strong, nonatomic) NSNumber *sentimentScore;
@property (strong, nonatomic) NSString *profileImageUrl;

@end
