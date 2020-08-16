//
//  TTCategories.h
//  OCTest
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#ifndef TTCategories_h
#define TTCategories_h

#if __has_include(<YYCategories/YYCategories.h>)
#import <YYCategories/YYCategories.h>
#elif __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKitMacro.h>
#import <YYKit/NSObject+YYAdd.h>
#import <YYKit/NSObject+YYAddForKVO.h>
#import <YYKit/NSObject+YYAddForARC.h>
#import <YYKit/NSData+YYAdd.h>
#import <YYKit/NSString+YYAdd.h>
#import <YYKit/NSArray+YYAdd.h>
#import <YYKit/NSDictionary+YYAdd.h>
#import <YYKit/NSDate+YYAdd.h>
#import <YYKit/NSNumber+YYAdd.h>
#import <YYKit/NSNotificationCenter+YYAdd.h>
#import <YYKit/NSKeyedUnarchiver+YYAdd.h>
#import <YYKit/NSTimer+YYAdd.h>
#import <YYKit/NSBundle+YYAdd.h>
#import <YYKit/NSThread+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>
#import <YYKit/UIImage+YYAdd.h>
#import <YYKit/UIControl+YYAdd.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIScrollView+YYAdd.h>
#import <YYKit/UITableView+YYAdd.h>
#import <YYKit/UITextField+YYAdd.h>
#import <YYKit/UIScreen+YYAdd.h>
#import <YYKit/UIDevice+YYAdd.h>
#import <YYKit/UIApplication+YYAdd.h>
#import <YYKit/UIFont+YYAdd.h>
#import <YYKit/UIBezierPath+YYAdd.h>
#import <YYKit/CALayer+YYAdd.h>
#import <YYKit/YYCGUtilities.h>
#endif

#if __has_include(<TTCategories/TTCategories.h>)

#import <TTCategories/TTMacros.h>
#import <TTCategories/UIView+TTUtil.h>
#import <TTCategories/UIView+TTBorder.h>
#import <TTCategories/UILabel+TTUtil.h>
#import <TTCategories/UIWindow+TTUtil.h>
#import <TTCategories/UIButton+TTImagePosition.h>
#import <TTCategories/UIButton+TTIndicator.h>
#import <TTCategories/UIButton+TTTouchArea.h>
#import <TTCategories/UIButton+TTActionThrottle.h>
#import <TTCategories/UIImage+TTUtil.h>
#import <TTCategories/UIImage+TTResource.h>
#import <TTCategories/UIViewController+TTUtil.h>
#import <TTCategories/UINavigationController+TTUtil.h>
#import <TTCategories/UITableView+TTUtil.h>
#import <TTCategories/UITableViewCell+TTUtil.h>
#import <TTCategories/UIResponder+TTUtil.h>
#import <TTCategories/UIScrollView+TTUtil.h>
#import <TTCategories/UIDevice+TTUtil.h>
#import <TTCategories/TTUIKitFactory.h>
#import <TTCategories/NSBundle+TTUtil.h>
#import <TTCategories/NSString+TTUtil.h>
#import <TTCategories/NSObject+TTUtil.h>
#import <TTCategories/NSDate+TTUtil.h>
#import <TTCategories/NSDateFormatter+TTUtil.h>
#import <TTCategories/NSThread+TTUtil.h>
#import <TTCategories/NSArray+TTUtil.h>
#import <TTCategories/NSDictionary+TTUtil.h>
#import <TTCategories/NSObject+TTSingleton.h>
#import <TTCategories/NSFileManager+TTUtil.h>
//#import <TTCategories/NSURLComponents+TTUtil.h>

#else

#import "TTMacros.h"
#import "UIView+TTUtil.h"
#import "UIView+TTBorder.h"
#import "UILabel+TTUtil.h"
#import "UIWindow+TTUtil.h"
#import "UIButton+TTImagePosition.h"
#import "UIButton+TTIndicator.h"
#import "UIButton+TTTouchArea.h"
#import "UIButton+TTActionThrottle.h"
#import "UIImage+TTUtil.h"
#import "UIImage+TTResource.h"
#import "UIViewController+TTUtil.h"
#import "UINavigationController+TTUtil.h"
#import "UITableView+TTUtil.h"
#import "UITableViewCell+TTUtil.h"
#import "UIResponder+TTUtil.h"
#import "UIScrollView+TTUtil.h"
#import "UIDevice+TTUtil.h"
#import "TTUIKitFactory.h"
#import "NSBundle+TTUtil.h"
#import "NSString+TTUtil.h"
#import "NSObject+TTUtil.h"
#import "NSDate+TTUtil.h"
#import "NSDateFormatter+TTUtil.h"
#import "NSThread+TTUtil.h"
#import "NSArray+TTUtil.h"
#import "NSDictionary+TTUtil.h"
#import "NSObject+TTSingleton.h"
//#import "NSURLComponents+TTUtil.h"

#endif

#endif /* TTCategories_h */
