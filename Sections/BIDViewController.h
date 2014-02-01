//
//  BIDViewController.h
//  Sections
//
//  Created by Usman Khan on 11/25/12.
//  Copyright (c) 2012 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

//@property (strong, nonatomic) NSDictionary *names;
//@property (strong, nonatomic) NSArray *keys;

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) NSDictionary *allNames;
@property (strong, nonatomic) NSMutableDictionary *names;
@property (strong, nonatomic) NSMutableArray *keys;
@property (assign, nonatomic) BOOL isSearching;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
