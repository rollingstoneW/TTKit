//
//  UIResponder+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/25.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (TTUtil)

/**
 通过响应链传递自定义消息。常见于子视图向父视图传递消息，父视图在此方法内调用super则会继续向上传递。

 @param action 需要执行的动作
 @param object 需要传递的东西
 @param userInfo 需要传递的用户信息
 @return 返回值
 */
- (id)tt_nextResponderPerform:(NSString *)action object:(id)object userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
