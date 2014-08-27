//
//  RecentsViewController.m
//  TopPlaces
//
//  Created by Zhou Hao on 14-8-26.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "RecentsViewController.h"

@interface RecentsViewController ()

@end

@implementation RecentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tag = TVC_TAG_IGNORE_VIEW_HISTORY;
    
    [self fetchPhotos];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchPhotos];
}

- (IBAction)fetchPhotos
{
    [self.refreshControl endRefreshing];
    self.photos = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_RECENT_PHOTOS];
}

@end
