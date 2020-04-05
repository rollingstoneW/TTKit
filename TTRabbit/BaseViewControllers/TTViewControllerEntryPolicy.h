//
//  TTViewControllerEntryPolicy.h
//  TTRabbit
//
//  Created by ZYB on 2020/2/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTEntryPolicyCompletion)(BOOL isDenied);

@interface TTViewControllerEntryPolicy : NSObject

@property (nonatomic, assign) BOOL isPermitted;
@property (nonatomic, assign) BOOL blockWhenDenied;

@property (nonatomic, strong, nullable) TTEntryPolicyCompletion completion;

- (void)tryWithCompletion:(TTEntryPolicyCompletion)completion;;

@end

@interface UIViewController (TTEntryPolicy)

@property (nonatomic, strong, nullable) NSArray *tt_entryPolicies; // 能够进入的条件

- (void)tt_tryPoliciesWithCompletion:(TTEntryPolicyCompletion)completion;

@end

NS_ASSUME_NONNULL_END
