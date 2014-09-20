//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Vikas Kumar Bajaj on 9/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailedViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) UIRefreshControl *uiRefreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeNone];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 105;
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    self.uiRefreshControl = [[UIRefreshControl alloc] init];
    self.uiRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.uiRefreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview: self.uiRefreshControl];
    
    //Search bar
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    
    [NSURLConnection sendAsynchronousRequest:request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.movies = object[@"movies"];
        
        [SVProgressHUD dismiss];
        
        self.searchResult = [NSMutableArray arrayWithCapacity:[self.movies count]];

        [self.tableView reloadData];
    }];
}

- (void)filterContentForSearchText:(NSString*)searchText scope: (NSString* )scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    self.searchResult = [NSMutableArray arrayWithArray: [self.movies filteredArrayUsingPredicate:resultPredicate]];
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                                        selectedScopeButtonIndex]]];
    
//    /[self.searchDisplayController.searchResultsTableView reloadData];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResult.count;
    } else {
        return self.movies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MovieCell";
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    NSDictionary *movie;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"Returning cells for index %ld with movie title %@", (long)indexPath.row, self.searchResult[indexPath.row][@"title"]);
        if (self.searchResult.count > indexPath.row) {
            movie = self.searchResult[indexPath.row];
        }
    } else {
        movie = self.movies[indexPath.row];
    }
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *posterURL = [movie valueForKeyPath:@"posters.thumbnail"];
    
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURL]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    NSDictionary *selectedMovie;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedMovie = self.searchResult[indexPath.row];
    } else {
        selectedMovie = self.movies[indexPath.row];
    }
    
    DetailedViewController *dvc = [[DetailedViewController alloc] initWithData:selectedMovie];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)refreshTable
{
    NSLog(@"In refresh table");
}

@end
