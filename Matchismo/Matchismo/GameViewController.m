//
//  GameViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-18.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "GameViewController.h"
#import "HistoryViewController.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (strong, nonatomic) NSMutableAttributedString *matchHistory;

@end

@implementation GameViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hisvc = segue.destinationViewController;
            hisvc.matchHistory = self.matchHistory;
        }
    }
}

- (Deck *)createDeck
{
    self.chosenCardCount = 0;
    return nil;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (NSMutableAttributedString *)matchHistory
{
    if (!_matchHistory) _matchHistory = [[NSMutableAttributedString alloc] init];
    return _matchHistory;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.infoLabel.attributedText = self.matchInfo;
}

- (NSAttributedString *)attributedTitleForCard:(Card *)card
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.chosen ? card.contents : @""];
    return title;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"card_round" : @"card_background"];
}

- (IBAction)cardTouchButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    BOOL matched = [self.game chooseCardAtIndex:chosenButtonIndex matchCount:self.chosenCardCount];
    [self updateUI];
    
    if (matched) {
        [self.matchHistory appendAttributedString:self.infoLabel.attributedText];
        [self.matchHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
}

- (IBAction)resetGame:(UIBarButtonItem *)sender {
    self.game = nil;
    self.matchHistory = nil;
    [self updateUI];
}

@end
