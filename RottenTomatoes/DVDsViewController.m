//
//  DVDsViewController.m
//  RottenTomatoes
//
//  Created by Vikas Kumar Bajaj on 9/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "DVDsViewController.h"

@interface DVDsViewController ()

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
