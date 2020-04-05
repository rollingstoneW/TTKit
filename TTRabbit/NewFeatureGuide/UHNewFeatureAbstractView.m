//
//  UHNewFeatureAbstractView.m
//  Uhouzz
//
//  Created by 韦振宁 on 16/9/12.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import "UHNewFeatureAbstractView.h"

@implementation UHNewFeatureAbstractView

+ (instancetype)showViewAddedToView:(UIView *)view withNewFeatures:(NSArray<UHNewFeature *> *)features {
    UHNewFeatureAbstractView *guideView = [[UHNewFeatureAbstractView alloc] initWithFrame:view.bounds];
    [view addSubview:guideView];
    
    guideView.features = features;
    return guideView;
};

- (void) fire {}

@end
