//
//  GameResult.h
//  Matchismo
//
//  Created by Zhou Hao on 14-8-19.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAMETYPE_SET    @"set"
#define GAMETYPE_MATCH  @"match"

#define RANKING_KEY_USERNAME @"username"

@interface GameResult : NSObject

@property (strong, nonatomic) NSString *gameType;       // set or match

@property (strong, nonatomic) NSString *username;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

@end
