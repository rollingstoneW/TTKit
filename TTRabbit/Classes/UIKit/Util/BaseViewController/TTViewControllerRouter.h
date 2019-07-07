//
//  TTViewControllerRouter.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTViewControllerRouter <NSObject>

// 根据参数处理页面跳转
- (void)handleOpenParams:(NSDictionary *)params;

@end
