//
//  ViewController.m
//  CloudinaryImage
//
//  Created by Richard Adem on 15/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Cloudinary.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    
    self.imageView.image = [UIImage imageWithCloudinaryUsername:@"demo"
                                                           path:@"image/upload/sample.jpg"
                                                usingAttributes:@{CloudinaryWidthAttributeName: @(100)
                                                                  , CloudinaryHeightAttributeName: @(100)
                                                                  , CloudinaryCropModeAttributeName: @"fill"}
                                           withPlaceholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                                                       complete:^(UIImage *image) {
                                                           if (image) {
                                                               self.imageView.image = image;
                                                           }
                                                           [self.activityIndicator stopAnimating];
                                                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
