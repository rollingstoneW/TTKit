//
//  NSObject+TTSingleton.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 遵守这个协议的类会自动生成单例方法，线程安全
 */
@protocol TTSingleton <NSObject>

@optional

/**
 单例方法
 */
+ (instancetype)sharedInstance;

/**
 销毁单例
 */
+ (void)destorySharedInstance;

/**
 自定义单例，可以重写此方法自己生成单例
 */
+ (instancetype)getInstance;

@end

@interface NSObject (TTSingleton)

@end

NS_ASSUME_NONNULL_END
