//
//  TTCountdownButton.m
//  TTKit
//
//  Created by rollingstoneW on 2018/10/10.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTCountdownButton.h"
#import "UIColor+YYAdd.h"
#import "UIImage+YYAdd.h"

const CGFloat TTCountdownHalfHeightCornerRadius = 0;
const UIControlState TTCountdownStateStarted = UIControlStateDisabled;
const UIControlState TTCountdownStateFinished = UIControlStateNormal;

@interface TTCountdownTimer ()

@property (nonatomic, assign) NSInteger timeLeft;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TTCountdownTimer

- (void)start {
    self.timeLeft = self.totalTime;

    [self invalidateTimer];
    [self startTime];
}

- (void)finish {
    if (self.finishedlock) self.finishedlock();
    if (self.countdownBlock) self.countdownBlock(0);

    [self invalidate];
}

- (void)invalidate {
    self.finishedlock = nil;
    self.countdownBlock = nil;

    [self invalidateTimer];
}

- (void)startTime {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFire {
    if (self.timeLeft == 0) {
        [self.owner setupUIForStateFinished];
        [self finish];
        return;
    }
    [self.owner updateTimeLeft:self.timeLeft];
    if (self.countdownBlock) self.countdownBlock(self.timeLeft);
    self.timeLeft --;
}

@end

@implementation TTCountdownButton
@synthesize delegate;

+ (instancetype)buttonWithTotalTime:(NSInteger)time {
    return [self buttonWithTotalTime:time titleSuffix:@"s后重新发送" finishedTitle:@"重新发送"];
}

+ (instancetype)buttonWithTotalTime:(NSInteger)time titleSuffix:(NSString *)suffix finishedTitle:(NSString *)title {
    TTCountdownButton *button = [TTCountdownButton buttonWithType:UIButtonTypeCustom];
    button.finishedTitle = title;
    button.titleSuffix = suffix;
    [button setup];
    button.delegate.totalTime = time;
    return button;
}

- (void)start {
    if (self.delegate.totalTime == 0) {
        return;
    }
    [self.delegate start];
    [self setupUIForStateStarted];
}

- (void)startWithBlockCountdown:(void (^)(NSInteger))countdown finished:(dispatch_block_t)finished {
    self.delegate.countdownBlock = countdown;
    self.delegate.finishedlock = finished;
    [self start];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectGetHeight(self.bounds)) {
        if (self.cornerRadius == TTCountdownHalfHeightCornerRadius) {
            self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
        } else {
            self.layer.cornerRadius = self.cornerRadius;
        }
    }
}

- (void)dealloc {
    if (self.invalidDelegateWhenDealloc) {
        [self.delegate invalidate];
    }
}

- (void)setup {
    self.delegate = [TTCountdownTimer new];
    self.delegate.owner = self;

    self.cornerRadius = TTCountdownHalfHeightCornerRadius;
    self.adjustsImageWhenDisabled = NO;
    self.adjustsImageWhenHighlighted = NO;
    self.invalidDelegateWhenDealloc = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.layer.masksToBounds = YES;

    [self setTitleColor:[UIColor colorWithHexString:@"0xAAAFB3"] forState:TTCountdownStateStarted];
    [self setTitleColor:[UIColor whiteColor] forState:TTCountdownStateFinished];

    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xF2F2F2"]] forState:TTCountdownStateStarted];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x008FFF"]] forState:TTCountdownStateFinished];

    [self setupUIForStateFinished];
}

- (void)updateTimeLeft:(NSInteger)timeLeft {
    [self setTitle:[NSString stringWithFormat:@"%ld%@", (long)timeLeft, self.titleSuffix] forState:UIControlStateNormal];
}

- (void)setupUIForStateStarted {
    self.enabled = NO;
}

- (void)setupUIForStateFinished {
    [self setTitle:self.finishedTitle forState:UIControlStateNormal];
    self.enabled = YES;
}

@end
