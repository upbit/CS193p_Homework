//
//  GameSettingViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-19.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "GameSettingViewController.h"
#import "GameRanking.h"

@interface GameSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *settingInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation GameSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:RANKING_KEY_USERNAME];
    if (!userName) userName = @"Player";
    self.userNameTextField.text = userName;
    self.settingInfoLabel.text = @"";
}

- (IBAction)resetRankingButton:(UIButton *)sender {
    [GameRanking resetRanking:GAMETYPE_SET];
    [GameRanking resetRanking:GAMETYPE_MATCH];
    self.settingInfoLabel.text = @"Ranking RESET complete.";
}

- (IBAction)textFieldDoneEditing:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)editedUserNameTextField:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:RANKING_KEY_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.settingInfoLabel.text = [NSString stringWithFormat:@"Change name to '%@' complete.", sender.text];
}

@end
