//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-14.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetPlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface SetGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation SetGameViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hisvc = segue.destinationViewController;
            hisvc.matchHistory = self.game.matchHistory;
        }
    }
}

- (Deck *)createDeck
{
    return [[SetPlayingCardDeck alloc] init];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[self createDeck]];
    return _game;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
    }
    
    self.infoLabel.attributedText = self.game.matchInfo;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : [[NSAttributedString alloc] init];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"card_round" : @"card_background2"];
}

- (IBAction)cardTouchButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:chosenButtonIndex matchCount:3];
    [self updateUI];
}

- (IBAction)resetGame:(UIBarButtonItem *)sender {
    self.game = nil;
    [self updateUI];
}

@end
