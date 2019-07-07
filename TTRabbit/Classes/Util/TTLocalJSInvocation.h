//
//  TTLocalJSInvocation.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/28.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JSValue.h>

NS_ASSUME_NONNULL_BEGIN

/**
 可以调用本地js里的方法，需要js里只有方法
 */
@interface TTLocalJSInvocation : NSObject


/**
 创建本地js调用类

 @param name js名称
 @param functions 需要调用的js函数
 @param bundle 所在bundle
 */
- (nullable instancetype)initWithName:(NSString *)name functions:(NSArray<NSString *> *)functions bundle:(nullable NSBundle * )bundle;

/**
 创建本地js调用类
 
 @param path js本地路径
 @param functions 需要调用的js函数
 */
- (nullable instancetype)initWithPath:(NSString *)path functions:(NSArray<NSString *> *)functions;

/**
 执行js函数
 */
- (void)evaluateJS:(NSString *)JS withCompletion:(void(^)(id value, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
