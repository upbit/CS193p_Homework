//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-7.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (nonatomic) int flipCount;

@property (strong, nonatomic) Deck *deck;

@end

@implementation CardGameViewController

- (Deck *)deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)cardTouchButton:(UIButton *)sender {
    if ([sender.currentTitle length])
    {
        UIImage* cardImage = [UIImage imageNamed:@"card_background"];
        [sender setBackgroundImage:cardImage forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
        self.flipCount++;
    }
    else
    {
        Card* card = [self.deck drawRandomCard];
        
        if (card) {
            UIImage* cardImage = [UIImage imageNamed:@"card_round"];
            [sender setBackgroundImage:cardImage forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%@", card.contents] forState:UIControlStateNormal];
            self.flipCount++;
        }
        
        NSLog(@"flipCount = %d, deck left %d cards", self.flipCount, self.deck.deckCount);
    }
}

@end
