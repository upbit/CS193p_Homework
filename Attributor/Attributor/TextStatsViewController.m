//
//  TextStatsViewController.m
//  Attributor
//
//  Created by Zhou Hao on 14-8-13.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "TextStatsViewController.h"

@interface TextStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorfulCharacterLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharacterLabel;

@end

@implementation TextStatsViewController

- (void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (NSAttributedString *)charactersWithAttributed:(NSString *)attributedName
{
    NSMutableAttributedString *characters = [[NSMutableAttributedString alloc] init];
    
    int index = 0;
    while (index < [self.textToAnalyze length]) {
        NSRange range;
        id value = [self.textToAnalyze attribute:attributedName atIndex:index effectiveRange:&range];
        if (value) {
            [characters appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        } else {
            index++;
        }
    }
    
    return characters;
}

- (void)updateUI
{
    self.colorfulCharacterLabel.text = [NSString stringWithFormat:@"%d colorful characters", [[self charactersWithAttributed:NSForegroundColorAttributeName] length]];
    self.outlinedCharacterLabel.text = [NSString stringWithFormat:@"%d outlined characters", [[self charactersWithAttributed:NSStrokeWidthAttributeName] length]];
}

@end
