//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Zhou Hao on 14-8-26.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesViewController ()

@end

@implementation TopPlacesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPlaces];
}

- (IBAction)fetchPlaces
{
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);      // fix refreshControl not show on iPhone
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    NSLog(@"start fetch: %@", url);
    
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch flickr", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        if (jsonResult) {
            NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
            NSLog(@"flickr result: %@", propertyListResults);
            
            NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                self.places = places;
            });
            
        } else {
            NSLog(@"error return: %@", jsonResult);
            
        }
    });
}

@end
