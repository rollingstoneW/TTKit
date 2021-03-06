//
//  TTBaseViewControllers.h
//  OCTest
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#ifndef TTBaseViewControllers_h
#define TTBaseViewControllers_h

#if __has_include(<TTBaseViewControllers/TTBaseViewControllers.h>)

#import <TTBaseViewControllers/TTViewController.h>
#import <TTBaseViewControllers/TTViewController+LifeCycle.h>
#import <TTBaseViewControllers/TTViewController+EntryPolicy.h>
#import <TTBaseViewControllers/TTNavigationController.h>
#import <TTBaseViewControllers/TTScrollViewController.h>
#import <TTBaseViewControllers/TTTabBarController.h>
#import <TTBaseViewControllers/TTTableViewController.h>
#import <TTBaseViewControllers/TTViewControllerRouter.h>
#import <TTBaseViewControllers/TTNavigationControllerChildProtocol.h>
#import <TTBaseViewControllers/TTTabBarControllerChildProtocol.h>
#import <TTBaseViewControllers/TTWebViewController.h>

#else

#import "TTViewController.h"
#import "TTViewController+LifeCycle.h"
#import "TTViewController+EntryPolicy.h"
#import "TTNavigationController.h"
#import "TTScrollViewController.h"
#import "TTTabBarController.h"
#import "TTTableViewController.h"
#import "TTViewControllerRouter.h"
#import "TTNavigationControllerChildProtocol.h"
#import "TTTabBarControllerChildProtocol.h"
#import "TTWebViewController.h"

#endif

#endif /* TTBaseViewControllers_h */
