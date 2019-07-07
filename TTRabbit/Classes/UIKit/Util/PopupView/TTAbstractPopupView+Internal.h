//
//  TTAbstractPopupView+Internal.h
//  TTKit
//
//  Created by rollingstoneW on 2018/9/3.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTAbstractPopupView.h"

@interface TTAbstractPopupView ()

@property (nonatomic,   weak) UIView *superviewToShowing;
@property (nonatomic, assign) BOOL animated;

- (void)_showInView:(UIView *)view animated:(BOOL)animated;

@end
