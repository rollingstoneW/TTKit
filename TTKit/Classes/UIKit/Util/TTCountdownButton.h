//
//  TTCountdownButton.h
//  TTKit
//
//  Created by rollingstoneW on 2018/10/10.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

// 圆角默认是高度的一半
FOUNDATION_EXTERN const CGFloat TTCountdownHalfHeightCornerRadius;
FOUNDATION_EXTERN const UIControlState TTCountdownStateStarted;
FOUNDATION_EXTERN const UIControlState TTCountdownStateFinished;

@class TTCountdownTimer;
@protocol TTCountdownProtocol <NSObject>

@property (nonatomic, strong) TTCountdownTimer *delegate;

- (void)updateTimeLeft:(NSInteger)timeLeft;
- (void)setupUIForStateFinished;

@end

@interface TTCountdownTimer : NSObject

@property (nonatomic, assign) NSInteger totalTime;

@property (nonatomic, copy)   void(^countdownBlock)(NSInteger timeLeft);
@property (nonatomic, copy)   dispatch_block_t finishedlock;

@property (nonatomic, weak)   UIView<TTCountdownProtocol>* owner;

- (void)invalidate; // 销毁计数器

@end

@interface TTCountdownButton : UIButton <TTCountdownProtocol>

@property (nonatomic, assign) BOOL invalidDelegateWhenDealloc; // 销毁的时候是否停止计数，YES

@property (nonatomic, assign) CGFloat cornerRadius; // 默认是高度一半

@property (nonatomic, copy)   NSString *titleSuffix;
@property (nonatomic, copy)   NSString *finishedTitle;

+ (instancetype)buttonWithTotalTime:(NSInteger)time; //suffix:@"s后重新发送" finishedTitle:@""
+ (instancetype)buttonWithTotalTime:(NSInteger)time titleSuffix:(NSString *)suffix finishedTitle:(NSString *)title;

- (void)start;

- (void)startWithBlockCountdown:(void(^)(NSInteger timeLeft))countdown finished:(dispatch_block_t)finished;

@end
