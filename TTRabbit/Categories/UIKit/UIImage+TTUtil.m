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

+ (CIImage *)tt_QRCodeCIImageWithLink:(NSString *)link {
    NSData *data = [link dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"]; //设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)
    return filter.outputImage;
}

+ (UIImage *)tt_resizeQRCodeImage:(CIImage *)image withSize:(CGSize)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();

    CGContextRef contextRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    CGContextScaleCTM(contextRef, scale, scale);
    CGContextDrawImage(contextRef, extent, imageRef);

    CGImageRef imageRefResized = CGBitmapContextCreateImage(contextRef);

    //Release
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    return [UIImage imageWithCGImage:imageRefResized];
}

+ (UIImage *)tt_QRCodeImageWithLink:(NSString *)link size:(CGSize)size {
    CIImage *image = [self tt_QRCodeCIImageWithLink:link];
    return [self tt_resizeQRCodeImage:image withSize:size];
}

+ (UIImage *)tt_QRCodeImageWithLink:(NSString *)link width:(CGFloat)width {
    return [self tt_QRCodeImageWithLink:link size:CGSizeMake(width, width)];
}

+ (UIImage *)tt_QRCodeImageWithLink:(NSString *)link width:(CGFloat)width watermark:(UIImage *)watermark {
    UIImage *QRCodeImage = [self tt_QRCodeImageWithLink:link width:width];
    CGFloat iconWidth = watermark.size.width;
    CGFloat iconHeight = watermark.size.height;
    CGRect rect = CGRectMake((QRCodeImage.size.width - iconWidth) / 2,
                             (QRCodeImage.size.height - iconHeight) / 2,
                             iconWidth,
                             iconHeight);
    return [[self tt_QRCodeImageWithLink:link width:width] tt_addWatermark:watermark inRect:rect];
}

- (UIImage *)tt_addWatermark:(UIImage *)watermark inRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0.f, 0.f, self.size.width, self.size.height)];
    [watermark drawInRect:rect];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
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


