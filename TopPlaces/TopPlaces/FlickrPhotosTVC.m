//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Zhou Hao on 14-8-25.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if ([cell.textLabel.text length] == 0) {
        if ([cell.detailTextLabel.text length] == 0) {
            cell.textLabel.text = @"Unknown";
        } else {
            cell.textLabel.text = cell.detailTextLabel.text;
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        // only on iPad
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }
}

#pragma mark - Navigation

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    if ([[photo valueForKeyPath:FLICKR_PHOTO_TITLE] length] == 0) {
        if ([[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] length] == 0) {
            ivc.title = @"Unknown";
        } else {
            ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        }
    } else {
        ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    }
    
    [self addViewedPhotoToRecentsArray:photo];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if (([segue.identifier isEqualToString:@"ShowPhoto"]) && ([segue.destinationViewController isKindOfClass:[ImageViewController class]])) {
                [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
            }
        }
    }
}

#pragma mark - Recent Photos

static const int MAX_RECENT_PHOTO_NUM = 20;

- (void)addViewedPhotoToRecentsArray:(NSDictionary *)photo
{
    if (self.tableView.tag == TVC_TAG_IGNORE_VIEW_HISTORY)
        return;
    
    NSMutableArray *recents = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_RECENT_PHOTOS]];
    
    if (![recents containsObject:photo]) {
        NSLog(@"Add recent: '%@'", [photo valueForKeyPath:FLICKR_PHOTO_TITLE]);
        [recents insertObject:photo atIndex:0];
        
        NSArray *newRecents = [recents subarrayWithRange:NSMakeRange(0, MIN([recents count], MAX_RECENT_PHOTO_NUM))];
        [[NSUserDefaults standardUserDefaults] setObject:newRecents forKey:KEY_RECENT_PHOTOS];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
