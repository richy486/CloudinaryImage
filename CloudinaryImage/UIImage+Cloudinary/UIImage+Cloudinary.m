//
//  UIImage+Cloudinary.m
//  CloudinaryImage
//
//  Created by Richard Adem on 15/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UIImage+Cloudinary.h"

NSString *const CloudinaryWidthAttributeName = @"kCloudinaryWidthAttributeName";
NSString *const CloudinaryHeightAttributeName = @"kCloudinaryHeightAttributeName";

static NSString *const CLOUDINARY_BASE_URL_STRING = @"http://res.cloudinary.com";
static NSString *const CLOUDINARY_STANDARD_DIRECTORY = @"/image/upload/";

@implementation UIImage (Cloudinary)

+ (UIImage*) imageWithCloudinaryUsername:(NSString*) username path:(NSString*) path complete:(CloudinaryCompletionBlock) complete {
    return [self imageWithCloudinaryUsername:username path:path usingAttributes:nil withPlaceholderImage:nil complete:complete];
}

+ (UIImage*) imageWithCloudinaryUsername:(NSString*) username path:(NSString*) path usingAttributes:(NSDictionary*) attributes withPlaceholderImage:(UIImage*) placeholderImage complete:(CloudinaryCompletionBlock) complete {
    
    if (username && path) {
        NSString *cacheKey = [path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        
        // Add a the attribute string to the key so different versions of the image can be cached separately.
        NSMutableString *attributesString = nil;
        if (attributes && attributes.count > 0) {
            
            attributesString = [NSMutableString stringWithString:@""];
            [self appendAttributeValueFromKey:CloudinaryWidthAttributeName fromAttributes:attributes toString:attributesString usingParamater:@"w"];
            [self appendAttributeValueFromKey:CloudinaryHeightAttributeName fromAttributes:attributes toString:attributesString usingParamater:@"h"];
            
            cacheKey = [NSString stringWithFormat:@"%tu_%@", attributesString, cacheKey];
        }
        
        // Check if cached image exists
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[cachePath stringByAppendingPathComponent:cacheKey]]) {
            
            // If image is caches use that
            NSData *imageData = [NSData dataWithContentsOfFile:[cachePath stringByAppendingPathComponent:cacheKey]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            if (complete) {
                complete(nil);
            }
            return image;
        } else {
            
            NSMutableString *imageUrlString = [[NSMutableString alloc] initWithString:CLOUDINARY_BASE_URL_STRING];
            [imageUrlString appendString:@"/"];
            [imageUrlString appendString:username];
            
            NSMutableString *endPath = nil;
            if (path.pathComponents.count > 2 && [path.pathComponents[0] isEqualToString:@"image"]) {
                
                [imageUrlString appendString:[NSString stringWithFormat:@"/%@/%@/", path.pathComponents[0], path.pathComponents[1]]];
                endPath = [NSMutableString stringWithString:@""];
                for (NSInteger i = 2; i < path.pathComponents.count; ++i) {
                    if (endPath.length > 0) {
                        [endPath appendString:@"/"];
                    }
                    
                    [endPath appendString:[NSString stringWithFormat:@"%@", path.pathComponents[i]]];
                }
            } else {
                [imageUrlString appendString:CLOUDINARY_STANDARD_DIRECTORY];
                endPath = [NSMutableString stringWithString:path];
            }
            
            if (attributesString) {
                [imageUrlString appendString:attributesString];
                [imageUrlString appendString:@"/"];
            }
            
            [imageUrlString appendString:endPath];
            NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
            
            
            // If the image is not found in the cache download it
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
                
                // Cache the image
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSError *error = nil;
                    [imageData writeToFile:[cachePath stringByAppendingPathComponent:cacheKey] options:NSDataWritingAtomic error:&error];
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
    }
    
    return placeholderImage;
}

+ (void) appendAttributeValueFromKey:(NSString*) key fromAttributes:(NSDictionary*) attributes toString:(NSMutableString*) string usingParamater:(NSString*) paramater {
    if (attributes[key]) {
        if (string.length > 0) {
            [string appendString:@","];
        }
        
        id value = attributes[key];
        [string appendString:[NSString stringWithFormat:@"%@_%@", paramater, value]];
    }
}

@end
