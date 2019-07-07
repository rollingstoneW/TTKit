//
//  UHNewFeaturesGuideManager.h
//  GuideView
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 wzhnRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHNewFeatureAbstractView.h"

@interface UHNewFeaturesGuideManager : NSObject
+ (instancetype)sharedGuideManager;

@property (nonatomic, strong) UHNewFeatureAbstractView *currentGuideView;

- (void) registNewFeatures:(NSArray<UHNewFeature *> *)features inViewController:(UIViewController *)controller;
- (void) registNewFeatures:(NSArray<UHNewFeature *> *)features
          inViewController:(UIViewController *)controller
                      view:(UIView *)view;
- (void) unRegistFeatures:(NSArray<UHNewFeature *> *)features inViewController:(UIViewController *)controller;

- (void) fireFeature:(UHNewFeature *)feature;
- (BOOL) hasFeatureShowed:(UHNewFeature *)feature inViewController:(UIViewController *)controller;

@end
