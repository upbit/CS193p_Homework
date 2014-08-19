//
//  GameViewController.h
//  Matchismo
//
//  Created by Zhou Hao on 14-8-18.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface GameViewController : UIViewController

@property (nonatomic) NSUInteger chosenCardCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSAttributedString *matchInfo;
@property (strong, nonatomic) GameResult *gameResult;

- (Deck *)createDeck;

- (NSAttributedString *)attributedTitleForCard:(Card *)card;
- (UIImage *)backgroundImageForCard:(Card *)card;
- (void)updateUI;

@end
