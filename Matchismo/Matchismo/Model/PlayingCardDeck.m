//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-7.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *suit in [PlayingCard validSuits]) {
            if (![suit isEqualToString:@"Joker"]) {
                //for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                for (NSUInteger rank = 7; rank <= [PlayingCard maxRank]; rank++) {      // easy for playing
                    PlayingCard *card = [[PlayingCard alloc] init];
                    card.suit = suit;
                    card.rank = rank;
                    [self addCard:card];
                }
            } else {    // add 2 Joke
                for (int i = 0; i < 2; i++) {
                    PlayingCard *card = [[PlayingCard alloc] init];
                    card.suit = suit;
                    card.rank = 0;
                    [self addCard:card];
                }
            }
        }
    }
    
    return self;
}

@end
