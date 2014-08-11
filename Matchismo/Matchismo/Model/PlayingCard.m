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
        PlayingCard *otherCard = [otherCards firstObject];
        
        if ((self.rank > 0) && (otherCard.rank > 0)) {
            if (self.rank == otherCard.rank) {
                score += 4;
            } else if ([self.suit isEqualToString:otherCard.suit]) {
                score += 1;
            }
        } else {
            // joker match any cards
            score += 4;
        }
        
    } else if ([otherCards count] == 2) {     // 3x model
        // sort cards by rank
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedCards = [@[self, [otherCards firstObject], [otherCards lastObject]] sortedArrayUsingDescriptors:sortDescriptors];
    
        /**
         *  这里要检查3张牌是否组成顺子
         *
         *  1. 检查排序后数组中joker的数量0-2
         *  2. 如果joker为0，检查high-low的差值，不是2则肯定不为顺子
         *     为2时，检查牌的两两差值是否为1，是则继续检查是否同花
         *  3. 如果joker为1，检查high-low差值是否为1或2，不是则不为顺子
         *  4. 如果joker为2，此时一定组成顺子
        **/
        BOOL isStraight = NO;
        
        // 1. 检查排序后数组中joker的数量0-2
        NSUInteger jokerCount = 0;
        for (PlayingCard *card in sortedCards) {
            if (card.rank == 0) {
                jokerCount++;
                continue;
            }
        }

        PlayingCard *lowCard = sortedCards[jokerCount];
        PlayingCard *midCard = sortedCards[(jokerCount+2)/2];
        PlayingCard *highCard = sortedCards[2];
        NSUInteger rankDiff = highCard.rank - lowCard.rank;
        
        if (jokerCount == 0) {
            // 2. 如果joker为0，检查high-low的差值，不是2则肯定不为顺子
            if (rankDiff == 2) {
                // 为2时，检查牌的两两差值是否为1
                if (((midCard.rank-lowCard.rank) == 1) && ((highCard.rank-midCard.rank) == 1))
                    isStraight = YES;
            }
        } else if (jokerCount == 1) {
            // 3. 如果Joker为1，检查high-low差值是否为1或2，不是则不为顺子
            if ((rankDiff == 1) || (rankDiff == 2))
                isStraight = YES;
        } else if (jokerCount == 2) {
            // 4. 如果Joker为2，此时一定组成顺子
            isStraight = YES;
        }
        
        if (isStraight) {
            if (([lowCard.suit isEqualToString:midCard.suit]) && ([lowCard.suit isEqualToString:highCard.suit])) {
                score += 16;    // straight flush
            } else {
                score += 6;     // straight
            }
        } else if ((lowCard.rank == midCard.rank) && (lowCard.rank == highCard.rank)) {
            score += 8;         // same rank
        } else if (([lowCard.suit isEqualToString:midCard.suit]) && ([lowCard.suit isEqualToString:highCard.suit])) {
            score += 2;         // same suit
        }
    }
    
    return score;
}

+ (NSArray *)validSuits
{
    return @[@"Joker", @"♠️", @"♥️", @"♣️", @"♦️"];
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
    return @[@"?", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"A"];
}

+ (NSUInteger)maxRank
{
    return [[self validRanks] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    if (![_suit isEqualToString:@"Joker"])
        return [NSString stringWithFormat:@"%@%@", _suit, [PlayingCard validRanks][_rank]];
    else
        return [NSString stringWithFormat:@"🎭"];
}

@end
