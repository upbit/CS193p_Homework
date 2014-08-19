//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Zhou Hao on 14-8-11.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (BOOL)chooseCardAtIndex:(NSUInteger)index matchCount:(NSUInteger)count;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int lastScore;
@property (strong, nonatomic, readonly) NSArray *lastChosenCards;   // of Card

@end
