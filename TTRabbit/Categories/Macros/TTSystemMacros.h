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

#ifndef kiOS7Later
#define kiOS7Later @available(iOS 7.0, *)
#endif

#ifndef kiOS8Later
#define kiOS8Later @available(iOS 8.0, *)
#endif

#ifndef kiOS9Later
#define kiOS9Later @available(iOS 9.0, *)
#endif

#ifndef kiOS10Later
#define kiOS10Later @available(iOS 10.0, *)
#endif

#ifndef kiOS11Later
#define kiOS11Later @available(iOS 11.0, *)
#endif

#ifndef kiOS12Later
#define kiOS12Later @available(iOS 12.0, *)
#endif

#ifndef kiOS13Later
#define kiOS13Later @available(iOS 13.0, *)
#endif

#ifndef kiOS14Later
#define kiOS14Later @available(iOS 14.0, *)
#endif

#endif /* TTSystemMacros_h */
