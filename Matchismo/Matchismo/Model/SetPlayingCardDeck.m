//
//  SetPlayingCardDeck.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-14.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "SetPlayingCardDeck.h"

@implementation SetPlayingCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *color in [SetPlayingCard validColors]) {
            for (NSString *shading in [SetPlayingCard validShadings]) {
                for (NSString *symbol in [SetPlayingCard validSymbols]) {
                    for (NSUInteger number = 1; number <= [SetPlayingCard maxRank]; number++) {
                        SetPlayingCard * card = [[SetPlayingCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
