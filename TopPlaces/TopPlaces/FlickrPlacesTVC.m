//
//  FlickrPlacesTVC.m
//  TopPlaces
//
//  Created by Zhou Hao on 14-8-26.
//  Copyright (c) 2014年 Kastark. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "FlickrFetcher.h"
#import "PlaceDetailViewController.h"

@interface FlickrPlacesTVC ()
@property (strong, nonatomic) NSArray *sortedSectionTitles;
@property (strong, nonatomic) NSDictionary *sectionPlaces;
@end

@implementation FlickrPlacesTVC

- (NSArray *)sortedSectionTitles
{
    if (!_sortedSectionTitles) _sortedSectionTitles = [[NSArray alloc] init];
    return _sortedSectionTitles;
}

- (void)setSectionPlaces:(NSDictionary *)sectionPlaces
{
    _sectionPlaces = sectionPlaces;
    self.sortedSectionTitles = [self.sectionPlaces.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)makeSectionDictionaryWithPlacesArray:(NSArray *)places
{
    NSMutableDictionary *sectionPlaces = [[NSMutableDictionary alloc] init];
    for (NSDictionary *place in places) {
        NSString *sectionTitle = [[place valueForKey:FLICKR_PLACE_NAME] substringToIndex:1];
        
        NSMutableArray *sectionArray = [sectionPlaces objectForKey:sectionTitle];
        if (!sectionArray) {
            [sectionPlaces setValue:[[NSMutableArray alloc] init] forKey:sectionTitle];
            sectionArray = [sectionPlaces objectForKey:sectionTitle];
        }
        
        [sectionArray addObject:place];
    }
    
    // Sort each section array
    for (NSString *key in sectionPlaces.allKeys) {
        NSMutableArray *sortedArray = [[[sectionPlaces objectForKey:key] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *title1 = [obj1 valueForKey:FLICKR_PLACE_NAME];
            NSString *title2 = [obj2 valueForKey:FLICKR_PLACE_NAME];
            return [title1 compare:title2];
        }] mutableCopy];
        [sectionPlaces setValue:sortedArray forKey:key];
    }

    self.sectionPlaces = sectionPlaces;
}

- (void)setPlaces:(NSArray *)places
{
    _places = places;
    [self makeSectionDictionaryWithPlacesArray:places];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sortedSectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sortedSectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sortedSectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sectionPlaces valueForKey:[self.sortedSectionTitles objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *place = [self.sectionPlaces[self.sortedSectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
    NSArray *locality = [[place valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    cell.textLabel.text = [locality firstObject];
    cell.detailTextLabel.text = [locality componentsJoinedByString:@", "];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[PlaceDetailViewController class]]) {
        // only on iPad
        NSDictionary *place = [self.sectionPlaces[self.sortedSectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
        [self preparePlaceDetailViewController:detail toDisplayPhoto:place];
    }
}

#pragma mark - Navigation

static const int MAX_PHOTO_PER_PAGE = 50;     // maximum 500

- (void)preparePlaceDetailViewController:(PlaceDetailViewController *)pdvc toDisplayPhoto:(NSDictionary *)place
{
    pdvc.placeURL = [FlickrFetcher URLforPhotosInPlace:[place valueForKey:FLICKR_PLACE_ID] maxResults:MAX_PHOTO_PER_PAGE];
    pdvc.title = [[[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] firstObject];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if (([segue.identifier isEqualToString:@"ShowPlaceDetail"]) && ([segue.destinationViewController isKindOfClass:[PlaceDetailViewController class]])) {
                NSDictionary *place = [self.sectionPlaces[self.sortedSectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
                [self preparePlaceDetailViewController:segue.destinationViewController toDisplayPhoto:place];
            }
        }
    }
}

@end
