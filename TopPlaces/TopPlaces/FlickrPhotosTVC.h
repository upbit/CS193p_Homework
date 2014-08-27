//
//  FlickrPhotosTVC.h
//  Shutterbug
//
//  Created by Zhou Hao on 14-8-25.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TVC_TAG_IGNORE_VIEW_HISTORY (1001)      // Mark for RecentsViewController
#define KEY_RECENT_PHOTOS @"recents"

@interface FlickrPhotosTVC : UITableViewController
@property (strong, nonatomic) NSArray *photos;  // for Flicker of NSDictionary
@end
