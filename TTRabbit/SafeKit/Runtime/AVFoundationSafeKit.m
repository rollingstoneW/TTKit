//
//  AVAudioPlayer+SafeKit.m
//  TTRabbit
//
//  Created by rollingstoneW on 2019/7/29.
//

#import "AVFoundationSafeKit.h"
#import "NSObject+TTUtil.h"

@implementation AVFoundationSafeKit
@synthesize description;

+ (void)makeSafe {
    [[AVAudioPlayer class] tt_autoreleaseAssignedPropertyPointer:NSStringFromSelector(@selector(delegate))];
    [[AVAudioRecorder class] tt_autoreleaseAssignedPropertyPointer:NSStringFromSelector(@selector(delegate))];
}

@end
