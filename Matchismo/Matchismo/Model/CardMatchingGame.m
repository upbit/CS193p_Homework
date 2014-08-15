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
@property (strong, nonatomic, readwrite) NSAttributedString *matchInfo;
@property (strong, nonatomic, readwrite) NSMutableAttributedString *matchHistory;

@property (strong, nonatomic) NSMutableArray *cards;    // of Card
@end

@implementation CardMatchingGame

- (NSMutableAttributedString *)matchHistory
{
    if (!_matchHistory) _matchHistory = [[NSMutableAttributedString alloc] init];
    return _matchHistory;
}

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

- (NSAttributedString *)makeMatchInfo:(Card *)card otherCards:(NSMutableArray *)otherCards score:(NSInteger)score
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    // add attributed card contents
    for (Card *otherCard in otherCards)
        [result appendAttributedString:otherCard.contents];
    [result appendAttributedString:card.contents];
    
    if (score > 0) {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@"matched for %d points.", score]]];
    } else {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@"don’t match! %d point penalty!", score]]];
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
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    self.matchInfo = [self makeMatchInfo:card otherCards:matchCards score:matchScore*MATCH_BONUS];
                    
                    card.matched = YES;
                    for (Card *otherCard in matchCards)
                        otherCard.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    self.matchInfo = [self makeMatchInfo:card otherCards:matchCards score:-MISMATCH_PENALTY];
                    
                    card.chosen = NO;
                    for (Card *otherCard in matchCards)
                        otherCard.chosen = NO;
                }
                
                // log match history
                [self.matchHistory appendAttributedString:self.matchInfo];
                [self.matchHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
}

@end
