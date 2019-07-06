//
//  UHNewFeaturesGuideManager.m
//  GuideView
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 wzhnRabbit. All rights reserved.
//

#import "UHNewFeaturesGuideManager.h"
#import "UHNewFeatureGuideView.h"
#import "UHNewFeatureGuideView2.h"
#import "TTKit.h"
#import "NSObject+YYAdd.h"

static NSString *const kNewFeaturesStoreKey = @"kNewFeaturesStoreKey";

@interface UHNewFeatureModel : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray<UHNewFeature *> *features;
@property (nonatomic, copy) NSString *classNameForViewController;

@end

@implementation UHNewFeatureModel

- (NSMutableArray<UHNewFeature *> *)features {
    if (!_features) {
        _features = @[].mutableCopy;
    } else if (![_features isKindOfClass:[NSMutableArray class]]) {
        _features = _features.mutableCopy;
    }
    return _features;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.features = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(features))];
        self.classNameForViewController = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(classNameForViewController))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.features forKey:NSStringFromSelector(@selector(features))];
    [aCoder encodeObject:self.classNameForViewController forKey:NSStringFromSelector(@selector(classNameForViewController))];
}

@end

@interface UHNewFeaturesGuideManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, UHNewFeatureModel *> *features;
@property (nonatomic, strong) UHNewFeatureModel *modelShowing;

@property (nonatomic, weak) UIViewController *target;

@end

@implementation UHNewFeaturesGuideManager
+ (instancetype)sharedGuideManager{
    static UHNewFeaturesGuideManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UHNewFeaturesGuideManager alloc] init];
    });
    
    return instance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        id data = [[NSUserDefaults standardUserDefaults] objectForKey:kNewFeaturesStoreKey];
        NSDictionary *featuresStored = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _features = featuresStored ? featuresStored.mutableCopy : @{}.mutableCopy;
    }
    return self;
}

- (BOOL) hasFeatureShowed:(UHNewFeature *)feature inViewController:(UIViewController *)controller {
    UHNewFeatureModel *featureModel = [self modelInController:controller];
    for (UHNewFeature *featureStored in featureModel.features) {
        if ([feature.identifier isEqualToString:featureStored.identifier]) {
            return featureStored.hasShown;
        }
    }
    return NO;
}

- (void) unRegistFeatures:(NSArray<UHNewFeature *> *)features inViewController:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    UHNewFeatureModel *featureModel = [self modelInController:controller];
    NSMutableArray *oldFeatures = featureModel.features;
    
    for (UHNewFeature *featureNew in features) {
        for (UHNewFeature *featureStored in [oldFeatures copy]) {
            if ([featureNew.identifier isEqualToString:featureStored.identifier]) {
                [oldFeatures removeObject:featureStored];
                break;
            }
        }
    }
    featureModel.features = oldFeatures;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.features];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kNewFeaturesStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void) registNewFeatures:(NSArray<UHNewFeature *> *)features inViewController:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    [self registNewFeatures:features inViewController:controller view:controller.view];
}

- (void) registNewFeatures:(NSArray<UHNewFeature *> *)features
          inViewController:(UIViewController *)controller
                      view:(UIView *)view {
    self.target = controller;
    UHNewFeatureModel *featureModel = [self modelInController:controller];
    
    for (UHNewFeature *featureNew in features) {
        BOOL exist = NO;
        for (UHNewFeature *featureStored in featureModel.features) {
            if ([featureNew.identifier isEqualToString:featureStored.identifier]) {
                featureStored.targetFrame = featureNew.targetFrame;
                featureStored.desc = featureNew.desc;
                featureStored.selectorString = featureNew.selectorString;
                featureStored.identifier = featureNew.identifier;
                featureStored.guideMode = featureNew.guideMode;
                featureStored.shouldFire = featureNew.shouldFire;
                featureStored.style = featureNew.style;
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [featureModel.features addObject:featureNew];
        }
    }
    
    
    NSArray *featuresShouldShow = [self featuresSortedByFrameInModel:featureModel];
    
    if (featuresShouldShow.count > 0) {
        self.modelShowing = featureModel;
        if ([(UHNewFeature *) featuresShouldShow.firstObject style] == 0) {
            self.currentGuideView = [UHNewFeatureGuideView showViewAddedToView:view withNewFeatures:featuresShouldShow];
        } else {
            self.currentGuideView = [UHNewFeatureGuideView2 showViewAddedToView:view withNewFeatures:featuresShouldShow];
        }
    }
}

- (void) fireFeature:(UHNewFeature *)feature {
    self.currentGuideView = nil;
    feature.hasShown = YES;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.features];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kNewFeaturesStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (feature.shouldFire && self.target && [self.target respondsToSelector:NSSelectorFromString(feature.selectorString)]) {
        [self.target performSelectorWithArgs:NSSelectorFromString(feature.selectorString)];
    }
}

- (UHNewFeatureModel *) modelInController:(UIViewController *)controller {
    NSString *classNameForViewController = NSStringFromClass([controller class]);
    UHNewFeatureModel *model = [self.features objectForKey:classNameForViewController];
    if (!model) {
        model = [[UHNewFeatureModel alloc] init];
        model.classNameForViewController = classNameForViewController;
        [self.features setObject:model forKey:classNameForViewController];
    }
    return model;
}

- (NSArray *) featuresSortedByFrameInModel:(UHNewFeatureModel *)model {
//    return model.features;
    NSMutableArray *features = @[].mutableCopy;
    for (UHNewFeature *feature in model.features) {
        if (!feature.hasShown && !CGRectIsEmpty(feature.targetFrame)) {
            [features addObject:feature];
        }
    }
    return features;
}

@end
