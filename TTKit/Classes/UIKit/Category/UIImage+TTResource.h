//
//  UIImage+TTResource.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/4.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TTResource)

/**
 在指定bundle内获取图片
 */
+ (nullable UIImage *)tt_imageNamed:(NSString *_Nullable)name bundle:(NSBundle *)bundle;

/**
 在指定bundle内获取图片，不缓存。会自动根据屏幕分辨率查找，有升分辨率和降分辨率查找的机制。
 */
+ (nullable UIImage *)tt_imageWithContentsOfName:(NSString *)name bundle:(NSBundle *)bundle;

/**
 在指定mainBundle内获取图片，不缓存
 */
+ (nullable UIImage *)tt_imageWithContentsOfName:(NSString *)name;

/**
 生成帧序列图片数组
 
 @param selector 生成方法，默认imageNamed:
 @param prefix 图片前缀
 @param numberPartLength 数字长度（例如frame_star_bling_01，为2）
 @param from 开始索引
 @param end 结束索引
 */
+ (nullable NSArray *)tt_frameImagesWithSelector:(nullable SEL)selector
                                          prefix:(NSString *)prefix
                                numberPartLength:(NSInteger)numberPartLength
                                            from:(NSInteger)from
                                             end:(NSInteger)end;

/**
 生成帧序列图片数组
 
 @param selector 生成方法，默认imageNamed:
 @param names 图片名称列表
 */
+ (nullable NSArray *)tt_frameImagesWithSelector:(nullable SEL)selector names:(NSArray *)names;

@end

NS_ASSUME_NONNULL_END
