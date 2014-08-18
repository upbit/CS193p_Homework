//
//  PlayingCard.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-7.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

// override
- (NSInteger)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {          // 2x model
        id card = [otherCards firstObject];
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherCard = (PlayingCard *)card;
            if (self.rank == otherCard.rank) {
                score += 4;
            } else if ([self.suit isEqualToString:otherCard.suit]) {
                score += 1;
            }
        }
    } else if ([otherCards count] == 2) {     // 3x model
        id card1 = [otherCards firstObject];
        id card2 = [otherCards lastObject];
        if (([card1 isKindOfClass:[PlayingCard class]]) && ([card2 isKindOfClass:[PlayingCard class]])) {
            PlayingCard *otherCard1 = (PlayingCard *)card1;
            PlayingCard *otherCard2 = (PlayingCard *)card2;
            if ((self.rank == otherCard1.rank) && (self.rank == otherCard2.rank)) {
                score += 16;
            } else if (([self.suit isEqualToString:otherCard1.suit]) && ([self.suit isEqualToString:otherCard2.suit])) {
                score += 4;
            }
        }
    }
    
    return score;
}

+ (NSArray *)validSuits
{
    return @[@"♠️", @"♥️", @"♣️", @"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)validRanks
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self validRanks] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@%@ ", _suit, [PlayingCard validRanks][_rank]];
}

@end
