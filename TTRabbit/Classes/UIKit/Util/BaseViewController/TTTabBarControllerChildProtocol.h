//
//  TTTabBarControllerChildProtocol.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/24.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTTabBarControllerChildProtocol <NSObject>

@optional
// 再次选中了当前的tabBarItem
- (void)tabReSelected;

// 双击了tabBarItem
- (void)tabDoubleTaped;

@end
