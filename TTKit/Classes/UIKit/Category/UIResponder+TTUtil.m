//
//  UIResponder+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/25.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIResponder+TTUtil.h"

@implementation UIResponder (TTUtil)

- (id)tt_nextResponderPerform:(NSString *)action object:(id)object userInfo:(NSDictionary *)userInfo {
    return [self.nextResponder tt_nextResponderPerform:action object:object userInfo:userInfo];
}

@end
