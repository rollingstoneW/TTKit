//
//  TTSystemMacros.h
//  Pods
//
//  Created by rollingstoneW on 2019/7/18.
//

#ifndef TTSystemMacros_h
#define TTSystemMacros_h

#pragma mark - System Version

#define kiOS_version_7 @"7.0"
#define kiOS_version_8 @"8.0"
#define kiOS_version_9 @"9.0"
#define kiOS_version_10 @"10.0"
#define kiOS_version_11 @"11.0"

#define TT_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define TT_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define TT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define TT_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define TT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kiOS7Later @available(iOS 8.0, *)
#define kiOS8Later @available(iOS 8.0, *)
#define kiOS9Later @available(iOS 9.0, *)
#define kiOS10Later @available(iOS 10.0, *)
#define kiOS11Later @available(iOS 11.0, *)
#define kiOS12Later @available(iOS 12.0, *)
#define kiOS13Later @available(iOS 13.0, *)

#endif /* TTSystemMacros_h */
