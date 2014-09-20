//
//  DVDsViewController.m
//  RottenTomatoes
//
//  Created by Vikas Kumar Bajaj on 9/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "DVDsViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailedViewController.h"
#import "SVProgressHUD.h"

@interface DVDsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dvds;

@end

@implementation DVDsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"DVDs";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"Loading DVDs" maskType:SVProgressHUDMaskTypeNone];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 105;
    [self.searchDisplayController.searchResultsTableView setRowHeight:105.0f];
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.dvds = object[@"movies"];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dvds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MovieCell";
    
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSDictionary *movie = self.dvds[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *posterURL = [movie valueForKeyPath:@"posters.thumbnail"];
    
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURL]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *selectedMovie = self.dvds[indexPath.row];
    
    DetailedViewController *dvc = [[DetailedViewController alloc] initWithData:selectedMovie];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
