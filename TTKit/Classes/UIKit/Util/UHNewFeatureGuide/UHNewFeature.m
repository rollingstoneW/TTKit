//
//  UHNewFeature.m
//  Uhouzz
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import "UHNewFeature.h"

@interface NSObject (Private)
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
@end

@interface UHNewFeature ()
@end

@implementation UHNewFeature

+ (instancetype)featureWithTargetFrame:(CGRect)frame sel:(NSString *)sel desc:(NSString *)desc identifier:(NSString *)identifier {
    UHNewFeature *feature = [[UHNewFeature alloc] init];
    feature.targetFrame = frame;
    feature.selectorString = sel;
    feature.desc = desc;
    feature.identifier = identifier;
    return feature;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldFire = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.targetFrame = [aDecoder decodeCGRectForKey:NSStringFromSelector(@selector(targetFrame))];
        self.selectorString = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(selectorString))];
        self.desc = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(desc))];
        self.identifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(identifier))];
        self.shouldFire = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(shouldFire))];
        self.style = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(style))];
        self.guideMode = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(guideMode))];
        self.hasShown = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(hasShown))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.selectorString forKey:NSStringFromSelector(@selector(selectorString))];
    [aCoder encodeObject:self.desc forKey:NSStringFromSelector(@selector(desc))];
    [aCoder encodeObject:self.identifier forKey:NSStringFromSelector(@selector(identifier))];
    [aCoder encodeBool:self.shouldFire forKey:NSStringFromSelector(@selector(shouldFire))];
    [aCoder encodeBool:self.hasShown forKey:NSStringFromSelector(@selector(hasShown))];
    [aCoder encodeInteger:self.style forKey:NSStringFromSelector(@selector(style))];
    [aCoder encodeInteger:self.guideMode forKey:NSStringFromSelector(@selector(guideMode))];
    [aCoder encodeCGRect:self.targetFrame forKey:NSStringFromSelector(@selector(targetFrame))];
}

@end
