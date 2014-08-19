//
//  GameResult.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-19.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "GameResult.h"

#define NSCODER_NAME_USER       @"user"
#define NSCODER_NAME_DATE       @"date"
#define NSCODER_NAME_DURATION   @"duration"
#define NSCODER_NAME_SCORE      @"score"

@interface GameResult ()

@property (nonatomic, readwrite) NSDate *date;

@end

@implementation GameResult

- (NSString *)username
{
    return _username ? _username : @"Player";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.username = [[NSUserDefaults standardUserDefaults] objectForKey:RANKING_KEY_USERNAME];
        self.date = [NSDate date];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if(self) {
        self.username = [decoder decodeObjectForKey:NSCODER_NAME_USER];
        self.date = [decoder decodeObjectForKey:NSCODER_NAME_DATE];
        self.duration = [decoder decodeFloatForKey:NSCODER_NAME_DURATION];
        self.score = [decoder decodeIntForKey:NSCODER_NAME_SCORE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.username forKey:NSCODER_NAME_USER];
    [encoder encodeObject:self.date forKey:NSCODER_NAME_DATE];
    [encoder encodeDouble:self.duration forKey:NSCODER_NAME_DURATION];
    [encoder encodeInt:self.score forKey:NSCODER_NAME_SCORE];
}

- (void)setGameType:(NSString *)gameType
{
    if (([gameType isEqualToString:GAMETYPE_SET]) || ([gameType isEqualToString:GAMETYPE_MATCH])) {
        _gameType = gameType;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: score=%d, dur=%.1fs", self.username, self.score, self.duration];
}

@end
