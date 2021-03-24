//
//  TTViewController+EntryPolicy.h
//  TTRabbit
//
//  Created by Rabbit on 2021/3/23.
//

#import "TTViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTEntryPolicyCompletion)(BOOL isDenied);

@interface TTViewControllerEntryPolicy : NSObject

@property (nonatomic, assign) BOOL isPermitted;
@property (nonatomic, assign) BOOL blockWhenDenied;

@property (nonatomic, strong, nullable) TTEntryPolicyCompletion completion;

- (void)tryWithCompletion:(TTEntryPolicyCompletion)completion;;

@end

@interface TTViewController (EntryPolicy)

@property (nonatomic, copy, nullable) NSArray *entryPolicies; // 能够进入的条件

- (void)tryPoliciesWithCompletion:(TTEntryPolicyCompletion)completion;

@end

NS_ASSUME_NONNULL_END
