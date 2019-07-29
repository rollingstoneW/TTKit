//
//  AVAudioPlayer+SafeKit.m
//  TTRabbit
//
//  Created by weizhenning on 2019/7/29.
//

#import "AVFoundationSafeKit.h"
#import "NSObject+TTUtil.h"

@implementation AVFoundationSafeKit
@synthesize description;

+ (void)makeSafe {
    [[AVAudioPlayer class] autoreleaseAssignedPropertyPointer:NSStringFromSelector(@selector(delegate))];
    [[AVAudioRecorder class] autoreleaseAssignedPropertyPointer:NSStringFromSelector(@selector(delegate))];
}

@end
