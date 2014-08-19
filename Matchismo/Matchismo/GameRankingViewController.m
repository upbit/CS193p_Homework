//
//  GameRankingViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-19.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "GameRankingViewController.h"
#import "GameRanking.h"

@interface GameRankingViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rankingTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rankingTypeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegment;

@end

@implementation GameRankingViewController

- (void)updateRanking
{
    NSString *rankingName = @"";
    switch (self.rankingTypeSegment.selectedSegmentIndex) {
        case 0:
            rankingName = RANK_GAME_SCORE;
            break;
        case 1:
            rankingName = RANK_GAME_DURATION;
            break;
        case 2:
            rankingName = RANK_LAST_PLAYED;
            break;
    }
    
    NSString *gameType = @"";
    switch (self.gameTypeSegment.selectedSegmentIndex) {
        case 0:
            gameType = GAMETYPE_SET;
            break;
        case 1:
            gameType = GAMETYPE_MATCH;
            break;
    }
    
    
    NSString *rankingString = [[GameRanking getGlobalRankingByName:gameType rankingName:rankingName] componentsJoinedByString:@"\n"];
    // reset Attributes with NSString
    [self.rankingTextView setAttributedText:[[NSAttributedString alloc] initWithString:rankingString]];
    
    // try highlight shortest game / highest score in array
    NSArray *rawRankingArray = [GameRanking getGlobalRawRankingByName:gameType rankingName:rankingName];
    if ([rawRankingArray count] > 0) {
        NSMutableAttributedString *textViewAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.rankingTextView.textStorage];
        
        NSString *shortestGameLine = [[[GameRanking sortRankingByKeyAndOrder:rawRankingArray rankingName:RANK_GAME_DURATION] firstObject] description];
        [textViewAttributedText addAttributes:@{ NSStrokeWidthAttributeName : @-3,
                                                 NSStrokeColorAttributeName : [UIColor orangeColor] }
                                        range:[rankingString rangeOfString:shortestGameLine]];
        
        NSString *highestScoreLine = [[[GameRanking sortRankingByKeyAndOrder:rawRankingArray rankingName:RANK_GAME_SCORE] firstObject] description];
        [textViewAttributedText addAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }
                                        range:[rankingString rangeOfString:highestScoreLine]];
        
        [self.rankingTextView setAttributedText:textViewAttributedText];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateRanking];
}

- (IBAction)rankingSegmentChanged:(UISegmentedControl *)sender {
    [self updateRanking];
}

@end
