//
//  TTCategoryMenuBarOptionItem+TTPrivate.m
//  TTRabbit
//
//  Created by 滚石 on 2020/3/28.
//

#import "TTCategoryMenuBarOptionItem+TTPrivate.h"

@implementation TTCategoryMenuBarOptionItem (TTPrivate)

- (BOOL)hasSelectedChild {
    if (self.childOptions.count) {
        for (TTCategoryMenuBarOptionItem *child in self.childOptions) {
            if ([child isSelfSelected]) {
                return YES;
            }
            if ([child hasSelectedChild]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)loadSelectedChild {
    if (self.childOptions.count) {
        for (TTCategoryMenuBarOptionItem *child in self.childOptions) {
            if ([child loadSelectedChild]) {
                [self.selectedChildOptions addObject:child];
            }
        }
        return self.selectedChildOptions.count;
    } else {
        return [self isSelfSelected];
    }
}

- (BOOL)isSelfSelected {
    if ([self respondsToSelector:@selector(isSelected)]) {
        return [(id)self isSelected];
    }
    return NO;
}

- (void)clearSelectedChildren {
    [self.selectedChildOptions removeAllObjects];
    self.selectedChildOptions = nil;
    for (TTCategoryMenuBarOptionItem *child in self.childOptions) {
        [child clearSelectedChildren];
    }
}

- (void)reset {
    [self resetFrom:nil];
}

- (void)resetFrom:(TTCategoryMenuBarOptionItem *)item {
    // 如果选中的数据和自己相同，则不取消自己的选中状态
    if ((item.relatedItem && item.relatedItem == self) || (self.relatedItem && self.relatedItem == item)) {
        return;
    }
    if ([self respondsToSelector:@selector(setIsSelected:)]) {
        [(id)self setIsSelected:NO];
    }
    self.isChildrenAllSelected = NO;
    [self.selectedChildOptions removeAllObjects];
    for (TTCategoryMenuBarOptionItem *child in self.childOptions) {
        [child resetFrom:item];
    }
}

@end
