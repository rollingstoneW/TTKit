//
//  TTCategoryMenuBarUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat TTCategoryMenuBarHeight;
UIKIT_EXTERN const CGFloat TTCategoryMenuBarOptionTailIndent;
UIKIT_EXTERN const CGFloat TTCategoryMenuBarDoneButtonHeight;

#define TTCategoryMenuBarScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define TTCategoryMenuBarScreenHeight [[UIScreen mainScreen] bounds].size.height
#define TTCategoryMenuBar1PX          (1 / [UIScreen mainScreen].scale)

UIKIT_EXTERN UIColor * TTCategoryMenuBarBgColor(void);
UIKIT_EXTERN UIColor * TTCategoryMenuBarLineColor(void);
UIKIT_EXTERN UIColor * TTCategoryMenuBarBlackColor(void);
UIKIT_EXTERN UIColor * TTCategoryMenuBarGrayColor(void);
UIKIT_EXTERN UIColor * TTCategoryMenuBarBlueColor(void);

NS_ASSUME_NONNULL_END
