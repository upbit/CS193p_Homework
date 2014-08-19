//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-18.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetPlayingCardDeck.h"

@interface SetGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    self.chosenCardCount = 3;
    self.gameResult.gameType = GAMETYPE_SET;
    return [[SetPlayingCardDeck alloc] init];
}

- (NSAttributedString *)attributedTitleForCard:(Card *)card;
{
    // In 'Set' game, always draw card symbol
    
    NSString *symbol = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[SetPlayingCard class]]) {
        SetPlayingCard *setCard = (SetPlayingCard *)card;
        
        if ([setCard.symbol isEqualToString:@"oval"]) symbol = @"●";
        if ([setCard.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        if ([setCard.symbol isEqualToString:@"diamond"]) symbol = @"■";
        
        symbol = [symbol stringByPaddingToLength:setCard.number withString:symbol startingAtIndex:0];

        if ([setCard.color isEqualToString:@"red"]) {
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        } else if ([setCard.color isEqualToString:@"green"]) {
            [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        } else if ([setCard.color isEqualToString:@"purple"]) {
            [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
        }
        
        if ([setCard.shading isEqualToString:@"open"]) {
            [attributes setObject:@8 forKey:NSStrokeWidthAttributeName];
        } else if ([setCard.shading isEqualToString:@"striped"]) {
            [attributes addEntriesFromDictionary:@{ NSStrokeWidthAttributeName : @-8,
                                                    NSStrokeColorAttributeName : [UIColor blackColor],
                                                    NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.6]}];
        } else { // solid
            // pass
        }
    }
    
    return [[NSMutableAttributedString alloc] initWithString:symbol attributes:attributes];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"setcard_selected" : @"setcard_round"];
}

// override
- (void)updateUI
{
    [super updateUI];
    
    // update infoLabel
    NSMutableAttributedString *matchInfo = [[NSMutableAttributedString alloc] init];
    for (Card *card in self.game.lastChosenCards) {
        [matchInfo appendAttributedString:[self attributedTitleForCard:card]];
        [matchInfo appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    if (self.game.lastScore > 0) {
        [matchInfo appendAttributedString:[[NSAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@"matched for %d points.", self.game.lastScore]]];
    } else if (self.game.lastScore < 0) {
        [matchInfo appendAttributedString:[[NSAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@"don’t match! %d point penalty!", self.game.lastScore]]];
    }
    self.infoLabel.attributedText = matchInfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

@end
