//
//  UIImage+Cloudinary.h
//  CloudinaryImage
//
//  Created by Richard Adem on 15/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CloudinaryCompletionBlock)(UIImage *image);

@interface UIImage (Cloudinary)

+ (UIImage*) imageWithCloudinaryUsername:(NSString*) username path:(NSString*) path withPlaceholderImage:(UIImage*) placeholderImage complete:(CloudinaryCompletionBlock) complete;

@end
