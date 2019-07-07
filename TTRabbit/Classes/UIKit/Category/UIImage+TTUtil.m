//
//  UIImage+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIImage+TTUtil.h"
#import "UIImage+YYAdd.h"

@implementation UIImage (Additions)

+ (UIImage *)tt_gradientImageWithSize:(CGSize)size
                               colors:(NSArray *)colors
                           pointStart:(CGPoint)start
                                  end:(CGPoint)end
                         cornerRadius:(CGFloat)cornerRadius
                            locations:(NSArray *)locations {
    NSMutableArray *CGColors = [NSMutableArray array];
    for (id color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [CGColors addObject:(id)[(UIColor *)color CGColor]];
        } else {
            [CGColors addObject:color];
        }
    }
    
    CGFloat colorLocations[locations.count];
    for (NSInteger i = 0; i < locations.count; i++) {
        NSNumber *num = locations[i];
        colorLocations[i] = num.floatValue;
    }
    
    CGPoint startPoint = CGPointMake(size.width * start.x, size.height * start.y);
    CGPoint endPoint = CGPointMake(size.width * end.x, size.height * end.y);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (cornerRadius) {
        CGPathRef path = CGPathCreateWithRoundedRect((CGRect){CGPointZero, size}, cornerRadius, cornerRadius, nil);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)CGColors, locations.count ? (const CGFloat *)&colorLocations : nil);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)tt_gradientRoundedCornerImageWithSize:(CGSize)size colors:(NSArray *)colors {
    return [self tt_gradientImageWithSize:size
                                   colors:colors
                               pointStart:CGPointZero
                                      end:CGPointMake(1, 1)
                             cornerRadius:size.height / 2
                                locations:nil];
}

- (NSData *)tt_compressedDataWithTargetSize:(CGSize)targetSize dataLength:(NSUInteger)dataLength {
    UIImage *image = self;
    if (!CGSizeEqualToSize(targetSize, CGSizeZero)) {
        image = [self imageByResizeToSize:targetSize];
    }
    CGFloat quality = 0.9;
    NSData *data = UIImageJPEGRepresentation(image, quality);
    while (data.length > dataLength) {
        quality -= 0.1;
        if (quality <= 0) {
            return nil;
        }
        data = UIImageJPEGRepresentation(image, quality);
    }
    return data;
}

- (void)tt_compressWithTargetSize:(CGSize)targetSize dataLength:(NSUInteger)dataLength completion:(void (^)(NSData *))completion {
    if (!completion) { return; }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [self tt_compressedDataWithTargetSize:targetSize dataLength:dataLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data);
        });
    });
}

@end


