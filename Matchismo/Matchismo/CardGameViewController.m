//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-18.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation CardGameViewController

- (Deck *)createDeck
{
    self.chosenCardCount = 2;
    return [[PlayingCardDeck alloc] init];
}

- (void)updateUI
{
    [super updateUI];
    
    // update infoLabel
    NSMutableArray *cardContents = [NSMutableArray array];
    for (Card *card in self.game.lastChosenCards) {
        [cardContents addObject:card.contents];
    }
    
    NSString *matchInfo = [cardContents componentsJoinedByString:@" "];
    if (self.game.lastScore > 0) {
        matchInfo = [NSString stringWithFormat:@"Matched %@ for %d points.", matchInfo, self.game.lastScore];
    } else if (self.game.lastScore < 0) {
        matchInfo = [NSString stringWithFormat:@"%@ don’t match! %d point penalty!", matchInfo, -self.game.lastScore];
    }
    
    self.infoLabel.text = matchInfo;
}

@end
