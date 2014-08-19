//
//  GameRanking.h
//  Matchismo
//
//  Created by Zhou Hao on 14-8-19.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameResult.h"

#define RANKING_TOP_SIZE    (10)            // save topN GameResult

// Ranking type
#define RANK_LAST_PLAYED    @"newest"       // .date DESC
#define RANK_GAME_SCORE     @"score"        // .score DESC
#define RANK_GAME_DURATION  @"duration"     // .duration ASC

@interface GameRanking : NSObject

+ (NSArray *)sortRankingByKeyAndOrder:(NSArray *)ranking rankingName:(NSString *)rankingName;       // of GameResult (as ranking)
+ (void)storageGameResultToRanking:(GameResult *)gameResult;

+ (NSArray *)getGlobalRankingByName:(NSString *)gameType rankingName:(NSString *)rankingName;       // of NSString
+ (NSArray *)getGlobalRawRankingByName:(NSString *)gameType rankingName:(NSString *)rankingName;    // of GameResult

+ (void)resetRanking:(NSString *)gameType;

@end
