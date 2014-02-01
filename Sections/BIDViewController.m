//
//  BIDViewController.m
//  Sections
//
//  Created by Usman Khan on 11/25/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#import "BIDViewController.h"
#import "NSDictionary+MutableDeepCopy.h"

@interface BIDViewController ()

@end

@implementation BIDViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;
@synthesize isSearching;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    //self.names = dict;
    self.allNames = dict;
    
    //NSArray *array = [[names allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //self.keys = array;
    
    [self resetSearch];
    [table reloadData];
    [table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view. // e.g. self.myOutlet = nil;
    self.table = nil;
    self.search = nil;
    self.allNames = nil;
    self.names = nil;
    self.keys = nil;
}

#pragma mark -

#pragma mark Custom Methods 

- (void)resetSearch
{
    self.names = [self.allNames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys)
    {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        
        for (NSString *name in array)
        {
            if ([name rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}


#pragma mark -

#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [keys count];
    return ([keys count] > 0) ? [keys count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return 0;
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionsTableIdentifier];
    }
    
    cell.textLabel.text = [nameSection objectAtIndex:row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;
    
    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching)
        return nil;
    return keys;
}

#pragma mark -

#pragma mark Table View Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    isSearching = NO;
    search.text = @"";
    [tableView reloadData];
    return indexPath;
}

#pragma mark -

#pragma mark Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else
        return index;
}

@end
