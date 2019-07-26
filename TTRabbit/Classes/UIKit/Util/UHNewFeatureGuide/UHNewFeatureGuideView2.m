//
//  UHNewFeatureGuideView2.m
//  Uhouzz
//
//  Created by 韦振宁 on 16/9/9.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import "UHNewFeatureGuideView2.h"
#import "UHNewFeaturesGuideManager.h"
#import "UIColor+YYAdd.h"
#import "TTMacros.h"
#import "TTEdgeInsetsLabel.h"
#import "TTUIKitFactory.h"

@interface UHNewFeatureGuideView2 ()

@property (nonatomic, strong) UHNewFeature *feature;

@end

@implementation UHNewFeatureGuideView2

+ (instancetype)showViewAddedToView:(UIView *)view withNewFeatures:(NSArray<UHNewFeature *> *)features {
    
    UHNewFeature *feature = features.firstObject;
    
    CGFloat dotWidth = 10.f;
    CGFloat lineHeight = 20.f;
    
    TTEdgeInsetsLabel *label = [[TTEdgeInsetsLabel alloc] init];
    label.font = kTTFont_12;
    label.textColor = kTTColor_White;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColorHex(feb501) colorWithAlphaComponent:0.9f];
    label.textAlignment = NSTextAlignmentCenter;
    label.edgeInsets = UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f);
    label.layer.cornerRadius = 3.f;
    label.layer.masksToBounds = YES;
    label.text = feature.desc;
    CGSize size = [label sizeThatFits:CGSizeMake(200.f, 200.f)];
    size.width += 10 * 2;
    size.height += 5 * 2;
    label.frame = CGRectMake(0.f, 0.f, size.width, size.height);
    
    CGFloat x = CGRectGetWidth(view.frame) - kAdaptedWidth47(46.f) - CGRectGetWidth(label.frame);
    CGFloat y = CGRectGetMinY(feature.targetFrame) - 16.f - CGRectGetHeight(label.frame);
    
    UHNewFeatureGuideView2 *guideView = [[UHNewFeatureGuideView2 alloc] initWithFrame:
                                         CGRectMake(x, y, CGRectGetWidth(label.frame),
                                                    CGRectGetHeight(label.frame) + lineHeight + dotWidth)];
    guideView.feature = feature;
    [guideView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:
                    CGRectMake(CGRectGetMaxX(label.frame) - kAdaptedWidth47(36.f), CGRectGetMaxY(label.frame), 1.f, lineHeight)];
    line.backgroundColor = label.backgroundColor;
    [guideView addSubview:line];
    
    UIView *dotView = [[UIView alloc] initWithFrame:
    CGRectMake(CGRectGetMinX(line.frame) - dotWidth / 2, CGRectGetMaxY(line.frame), dotWidth, dotWidth)];
    dotView.backgroundColor = label.backgroundColor;
    dotView.layer.cornerRadius = dotWidth / 2;
    dotView.layer.masksToBounds = YES;
    [guideView addSubview:dotView];
    
    [view addSubview:guideView];
    guideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return guideView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self fire];
}

- (void) fire {
    [self removeFromSuperview];
    [[UHNewFeaturesGuideManager sharedGuideManager] fireFeature:self.feature];
}

@end
