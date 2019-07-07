//
//  NSString+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (TTUtil)

@property (nonatomic, assign, readonly) NSRange fullRange;

/**
 带html标签的文本转富文本
 */
- (void)convertHtmlStringToNSAttributedString:(void(^)(NSAttributedString *))block;


/**
 如果没有这个前缀，就添加前缀
 @param prefix 前缀
 */
- (NSString *)stringByPrependingPrefixIfNeeded:(NSString *)prefix;

/**
 如果没有这个后缀，就添加后缀
 @param suffix 后缀
 */
- (NSString *)stringByAppendingSuffixIfNeeded:(NSString *)suffix;

/**
 如果有这个前缀，就删掉
 @param prefix 前缀
 */
- (NSString *)stringByDeletingPrefix:(NSString *)prefix;

/**
 如果有这个后缀就删掉
 @param suffix 后缀
 */
- (NSString *)stringByDeletingSuffix:(NSString *)suffix;

/**
 删除所有的空格
 */
- (NSString *)stringByTrimmingWhitespaceThroughout;

#pragma mark - Truncating

/**
 截取字符串，最后以'...'结束

 @param width 最大宽度
 @param font 字体
 @return 截取后的字符串
 */
- (NSString *)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;

/**
 截取字符串，最后以'...'结束

 @param size 最大范围
 @param attributes 富文本属性，UIFont必传
 @param lastLineTailInset 最后一行缩进，正值
 @return 截取后的字符串
 */
- (NSString *)stringByTruncatingToSize:(CGSize)size
                    withTextAttributes:(NSDictionary *)attributes
                     lastLineTailInset:(CGFloat)lastLineTailInset;

#pragma mark - URL

/**
 通过url格式添加key和value
 */
- (NSString *)urlStringByAppendingKey:(NSString *)key value:(NSString *)value;

/**
 通过url格式添加参数（keysAndValues）
 */
- (NSString *)urlStringByAppendingQueries:(NSDictionary *)queries;

/**
 把参数urlencode
 */
- (NSString *)urlStringByQueryEncode;

/**
 获取url参数
 */
- (NSDictionary *)urlQueries;

#pragma mark - Validating

/**
 是否是中文
 */
- (BOOL)isChinese;

/**
 是否是有效的邮箱
 */
- (BOOL)isValidEmail;

/**
 是否是有效的url地址
 */
- (BOOL)isValidHttpURL;

/**
 收否是有效的手机号，弱验证，只验证开头两位和总长度是11位
 */
- (BOOL)isValidPhoneNumber;

/**
 是否是纯数字
 */
- (BOOL)isPureInteger;

/**
 是否是小数
 */
- (BOOL)isFloat;

/**
 是否是有效的微信号
 */
- (BOOL)isValidWXNumber;

/**
 是否是有效的QQ号
 */
- (BOOL)isValidQQ;

#pragma mark - Formatter

/**
 把字节数转换为文件大小的描述，例如30.9 MB
 */
+ (NSString *)fileSizeStringWithByteCount:(long long)byteCount;

/**
 把剩余时间转换为倒计时格式的字符串，例如1:03:54
 */
+ (NSString *)countdownStringWithInteval:(NSTimeInterval)interval;

/**
 把浮点数转换为字符串，不会丢失精度
 */
+ (NSString *)decimalFormatedStringWithNumber:(CGFloat)number;

@end
