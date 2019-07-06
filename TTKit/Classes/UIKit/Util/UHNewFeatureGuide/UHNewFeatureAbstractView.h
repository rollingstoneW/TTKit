//
//  UHNewFeatureAbstractView.h
//  Uhouzz
//
//  Created by 韦振宁 on 16/9/12.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UHNewFeature.h"

@interface UHNewFeatureAbstractView : UIView

@property (nonatomic, strong) NSArray<UHNewFeature *>* features;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) dispatch_block_t disappearBlock;

+ (instancetype) showViewAddedToView:(UIView *)view withNewFeatures:(NSArray<UHNewFeature *> *)features;

- (void) fire;

@end
