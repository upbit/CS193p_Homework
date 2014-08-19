//
//  GameRanking.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-19.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "GameRanking.h"

@implementation GameRanking

+ (NSArray *)sortRankingByKeyAndOrder:(NSArray *)ranking rankingName:(NSString *)rankingName
{
    NSString *keySorted = @"";
    BOOL ascending = NO;
    
    if ([rankingName isEqualToString:RANK_LAST_PLAYED]) {
        keySorted = @"date";
    } else if ([rankingName isEqualToString:RANK_GAME_SCORE]) {
        keySorted = @"score";
    } else if ([rankingName isEqualToString:RANK_GAME_DURATION]) {
        keySorted = @"duration";
        ascending = YES;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keySorted ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [ranking sortedArrayUsingDescriptors:sortDescriptors];
}

+ (void)storageOneGameResult:(GameResult *)gameResult rankingName:(NSString *)rankingName
{
    // get GameRanking from NSUserDefaults
    NSString *keyRanking = [NSString stringWithFormat:@"%@_%@", gameResult.gameType, rankingName];
    NSArray *rawRanking = [[NSUserDefaults standardUserDefaults] objectForKey:keyRanking];
    
    // decode Ranking
    NSMutableArray *ranking = [[NSMutableArray alloc] init];
    if (rawRanking) {
        for (NSData *rawObject in rawRanking) {
            GameResult *record = (GameResult *)[NSKeyedUnarchiver unarchiveObjectWithData:rawObject];
            [ranking addObject:record];
        }
    }

    [ranking addObject:gameResult];
    
    // sort by key
    NSArray *sortedArray = [GameRanking sortRankingByKeyAndOrder:ranking rankingName:rankingName];
    NSArray *resultArray = [sortedArray subarrayWithRange:NSMakeRange(0, MIN([sortedArray count], RANKING_TOP_SIZE))];

    NSMutableArray *encodeArray = [[NSMutableArray alloc] init];
    for (GameResult *record in resultArray) {
        NSData *encodeObject = [NSKeyedArchiver archivedDataWithRootObject:record];
        [encodeArray addObject:encodeObject];
    }

    [[NSUserDefaults standardUserDefaults] setObject:encodeArray forKey:keyRanking];
}

+ (void)storageGameResultToRanking:(GameResult *)gameResult
{
    [GameRanking storageOneGameResult:gameResult rankingName:RANK_LAST_PLAYED];
    [GameRanking storageOneGameResult:gameResult rankingName:RANK_GAME_SCORE];
    [GameRanking storageOneGameResult:gameResult rankingName:RANK_GAME_DURATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getGlobalRawRankingByName:(NSString *)gameType rankingName:(NSString *)rankingName
{
    NSString *keyRanking = [NSString stringWithFormat:@"%@_%@", gameType, rankingName];
    NSArray *rawRanking = [[NSUserDefaults standardUserDefaults] objectForKey:keyRanking];
    
    // decode Ranking
    NSMutableArray *ranking = [[NSMutableArray alloc] init];
    if (rawRanking) {
        for (NSData *rawObject in rawRanking) {
            GameResult *record = (GameResult *)[NSKeyedUnarchiver unarchiveObjectWithData:rawObject];
            [ranking addObject:record];
        }
    }
    
    return ranking;
}

+ (NSArray *)getGlobalRankingByName:(NSString *)gameType rankingName:(NSString *)rankingName
{
    NSArray *ranking = [GameRanking getGlobalRawRankingByName:gameType rankingName:rankingName];
    
    if ([ranking count] > 0) {
        NSMutableArray *stringRanking = [[NSMutableArray alloc] init];
        for (NSObject *record in ranking) {
            // show GameResult.description
            [stringRanking addObject:record.description];
        }
        return stringRanking;
    }
    
    return @[[NSString stringWithFormat:@"Game '%@' has no record.", gameType]];
}

+ (void)resetRanking:(NSString *)gameType
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", gameType, RANK_LAST_PLAYED]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", gameType, RANK_GAME_SCORE]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", gameType, RANK_GAME_DURATION]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
