//
//  UIView+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIView+TTUtil.h"
#import <OpenGLES/ES2/gl.h>

@implementation UIView (TTUtil)

- (void)tt_setLayerBorder:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    [self tt_setLayerBorder:width color:color cornerRadius:cornerRadius masksToBounds:NO];
}

- (void)tt_setLayerBorder:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masksToBounds {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = masksToBounds;
}

- (void)tt_setLayerShadow:(UIColor *)color offset:(CGSize)offset {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = 1;
}

- (void)tt_setContentHorizentalResistancePriority:(UILayoutPriority)priority {
    [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)tt_setContentVerticalResistancePriority:(UILayoutPriority)priority {
    [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
}

- (UIImage *)tt_drawGlToImage {
    return [UIImage imageWithData:[self tt_GlImageData]];
}

- (NSData *)tt_GlImageData {
    int s = 1;
    UIScreen* screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)]) {
        s = (int)[screen scale];
    }
    const int w = self.frame.size.width;
    const int h = self.frame.size.height;
    const NSInteger myDataLength = w * h * 4 * s * s;
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *)malloc(myDataLength);
    glReadPixels(0, 0, w*s, h*s, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *)malloc(myDataLength);
    for(int y = 0; y < h*s; y++)
    {
        memcpy( buffer2 + (h*s - 1 - y) * w * 4 * s, buffer + (y * 4 * w * s), w * 4 * s );
    }
    free(buffer); // work with the flipped buffer, so get rid of the original one.

    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w * s;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w*s, h*s, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    // then make the uiimage from that
    UIImage *myImage = [ UIImage imageWithCGImage:imageRef scale:s orientation:UIImageOrientationUp ];
    NSData *data = UIImagePNGRepresentation(myImage);
    CGImageRelease( imageRef );
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    free(buffer2);
    return data;
}

- (UIImage *)tt_imageCaptureBySystem {
    UIGraphicsBeginImageContext(self.frame.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UITapGestureRecognizer *)tt_addTapGestureWithTarget:(id)target selector:(SEL)selector {
    if (![target respondsToSelector:selector]) { return nil; }
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tap.delegate = target;
    [self addGestureRecognizer:tap];
    return tap;
}

- (UIPanGestureRecognizer *)tt_addPanGestureWithTarget:(id)target selector:(SEL)selector {
    if (![target respondsToSelector:selector]) { return nil; }
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:pan];
    return pan;
}

- (UILongPressGestureRecognizer *)tt_addLongPressGestureWithTarget:(id)target selector:(SEL)selector {
    if (![target respondsToSelector:selector]) { return nil; }
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    press.delegate = target;
    [self addGestureRecognizer:press];
    return press;
}

- (void)tt_removeAllGesture{
    for (UIGestureRecognizer* gesture in self.gestureRecognizers) {
        gesture.delegate = nil ;
        gesture.enabled = NO;
    }
}

@end
