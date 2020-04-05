//
//  UIResponder+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/25.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIResponder+TTUtil.h"

@implementation UIResponder (TTUtil)

- (id _Nullable)tt_nextResponderPerform:(NSString *)action
                                 object:(id _Nullable)object
                               userInfo:(NSDictionary * _Nullable)userInfo {
    return [self.nextResponder tt_nextResponderPerform:action object:object userInfo:userInfo];
}

@end
