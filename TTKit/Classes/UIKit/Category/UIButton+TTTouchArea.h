//
//  UIButton+TTTouchArea.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TTTouchArea)

/**
 设置button的点击热区，负值为增加热区
 */
@property (nonatomic, assign) UIEdgeInsets tt_hitTestEdgeInsets;

@end
