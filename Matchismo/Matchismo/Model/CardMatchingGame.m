//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-11.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (strong, nonatomic, readwrite) NSArray *lastChosenCards;   // of Card

@property (strong, nonatomic) NSMutableArray *cards;    // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (BOOL)chooseCardAtIndex:(NSUInteger)index matchCount:(NSUInteger)count
{
    BOOL needMatch = NO;
    
    if (count == 0)
        return needMatch;
    
    Card *card = [self cardAtIndex:index];
    NSMutableArray *matchCards = [[NSMutableArray alloc] init];

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            for (Card *otherCard in self.cards) {
                if ((otherCard.isChosen) && (!otherCard.isMatched)) {
                    [matchCards addObject:otherCard];
                    
                    if ([matchCards count]+1 >= count) {
                        needMatch = YES;
                        break;
                    }
                }
            }
            
            if (needMatch) {
                NSInteger score = [card match:matchCards];
                self.lastChosenCards = [matchCards arrayByAddingObject:card];
                
                if (score) {
                    self.score += score * MATCH_BONUS;
                    self.lastScore = score * MATCH_BONUS;
                    
                    for (Card *matchCard in self.lastChosenCards)
                        matchCard.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    self.lastScore = (-MISMATCH_PENALTY);
                    
                    for (Card *matchCard in self.lastChosenCards)
                        matchCard.chosen = NO;
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
    return needMatch;
}

@end
