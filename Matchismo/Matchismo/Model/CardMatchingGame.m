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
@property (nonatomic, readwrite) NSString *infoText;

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

- (NSString *)matchCardsToString:(NSMutableArray *)matchCards
{
    NSString *result = @"";
    for (Card *matchCard in matchCards) {
        result = [result stringByAppendingFormat:@"%@ ", matchCard.contents];
    }
    return result;
}

- (void)chooseCardAtIndex:(NSUInteger)index matchCount:(NSUInteger)count
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *matchCards = [[NSMutableArray alloc] init];
    BOOL needMatch = NO;
    
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
                NSInteger matchScore = [card match:matchCards];
                NSLog(@"match with cards: %@ %@, score = %d", card.contents, [self matchCardsToString:matchCards], matchScore);
                
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    self.infoText = [NSString stringWithFormat:@"Matched %@ %@ for %d points.", card.contents, [self matchCardsToString:matchCards], matchScore*MATCH_BONUS];
                    
                    card.matched = YES;
                    for (Card *otherCard in matchCards)
                        otherCard.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    self.infoText = [NSString stringWithFormat:@"%@ %@ don’t match! %d point penalty!", card.contents, [self matchCardsToString:matchCards], MISMATCH_PENALTY];
                    
                    card.chosen = NO;
                    for (Card *otherCard in matchCards)
                        otherCard.chosen = NO;
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
}

@end
