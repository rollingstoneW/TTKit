//
//  NSObject+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TTUtil)

/**
 关联弱引用对象

 @param object 需要被关联的对象
 @param key 常量地址
 */
- (void)tt_setAssociateWeakObject:(id _Nullable)object forKey:(const void *)key;

/**
 获取被关联的弱引用对象
 @param key 常量地址
 */
- (id _Nullable)tt_associateWeakObjectForKey:(const void *)key;

@end

NS_ASSUME_NONNULL_END
