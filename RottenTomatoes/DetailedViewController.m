//
//  DetailedViewController.m
//  RottenTomatoes
//
//  Created by Vikas Kumar Bajaj on 9/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "DetailedViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailedViewController ()

@end

@implementation DetailedViewController

- (id)initWithData: (NSDictionary *) data
{
    self = [super init];
    if (self) {
        self.movieData = data;
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.synopsisLabel sizeThatFits:CGSizeMake(320.0f, 610.0f)];

    //self.scrollView.contentSize = self.contentView.bounds.size;
    //self.contentView.frame.size;
    
    self.scrollView.contentSize = CGSizeMake(320.0f, 610.0f);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"Logging started");
    

    //Add image.
    NSString *detailedPosterURL = [self.movieData valueForKeyPath:@"posters.detailed"];
    NSString *hiDefURL = [detailedPosterURL stringByReplacingOccurrencesOfString:@"tmb" withString:@"org"];
    [self.deailedPosterView setImageWithURL:[NSURL URLWithString:hiDefURL]];

    
    self.synopsisLabel.textColor = [UIColor lightGrayColor];
    self.synopsisLabel.text = self.movieData[@"synopsis"];
    
    //[self.synopsisLabel sizeToFit];
    
    //self.scrollView.contentSize = self.contentView.bounds.size;
    
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    
    //[self.contentView addSubview:self.synopsisLabel];
    [self.contentView setBackgroundColor:[UIColor clearColor]];

    //[self.scrollView addSubview:self.contentView];
    
    [self.scrollView setScrollEnabled:YES];
    
   // self.synopsisLabel.text = self.movieData[@"synopsis"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
