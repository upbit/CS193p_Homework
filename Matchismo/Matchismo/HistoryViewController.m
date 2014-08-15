//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Zhou Hao on 14-8-15.
//  Copyright (c) 2014年 zzz, kastark. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.historyTextView setAttributedText:self.matchHistory];
}

@end
