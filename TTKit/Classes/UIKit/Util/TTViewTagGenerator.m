//
//  TTViewTagGenerator.m
//  TTKit
//
//  Created by rollingstoneW on 2019/3/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTViewTagGenerator.h"

const NSInteger kBaseViewTag = 1000;
static NSInteger kGeneratedCurrentViewTag = 1000;
static NSMutableDictionary<NSString *,NSMutableSet *>* kViewTagStorage;
NSInteger kGeneratorViewTag() {
    return kGeneratedCurrentViewTag++;
}
void kStoreViewTagForKey(NSInteger tag, NSString *key) {
    if (!kViewTagStorage) {
        kViewTagStorage = [NSMutableDictionary dictionary];
    }
    key = key.length ? key : @"default";
    NSMutableSet *tagSet = kViewTagStorage[key];
    if (!tagSet) {
        tagSet = [NSMutableSet set];
        kViewTagStorage[key] = tagSet;
    }
    [tagSet addObject:@(tag)];
}

NSSet * kViewTagsForKey(NSString *key) {
    return  [kViewTagStorage[key.length ? key : @"default"] copy];
}

void kCleanViewTagsForKey(NSString *key) {
    kViewTagStorage[key.length ? key : @"default"] = nil;
    if (!kViewTagStorage.count) {
        kViewTagStorage = nil;
    }
}

