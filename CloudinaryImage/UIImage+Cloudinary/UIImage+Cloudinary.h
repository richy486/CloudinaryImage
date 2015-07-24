//
//  UIImage+Cloudinary.h
//  CloudinaryImage
//
//  Created by Richard Adem on 15/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const CloudinaryWidthAttributeName;
UIKIT_EXTERN NSString *const CloudinaryHeightAttributeName;
UIKIT_EXTERN NSString *const CloudinaryCropModeAttributeName;

typedef void (^CloudinaryCompletionBlock)(UIImage *image);

@interface UIImage (Cloudinary)

+ (UIImage*) imageWithCloudinaryUsername:(NSString*) username path:(NSString*) path complete:(CloudinaryCompletionBlock) complete;
+ (UIImage*) imageWithCloudinaryUsername:(NSString*) username path:(NSString*) path usingAttributes:(NSDictionary*) attributes withPlaceholderImage:(UIImage*) placeholderImage complete:(CloudinaryCompletionBlock) complete;

@end
