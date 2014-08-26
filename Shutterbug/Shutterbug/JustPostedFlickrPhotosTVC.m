//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Zhou Hao on 14-8-25.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

- (IBAction)fetchPhotos
{
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);      // fix refreshControl not show on iPhone
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    NSLog(@"start fetch: %@", url);
    
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch flickr", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        if (jsonResult) {
            NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
            NSLog(@"flickr result: %@", propertyListResults);
            
            NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                self.photos = photos;
            });
            
        } else {
            NSLog(@"error return: %@", jsonResult);
            
        }
    });
}

@end
