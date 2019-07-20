//
//  TTPulldownDismissHeader.h
//  TTKit
//
//  Created by 滚石 on 2019/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 下拉关闭页面
 */
@interface TTPulldownDismissHeader : UIView

+ (nullable instancetype)headerInScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
