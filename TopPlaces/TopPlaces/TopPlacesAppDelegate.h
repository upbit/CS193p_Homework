//
//  TopPlacesAppDelegate.h
//  TopPlaces
//
//  Created by Zhou Hao on 14-8-26.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TVC_TAG_IGNORE_VIEW_HISTORY (1001)      // Mark for RecentsViewController

@interface TopPlacesAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *recentPhotos;

@end
