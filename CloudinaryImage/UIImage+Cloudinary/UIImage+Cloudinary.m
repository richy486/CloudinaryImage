//
//  UIImage+Cloudinary.m
//  CloudinaryImage
//
//  Created by Richard Adem on 15/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UIImage+Cloudinary.h"

static NSString *const CLOUDINARY_BASE_URL_STRING = @"http://res.cloudinary.com";
static NSString *const CLOUDINARY_STANDARD_DIRECTORY = @"/image/upload/";

@implementation UIImage (Cloudinary)

+ (UIImage*) imageWithCloudinaryUsername:(NSString*) username path:(NSString*) path withPlaceholderImage:(UIImage*) placeholderImage complete:(CloudinaryCompletionBlock) complete {
    
    NSString *filename = [path lastPathComponent];
    NSMutableString *imageUrlString = [[NSMutableString alloc] initWithString:CLOUDINARY_BASE_URL_STRING];
    [imageUrlString appendString:@"/"];
    [imageUrlString appendString:username];
    
    if (path.pathComponents.count > 2) {
        if (![[path substringToIndex:1] isEqualToString:@"/"]) {
            [imageUrlString appendString:@"/"];
        }
    } else {
        [imageUrlString appendString:CLOUDINARY_STANDARD_DIRECTORY];
    }
    
    [imageUrlString appendString:path];
    
    
    
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[cachePath stringByAppendingPathComponent:filename]]) {
        
        // If image is caches use that
        NSData *imageData = [NSData dataWithContentsOfFile:[cachePath stringByAppendingPathComponent:filename]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (complete) {
            complete(nil);
        }
        return image;
    } else {
        
        // If the image is not found in the cache download it
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
            
            // Cache the image
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSError *error = nil;
                [imageData writeToFile:[cachePath stringByAppendingPathComponent:filename] options:NSDataWritingAtomic error:&error];
                if (error) {
                    NSLog(@"error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
                }
            });
            
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete(image);
                }
            });
        });
    }
    
    return placeholderImage;
}

@end
