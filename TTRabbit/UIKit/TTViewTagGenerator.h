//
//  TTViewTagGenerator.h
//  TTKit
//
//  Created by rollingstoneW on 2019/3/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

// 基础tag，1000
FOUNDATION_EXTERN const NSInteger kBaseViewTag;
// 随机生成tag，每次+1
FOUNDATION_EXTERN NSInteger kGeneratorViewTag(void);
// 以key存tag
FOUNDATION_EXTERN void kStoreViewTagForKey(NSInteger tag, NSString *key);
// 以key取tag
FOUNDATION_EXTERN NSSet * kViewTagsForKey(NSString *key);
// 以key删tag
FOUNDATION_EXTERN void kCleanViewTagsForKey(NSString *key);
