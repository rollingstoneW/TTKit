//
//  UHNewFeature.h
//  Uhouzz
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UHNewFeatureGuideMode) {
    UHNewFeatureGuideModeCircle, // 圆圈
    UHNewFeatureGuideModeHighlighted // 高亮
};

@interface UHNewFeature : NSObject <NSCoding>

@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, copy) NSString *selectorString;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) BOOL shouldFire; // 默认为YES

@property (nonatomic, assign) NSInteger style; // 0是UHNewFeatureGuideView，1是UHNewFeatureGuideView2，为1时暂时只支持传入一个feature

// 导航模式
@property (nonatomic, assign) UHNewFeatureGuideMode guideMode; //style为0时有效

@property (nonatomic, assign) BOOL hasShown;

+ (instancetype) featureWithTargetFrame:(CGRect)frame sel:(NSString *)sel desc:(NSString *)desc identifier:(NSString *)identifier;

@end
