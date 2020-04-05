//
//  TTNavigationBar.h
//  TTKit
//
//  Created by rollingstoneW on 2018/9/17.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TTNavigationBarTitleAlignment) {
    TTNavigationBarTitleAlignmentCenter = 0,
    TTNavigationBarTitleAlignmentAfterLeftButtons,
};

@interface TTNavigationBar : UIView

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSDictionary *titleAttributes UI_APPEARANCE_SELECTOR; // default is {font:bold-17,color:333333}
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, assign) TTNavigationBarTitleAlignment titleAlignment;

@property (nonatomic, strong) UIImage *backImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *backHighlightedImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, assign) BOOL showBackButton; // default is YES

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong, readonly) UIView *shadowLine; // default is e5e5e5

@property (nonatomic, strong) NSArray<UIButton *> *leftButtons;
@property (nonatomic, strong) NSArray<UIButton *> *rightButtons;

@property (nonatomic, assign) CGFloat horiIndent UI_APPEARANCE_SELECTOR; // default is 15
@property (nonatomic, assign) CGFloat itemSpace UI_APPEARANCE_SELECTOR; // default is 10

@property (nonatomic, assign) BOOL ignoreCurrentUpdateConstraints; // for performance

- (void)addLeftButton:(nonnull UIButton *)item;
- (void)addRightButton:(nonnull UIButton *)item;

- (void)initializer NS_REQUIRES_SUPER; // for override

+ (CGFloat)statusBarHeight;
+ (CGFloat)barHeight;

@end
