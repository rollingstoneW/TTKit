//
//  TTSystemAuthorization.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TTLocationAuthorizationEnabled 1

#ifdef TTLocationAuthorizationEnabled
typedef NS_ENUM(NSInteger, TTLocationAuthorizationStatus) {
    TTLocationAuthorizationStatusUnknown = -1, // 未知状态
    TTLocationAuthorizationStatusNotDetermined, // 用户尚未确定
    TTLocationAuthorizationStatusDisabled, // 定位功能失效
    TTLocationAuthorizationStatusDenied, // 用户拒绝
    TTLocationAuthorizationStatusAlways, // 实时定位
    TTLocationAuthorizationStatusWhenInUse, // 使用app时定位
    TTLocationAuthorizationStatusLossPravicy, // plist文件缺失定位隐私描述
};
typedef void(^TTLocationAuthorizationCompletion)(TTLocationAuthorizationStatus status);
#endif

@interface TTSystemAuthorization : NSObject

#ifdef TTLocationAuthorizationEnabled
/**
 当前定位权限状态
 */
+ (TTLocationAuthorizationStatus)locationAuthorizationStatus;
/**
 是否授权了始终允许定位
 */
+ (BOOL)isLocationAuthorizedAlways;
/**
 是否授权了
 */
+ (BOOL)isLocationAuthorizedWhenInUse;
/**
 定位权限是否可用
 */
+ (BOOL)isLocationAuthorizedEnabled;
/**
 定位服务是否可用
 */
+ (BOOL)isLocationServiceEnabled;
/**
 定位权限是否已经被用户拒绝
 */
+ (BOOL)isLocationAuthorizationDenied;
/**
 请求始终定位授权
 */
+ (void)requestLocationAuthorizationAlwaysWithCompletion:(TTLocationAuthorizationCompletion)completion;
/**
 请求app使用期间定位授权
 */
+ (void)requestLocationAuthorizationWhenInUseWithCompletion:(TTLocationAuthorizationCompletion)completion;
/**
 根据info.plist里定位权限的描述请求定位
 */
+ (void)requestLocationAuthorizationIfNeededWithCompletion:(TTLocationAuthorizationCompletion)completion;

#endif

+ (BOOL)isCameraGranted;
+ (BOOL)isPhotoLibraryGranted;
+ (void)requestAccessForCameraResultGranted:(dispatch_block_t)granted andDenied:(dispatch_block_t)denied;
+ (void)requestAccessForMicphoneResultGranted:(dispatch_block_t)granted andDenied:(dispatch_block_t)denied;

+ (void)openSystemSetting;

@end
