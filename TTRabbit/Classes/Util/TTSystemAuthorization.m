//
//  TTSystemAuthorization.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTSystemAuthorization.h"
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <objc/runtime.h>
#import "NSObject+TTSingleton.h"

#ifdef TTLocationAuthorizationEnabled
#import <CoreLocation/CoreLocation.h>
#endif

@interface TTSystemAuthorization () <
#ifdef TTLocationAuthorizationEnabled
CLLocationManagerDelegate,
#endif
TTSingleton>

#ifdef TTLocationAuthorizationEnabled
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) TTLocationAuthorizationCompletion locationCompletion;
#endif

@end

@implementation TTSystemAuthorization

#ifdef TTLocationAuthorizationEnabled

+ (BOOL)isLocationAuthorizedAlways {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
}

+ (BOOL)isLocationAuthorizedWhenInUse {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}

+ (BOOL)isLocationAuthorizedEnabled {
    return [self isLocationAuthorizedAlways] || [self isLocationAuthorizedWhenInUse];
}

+ (void)requestLocationAuthorizationAlwaysWithCompletion:(TTLocationAuthorizationCompletion)completion {
    if (![self isLocationServiceEnabled]) {
        !completion ?: completion(TTLocationAuthorizationStatusDisabled);
        return;
    }
    if ([self isLocationAuthorizationDenied]) {
        !completion ?: completion(TTLocationAuthorizationStatusDenied);
        return;
    }
    if (![self hasLocationAlwaysUsageDescription] || ![self hasLocationWhenInUseUsageDescription]) {
        !completion ?: completion(TTLocationAuthorizationStatusLossPravicy);
        return;
    }
    [[TTSystemAuthorization sharedInstance].locationManager requestAlwaysAuthorization];
    [TTSystemAuthorization sharedInstance].locationCompletion = completion;
}

+ (void)requestLocationAuthorizationWhenInUseWithCompletion:(TTLocationAuthorizationCompletion)completion {
    if (![self isLocationServiceEnabled]) {
        !completion ?: completion(TTLocationAuthorizationStatusDisabled);
        return;
    }
    if ([self isLocationAuthorizationDenied]) {
        !completion ?: completion(TTLocationAuthorizationStatusDenied);
        return;
    }
    if (![self hasLocationWhenInUseUsageDescription]) {
        !completion ?: completion(TTLocationAuthorizationStatusLossPravicy);
        return;
    }
    [[TTSystemAuthorization sharedInstance].locationManager requestAlwaysAuthorization];
    [TTSystemAuthorization sharedInstance].locationCompletion = completion;
}

+ (void)requestLocationAuthorizationIfNeededWithCompletion:(TTLocationAuthorizationCompletion)completion {
    if ([self hasLocationAlwaysUsageDescription]) {
        [self requestLocationAuthorizationAlwaysWithCompletion:completion];
    } else if ([self hasLocationWhenInUseUsageDescription]) {
        [self requestLocationAuthorizationWhenInUseWithCompletion:completion];
    } else {
        !completion ?: completion(TTLocationAuthorizationStatusLossPravicy);
    }
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        !self.locationCompletion ?: self.locationCompletion((TTLocationAuthorizationStatus)status);
    } else {
        !self.locationCompletion ?: self.locationCompletion((TTLocationAuthorizationStatus)status);
    }
    self.locationManager = nil;
}

+ (BOOL)isLocationServiceEnabled {
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted;
}

+ (BOOL)isLocationAuthorizationDenied {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied;
}

+ (BOOL)hasLocationAlwaysUsageDescription {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
}

+ (BOOL)hasLocationWhenInUseUsageDescription {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
}

+ (TTLocationAuthorizationStatus)locationAuthorizationStatus {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return TTLocationAuthorizationStatusNotDetermined;
    }
    if (![self isLocationServiceEnabled]) {
        return TTLocationAuthorizationStatusDisabled;
    }
    if ([self isLocationAuthorizationDenied]) {
        return TTLocationAuthorizationStatusDenied;
    }
    if ([self isLocationAuthorizedAlways]) {
        return TTLocationAuthorizationStatusAlways;
    }
    if ([self isLocationAuthorizedWhenInUse]) {
        return TTLocationAuthorizationStatusWhenInUse;
    }
    if (![self hasLocationAlwaysUsageDescription] && ![self hasLocationWhenInUseUsageDescription]) {
        return TTLocationAuthorizationStatusLossPravicy;
    }
    return TTLocationAuthorizationStatusUnknown;
}

#endif


+ (BOOL)isCameraGranted {
    NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio

    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted){
            return NO;
        }
        else if(authStatus == AVAuthorizationStatusDenied){
            return NO;
        }
        else if(authStatus == AVAuthorizationStatusAuthorized){
            return YES;
        }

        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)isPhotoLibraryGranted {
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        if ( [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            return YES;
        }
        return NO;
    }
    return YES;
}

+ (void)requestAccessForCameraResultGranted:(dispatch_block_t)grantedBlock andDenied:(dispatch_block_t)denied {

    NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
    if ([AVCaptureDevice  respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted){
                    if (grantedBlock) {
                        grantedBlock();
                    }
                }
                else {
                    if (denied) {
                        denied();
                    }
                }
            });
        }];
    }
    else if (denied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            denied();
        });
    }
}

+ (void)requestAccessForMicphoneResultGranted:(dispatch_block_t)grantedBlock andDenied:(dispatch_block_t)denied {
    if ([AVAudioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {                // Microphone enabled code
                    if (grantedBlock) {
                        grantedBlock();
                    }
                }
                else {                // Microphone disabled code
                    if (denied) {
                        denied();
                    }
                }
            });
        }];
    }
    else if (denied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (denied) denied();
        });
    }
}

+ (void)openSystemSetting {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                               options:nil
                                     completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
}

@end
