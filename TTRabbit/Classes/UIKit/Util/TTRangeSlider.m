//
//  TTRangeSlider.m
//  maguanjiaios
//
//  Created by rollingstoneW on 2018/12/1.
//  Copyright © 2018 cn.com.uzero. All rights reserved.
//

#import "TTRangeSlider.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"

static const CGFloat thumbWidth = 26;

@interface TTRangeSlider ()

@property (nonatomic, strong) NSArray<UILabel *>* valueLabels;

@property (nonatomic, strong) UIImageView *leftThumb;
@property (nonatomic, strong) UIImageView *rightThumb;
@property (nonatomic, strong) UIImageView *curDraggingThumb;

@property (nonatomic, strong) UIView *trackView;

@end

@implementation TTRangeSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.trackView];
    [self addSubview:self.leftThumb];
    [self addSubview:self.rightThumb];

    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(40, thumbWidth / 2, 0, thumbWidth / 2));
        make.height.equalTo(@10);
    }];
    [self.leftThumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.trackView);
        make.centerX.equalTo(self.trackView.mas_left);
        make.size.mas_equalTo(CGSizeMake(thumbWidth, thumbWidth));
    }];
    [self.rightThumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.trackView);
        make.right.equalTo(self).priorityLow();
        make.size.mas_equalTo(CGSizeMake(thumbWidth, thumbWidth));
    }];
}

- (void)setValues:(NSArray<NSString *> *)values {
    _values = values;
    [self.valueLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (values.count < 2) { return; }

    self.curMinValue = values.firstObject;
    self.curMaxValue = values.lastObject;

    NSMutableArray *labels = [NSMutableArray array];
    self.valueLabels = labels;

    CGFloat space = [self spaceBetweenValues];
    [values enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.text = value;
        [self addSubview:label];
        [labels addObject:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self.trackView.mas_left).offset(space * idx);
        }];
    }];
}

- (void)setMinimumValueImage:(UIImage *)minimumValueImage {
    self.leftThumb.image = minimumValueImage;
}

- (void)setMaximumValueImage:(UIImage *)maximumValueImage {
    self.rightThumb.image = maximumValueImage;
}

- (void)setDraggingThumbImage:(UIImage *)draggingThumbImage {
    self.curDraggingThumb.image = draggingThumbImage;
}

- (void)changeDraggingThumbLocation:(CGFloat)location ended:(BOOL)ended {
    if (!self.curDraggingThumb) { return; }

    CGFloat space = [self spaceBetweenValues];

    CGFloat leftLocation, rightLocation;
    if (self.curDraggingThumb == self.leftThumb) {
        leftLocation = location;
        rightLocation = self.rightThumb.centerX - thumbWidth / 2;
        if (leftLocation > rightLocation - space) {
            location = rightLocation - space;
        }
    } else {
        leftLocation = self.leftThumb.centerX - thumbWidth / 2;
        rightLocation = location;
        if (rightLocation < leftLocation + space) {
            location = leftLocation + space;
        }
    }

    if (ended) {
        NSInteger idx = round(location / space);
        location = idx * space;
        if (self.curDraggingThumb == self.leftThumb) {
            self.curMinValue = self.values[idx];
        } else {
            self.curMaxValue = self.values[idx];
        }

        [self.curDraggingThumb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.trackView.mas_left).offset(location);
        }];
        [UIView animateWithDuration:.2 animations:^{
            [self layoutIfNeeded];
        }];

        self.curDraggingThumb = nil;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } else {
        [self.curDraggingThumb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.trackView.mas_left).offset(location);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.trackView.width && self.valueLabels.count) {
        CGFloat space = [self spaceBetweenValues];
        [self.valueLabels enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.trackView.mas_left).offset(space * idx);
            }];
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.values.count < 2) { return; }

    CGPoint locationPoint = [touches.anyObject locationInView:self];
    if (locationPoint.y <= 20) { return; }

    CGFloat location = [self correctingLocation:locationPoint.x];
    CGFloat distanceToLeft = ABS(location - self.leftThumb.centerX);
    CGFloat distanceToRight = ABS(location - self.rightThumb.centerX);

    self.curDraggingThumb = distanceToLeft > distanceToRight ? self.rightThumb : self.leftThumb;
    [self changeDraggingThumbLocation:location ended:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat location = [self correctingLocation:[touches.anyObject locationInView:self].x];
    [self changeDraggingThumbLocation:location ended:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat location = [self correctingLocation:[touches.anyObject locationInView:self].x];
    [self changeDraggingThumbLocation:location ended:YES];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat location = [self correctingLocation:[touches.anyObject locationInView:self].x];
    [self changeDraggingThumbLocation:location ended:YES];
}

- (CGFloat)correctingLocation:(CGFloat)location {
    return MIN(MAX(location - thumbWidth / 2, 0), self.trackView.width);
}

- (CGFloat)spaceBetweenValues {
    if (!self.trackView.width || self.values.count < 2) { return 0; }
    return self.trackView.width / (self.values.count - 1);
}

- (UIImageView *)leftThumb {
    if (!_leftThumb) {
        _leftThumb = [self createThumbWithImage:nil];
    }
    return _leftThumb;
}

- (UIImageView *)rightThumb {
    if (!_rightThumb) {
        _rightThumb = [self createThumbWithImage:nil];
    }
    return _rightThumb;
}

- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [[UIView alloc] init];
        _trackView.layer.cornerRadius = 5;
        _trackView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _trackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _trackView.layer.backgroundColor = [UIColor orangeColor].CGColor;
    }
    return _trackView;
}

- (UIImageView *)createThumbWithImage:(NSString *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 13;
    imageView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    return imageView;
}

@end
