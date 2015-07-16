# CloudinaryImage
Simple download and cache UIImage category for using Cloudinary

Usage:

    CGFloat deviceScale = [[UIScreen mainScreen] scale];
    
    self.imageView.image = [UIImage imageWithCloudinaryUsername:@"demo"
                                                           path:@"image/upload/sample.jpg"
                                                usingAttributes:@{CloudinaryWidthAttributeName: @(100 * deviceScale)
                                                                  , CloudinaryHeightAttributeName: @(100 * deviceScale)}
                                           withPlaceholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                                                       complete:^(UIImage *image) {
                                                           if (image) {
                                                               self.imageView.image = image;
                                                           }
                                                           [self.activityIndicator stopAnimating];
                                                       }];

CloudinaryCompletionBlock image will be nil if cached image is found that matcheslast path.
