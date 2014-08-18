//
//  SetPlayingCard.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-14.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "SetPlayingCard.h"

@implementation SetPlayingCard

@synthesize symbol = _symbol;
@synthesize shading = _shading;

- (BOOL)matchSetCardsWithKey:(SetPlayingCard *)card1 card2:(SetPlayingCard *)card2 card3:(SetPlayingCard *)card3 key:(NSString *)key isString:(BOOL)isString
{
    BOOL match = NO;
    
    id value1 = [card1 valueForKey:key];
    id value2 = [card2 valueForKey:key];
    id value3 = [card3 valueForKey:key];
    
    if (!isString) {
        if ((value1 == value2) && (value2 == value3)) {
            match = YES;
            NSLog(@"3 card has same '%@'", key);
        } else if ((value1 != value2) && (value2 != value3) && (value3 != value1)) {
            match = YES;
            NSLog(@"3 card has different '%@'", key);
        }
    } else {
        if (([value1 isEqualToString:value2]) && ([value2 isEqualToString:value3])) {
            match = YES;
            NSLog(@"3 card has same '%@'", key);
        } else if ((![value1 isEqualToString:value2]) && (![value2 isEqualToString:value3]) && (![value3 isEqualToString:value1])) {
            match = YES;
            NSLog(@"3 card has different '%@'", key);
        }
    }
    
    return match;
}

// override
- (NSInteger)match:(NSArray *)otherCards
{
    int score = 0;

    if ([otherCards count] == 2) {     // 3x model
        id card1 = [otherCards firstObject];
        id card2 = [otherCards lastObject];
        if (([card1 isKindOfClass:[SetPlayingCard class]]) && ([card2 isKindOfClass:[SetPlayingCard class]])) {
            SetPlayingCard *otherCard1 = (SetPlayingCard *)card1;
            SetPlayingCard *otherCard2 = (SetPlayingCard *)card2;
            
            // They all have the same number, or they have three different numbers
            if ([self matchSetCardsWithKey:self card2:otherCard1 card3:otherCard2 key:@"number" isString:NO]) {
                // They all have the same symbol, or they have three different symbols
                if ([self matchSetCardsWithKey:self card2:otherCard1 card3:otherCard2 key:@"symbol" isString:YES]) {
                    // They all have the same shading, or they have three different shadings
                    if ([self matchSetCardsWithKey:self card2:otherCard1 card3:otherCard2 key:@"shading" isString:YES]) {
                        // They all have the same color, or they have three different colors
                        if ([self matchSetCardsWithKey:self card2:otherCard1 card3:otherCard2 key:@"color" isString:YES]) {
                            score = 4;
                        }
                    }
                }
            }
        }
    }
    
    return score;
}

+ (NSUInteger)maxRank
{
    return 3;
}
+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}
+ (NSArray *)validSymbols
{
    return @[@"oval", @"squiggle", @"diamond"];
}
+ (NSArray *)validShadings
{
    return @[@"solid", @"open", @"striped"];
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@:%@:%@:%d", self.symbol, self.color, self.shading, self.number];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetPlayingCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}
- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

- (void)setShading:(NSString *)shading
{
    if ([[SetPlayingCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}
- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

-(NSString *)color
{
    return _color ? _color : @"?";
}

@end
