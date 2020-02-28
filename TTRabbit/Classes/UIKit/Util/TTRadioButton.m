//
//  TTRadioButton.m
//  TTRabbit
//
//  Created by ZYB on 2020/2/28.
//

#import "TTRadioButton.h"
#import <objc/runtime.h>

static NSString *TTRadioGroupItemsKey = @"items";
static NSString *TTRadioGroupSelectBlockKey = @"select";

@interface TTRadioButton ()

@property (class, nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSMutableDictionary *> *groups;

@property (nonatomic, copy, readwrite) NSString *group;

@end

@implementation TTRadioButton

+ (void)setDidSelectBlock:(TTRadioDidSelectBlock)block forGroup:(NSString *)group {
    if (!block || !group.length) { return; }
    NSMutableDictionary *groupDict = [self groupForId:group];
    groupDict[TTRadioGroupSelectBlockKey] = block;
}

+ (TTRadioButton *)selectedButtonForGroup:(NSString *)group {
    NSMutableDictionary *groupDict = [self groupForId:group];
    NSHashTable *items = groupDict[TTRadioGroupItemsKey];
    for (TTRadioButton *button in items) {
        if (button.isSelected) {
            return button;
        }
    }
    return nil;
}

+ (void)selectButton:(TTRadioButton *)button {
    NSMutableDictionary *groupDict = [TTRadioButton groupForId:button.group];
    NSHashTable *items = groupDict[TTRadioGroupItemsKey];
    TTRadioButton *lastSelected;
    for (TTRadioButton *item in items) {
        if (item.isSelected && item != button) {
            item.selected = NO;
            lastSelected = item;
        }
    }
    button.selected = YES;
    TTRadioDidSelectBlock block = groupDict[TTRadioGroupSelectBlockKey];
    if (block) {
        block(button, lastSelected);
    }
}

- (void)registInGroup:(NSString *)group {
    if (!group.length) { return; }
    NSMutableDictionary *dict = [TTRadioButton groupForId:group];
    NSHashTable *items = dict[TTRadioGroupItemsKey];
    if (!items) {
        items = [NSHashTable weakObjectsHashTable];
        dict[TTRadioGroupItemsKey] = items;
    }
    if ([items containsObject:self]) {
        return;
    }
    self.group = group;
    [items addObject:self];
    
    [self addTarget:[TTRadioButton class] action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [TTRadioButton removeButton:self];
}

+ (void)removeButton:(TTRadioButton *)button {
    if (!button.group.length) {
        return;
    }
    NSDictionary *group = TTRadioButton.groups[button.group];
    NSMutableArray *items = group[TTRadioGroupItemsKey];
    [items removeObject:button];
    if (!items.count) {
        [TTRadioButton.groups setValue:nil forKey:button.group];
    }
}

+ (NSMutableDictionary *)groupForId:(NSString *)groupId {
    if (!groupId.length) { return nil; }
    NSMutableDictionary *dict = [TTRadioButton.groups objectForKey:groupId];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        [TTRadioButton.groups setObject:dict forKey:groupId];
    }
    return dict;
}

+ (NSMutableDictionary<NSString *, NSMutableDictionary *> *)groups {
    NSMutableDictionary *groups = objc_getAssociatedObject(self, _cmd);
    if (!groups) {
        groups = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, groups, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return groups;
}

@end
