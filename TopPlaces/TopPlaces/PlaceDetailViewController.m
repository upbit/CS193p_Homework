//
//  PlaceDetailViewController.m
//  TopPlaces
//
//  Created by Zhou Hao on 14-8-26.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "FlickrFetcher.h"

@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startFetchPlaceImages];
}

- (IBAction)startFetchPlaceImages
{
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);      // fix refreshControl not show on iPhone
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch flickr", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:self.placeURL];
        if (jsonResult) {
            NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
            NSLog(@"flickr result: %@", propertyListResults);
            
            NSArray *photo = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                self.photos = photo;
            });
            
        } else {
            NSLog(@"error return: %@", jsonResult);
            
        }
    });
}

@end
