//
//  TTMultiSelectionAlertView.h
//  TTKit
//
//  Created by rollingstoneW on 2018/9/3.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMultiSelectionAlertView : UIView

@property (nonatomic, strong) void(^didSelectItemBlock)(NSArray *selections, NSArray *indexes); // 选中的回调,selections:标题数组，indexes:位置数组
@property (nonatomic, strong) dispatch_block_t didDisappearBlock; // 消失的回调
@property (nonatomic, assign) BOOL allowsMultipleSelection; // 是否可以多选，默认YES

//- (instancetype)initWithSelections:(NSArray *)selections title:(NSString *)title;
- (instancetype)initWithSelections:(NSArray *)selections title:(NSString *)title hideButton:(BOOL)hide;

- (void)showAddedAlertViewTo:(UIView *)view animated:(BOOL)animated;
- (void)showInAppDelegateWindow;
- (void)dismiss;

@end
