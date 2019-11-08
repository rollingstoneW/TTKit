//
//  AVAudioPlayer+SafeKit.h
//  TTRabbit
//
//  Created by rollingstoneW on 2019/7/29.
//

#import <AVFoundation/AVFoundation.h>
#import "TTSafeKitEntry.h"

NS_ASSUME_NONNULL_BEGIN

/**
 AVAudioPlayer和AVAudioRecorder的delegate修饰符为assign，如果delegate先于他们释放，delegate就会，再访问delegate就会造成闪退。
 这个类别用来修复delegate野指针问题。
 */
@interface AVFoundationSafeKit : NSObject <TTSafeKitEntry>

@end

NS_ASSUME_NONNULL_END
