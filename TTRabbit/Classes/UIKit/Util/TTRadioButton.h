//
//  TTRadioButton.h
//  TTRabbit
//
//  Created by ZYB on 2020/2/28.
//

#import <UIKit/UIKit.h>
@class TTRadioButton;

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTRadioDidSelectBlock)(TTRadioButton *selected, TTRadioButton * _Nullable lastSelected);

@interface TTRadioButton : UIButton

@property (nonatomic, copy, readonly) NSString *group;

+ (void)setDidSelectBlock:(TTRadioDidSelectBlock)block forGroup:(NSString *)group;
+ (TTRadioButton * _Nullable)selectedButtonForGroup:(NSString *)group;
+ (void)selectButton:(TTRadioButton *)button;

- (void)registInGroup:(NSString *)group;

@end

NS_ASSUME_NONNULL_END
