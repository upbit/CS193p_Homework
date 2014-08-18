//
//  Card.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-7.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (NSInteger)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card* card in otherCards) {
        if ([card.contents isEqualToString:self.contents])
            score += 1;
    }
    
    return score;
}

@end
