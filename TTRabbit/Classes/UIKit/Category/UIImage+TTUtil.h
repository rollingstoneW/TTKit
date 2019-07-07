//
//  UIImage+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Additions)

/**
 [self gradientImageWithSize:size colors:colors pointStart:CGPointZero end:CGPointMake(1, 1) cornerRadius:size.height / 2 locations:nil];
 */
+ (UIImage *)tt_gradientRoundedCornerImageWithSize:(CGSize)size colors:(NSArray *)colors;

/**
 创建渐变色图片
 
 @param size 大小
 @param colors 渐变色(UIColor,CGColor)
 @param start 开始位置 {0,0} ~ {1,1}
 @param end 结束位置 {0,0} ~ {1,1}
 @param cornerRadius 圆角
 @param locations @[NSNumber] 颜色分布，为空则均匀分布
 */
+ (UIImage *)tt_gradientImageWithSize:(CGSize)size
                               colors:(NSArray *)colors
                           pointStart:(CGPoint)start
                                  end:(CGPoint)end
                         cornerRadius:(CGFloat)cornerRadius
                            locations:(NSArray * _Nullable)locations;

/**
 Jpeg方式压缩图片，如果图片过大，可能会卡主线程。大图片建议用tt_compressWithTargetSize:dataLength:completion:
 
 @param targetSize 目标大小
 @param dataLength 二进制长度
 */
- (nullable NSData *)tt_compressedDataWithTargetSize:(CGSize)targetSize dataLength:(NSUInteger)dataLength;

/**
 Jpeg方式在子线程压缩图片
 
 @param targetSize 目标大小
 @param dataLength 二进制长度
 @param completion 完成的回掉，在主线程回掉
 */
- (void)tt_compressWithTargetSize:(CGSize)targetSize
                       dataLength:(NSUInteger)dataLength
                       completion:(void(^)(NSData * _Nullable data))completion;

@end

NS_ASSUME_NONNULL_END

