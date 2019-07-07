//
//  UIButton+TTImagePosition.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TTButtonImagePosition) {
    TTButtonImagePositionLeft, // 图片在左
    TTButtonImagePositionRight, // 图片在右
    TTButtonImagePositionTop, // 图片在上
    TTButtonImagePositionBottom // 图片在下
};

@interface UIButton (TTIcon)

/**
 创建没有点击事件的icon

 @param image icon图标
 @param text icon文字
 @param imagePosition 图标位置
 @param space 图标和文字的距离
 */
+ (instancetype)tt_iconWithImage:(UIImage *)image
                            text:(NSString *)text
                   imagePosition:(TTButtonImagePosition)imagePosition
                           space:(CGFloat)space;

/**
 把图片放在指定位置，布局button，会自动设置contentEdgeInsets，自适应大小

 @param position 图片的位置
 @param space 图片和文字的距离
 */
- (void)tt_layoutWithImagePosition:(TTButtonImagePosition)position space:(CGFloat)space;

/**
 还原button布局，重置contentEdgeInsets，imageEdgeInsets，titleEdgeInsets
 */
- (void)tt_resetEdgeInsets;

@end
