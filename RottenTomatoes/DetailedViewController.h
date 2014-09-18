//
//  DetailedViewController.h
//  RottenTomatoes
//
//  Created by Vikas Kumar Bajaj on 9/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *deailedPosterView;

@property (nonatomic) NSDictionary *movieData;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

-(id) initWithData: (NSDictionary*) data;

@end
