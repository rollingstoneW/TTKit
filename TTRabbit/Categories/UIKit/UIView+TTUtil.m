//
//  UIView+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIView+TTUtil.h"
#import <OpenGLES/ES2/gl.h>
#import "TTMacros.h"

#if __has_include (<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#elif __has_include (<YYCategories/YYCategories.h>)
#import <YYCategories/YYCategories.h>
#endif

@interface UIView (TTPrivate) <UIGestureRecognizerDelegate>
@end

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

- (void)tt_setLayerRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    CGSize size = self.frame.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    [self tt_setLayerRoundingCorners:corners cornerRadii:cornerRadii selfSize:size];
}

- (void)tt_setLayerRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii selfSize:(CGSize)size {
    CGRect frame = (CGRect){.size = size};
    UIBezierPath *maskPath= [UIBezierPath  bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
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
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    return pan;
}

- (UISwipeGestureRecognizer *)tt_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction Target:(id)target selector:(SEL)selector {
    if (![target respondsToSelector:selector]) { return nil; }
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:selector];
    swipe.direction = direction;
    swipe.delegate = self;
    [self addGestureRecognizer:swipe];
    return swipe;
}

- (UILongPressGestureRecognizer *)tt_addLongPressGestureWithTarget:(id)target selector:(SEL)selector {
    if (![target respondsToSelector:selector]) { return nil; }
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    press.delegate = target;
    [self addGestureRecognizer:press];
    return press;
}

- (UITapGestureRecognizer *)tt_addTapGestureWithBlock:(void (^)(UITapGestureRecognizer *))block {
    if (!block) { return nil; }
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        block(sender);
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    return tap;
}

- (UIPanGestureRecognizer *)tt_addPanGestureWithBlock:(void (^)(UIPanGestureRecognizer *))block {
    if (!block) { return nil; }
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        block(sender);
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    return tap;
}

- (UISwipeGestureRecognizer *)tt_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UISwipeGestureRecognizer *))block {
    if (!block) { return nil; }
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        block(sender);
    }];
    swipe.direction = direction;
    swipe.delegate = self;
    [self addGestureRecognizer:swipe];
    return swipe;
}

- (UILongPressGestureRecognizer *)tt_addLongPressGestureWithBlock:(void (^)(UILongPressGestureRecognizer *))block {
    if (!block) { return nil; }
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        block(sender);
    }];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    return longPress;
}

- (void)tt_removeAllGesture{
    for (UIGestureRecognizer* gesture in self.gestureRecognizers) {
        gesture.delegate = nil ;
        gesture.enabled = NO;
    }
}

- (NSString *)tt_debugHierarchy {
    SEL selector = NSSelectorFromString([@"recursive" stringByAppendingString:@"Description"]);
    if ([self respondsToSelector:selector]) {
        TTSuppressPerformSelectorLeakWarning(return [self performSelector:selector];)
    }
    return nil;
}

- (UIEdgeInsets)tt_safeAreaInsets {
    if (kiOS11Later) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)tt_layoutConstantForAttribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == attribute) {
            return constraint.constant;
        }
    }
    return 0;
}

- (CGFloat)tt_layoutConstantForAttribute:(NSLayoutAttribute)attribute relatedView:(UIView *)view {
    return [self tt_layoutConstantForAttribute:attribute relatedView:view relatedAttribute:attribute];
}

- (CGFloat)tt_layoutConstantForAttribute:(NSLayoutAttribute)attribute relatedView:(UIView *)view relatedAttribute:(NSLayoutAttribute)related {
    for (NSLayoutConstraint *constraint in [self.constraints arrayByAddingObjectsFromArray:view.constraints ?: @[]]) {
        if ((constraint.firstAttribute == attribute && constraint.secondItem == view && constraint.secondAttribute == related) ||
            (constraint.firstAttribute == related && constraint.secondItem == self && constraint.secondAttribute == attribute)) {
            return constraint.constant;
        }
    }
    return 0;
}

@end
