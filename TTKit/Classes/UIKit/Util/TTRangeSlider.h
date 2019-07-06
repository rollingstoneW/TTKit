//
//  TTRangeSlider.h
//  maguanjiaios
//
//  Created by rollingstoneW on 2018/12/1.
//  Copyright © 2018 cn.com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTRangeSlider : UIControl

@property (nonatomic, copy) NSArray<NSString *>* values;

@property (nonatomic, copy) NSString *curMinValue;
@property (nonatomic, copy) NSString *curMaxValue;

@property(nonatomic,strong) UIImage *minimumValueImage;
@property(nonatomic,strong) UIImage *maximumValueImage;
@property(nonatomic,strong) UIImage *draggingThumbImage;


@end
