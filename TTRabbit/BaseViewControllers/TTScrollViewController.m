//
//  TTScrollViewController.m
//  TTRabbit
//
//  Created by rollingstoneW on 2020/3/1.
//

#import "TTScrollViewController.h"

@interface TTScrollViewController ()

@end

@implementation TTScrollViewController
@dynamic view;

- (void)loadView {
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.showsVerticalScrollIndicator = NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
