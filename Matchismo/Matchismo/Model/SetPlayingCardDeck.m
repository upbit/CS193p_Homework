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
        for (UIColor *color in [SetPlayingCard validColor]) {
            for (NSString *shading in [SetPlayingCard validShading]) {
                for (NSString *symbol in [SetPlayingCard validSymbol]) {
                    for (NSUInteger rank = 1; rank <= [SetPlayingCard maxRank]; rank++) {
                        SetPlayingCard * card = [[SetPlayingCard alloc] init];
                        card.rank = rank;
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
