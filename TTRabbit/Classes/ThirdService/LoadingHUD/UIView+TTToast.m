//
//  UIView+TTToast.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/5.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIView+TTToast.h"
#import "MBProgressHUD.h"
#import "UIImage+TTResource.h"
#import "NSBundle+TTUtil.h"

static NSTimeInterval const TTToastDefaultHideDelay = 1.5;

@implementation UIView (TTToast)

- (__kindof UIView *)tt_showLoadingToast:(NSString *)toast {
    [self tt_hideToasts];
    MBProgressHUD *hud = [self customCommonHUD];
    hud.label.text = toast;
    return hud;
}
- (__kindof UIView *)tt_showLoadingToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [self tt_showLoadingToast:toast];
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

- (__kindof UIView *)tt_showErrorToast:(NSString *)toast {
    return [self tt_showErrorToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}
- (__kindof UIView *)tt_showErrorToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self tt_showCustomToast:toast
                              image:[UIImage tt_imageNamed:@"icon_toast_error" bundle:[NSBundle tt_bundleWithName:@"TTRabbitBundle"]]
                     hideAfterDelay:delay];
}
- (__kindof UIView *)tt_showSuccessToast:(NSString *)toast {
    return [self tt_showSuccessToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}
- (__kindof UIView *)tt_showSuccessToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self tt_showCustomToast:toast
                              image:[UIImage tt_imageNamed:@"icon_toast_success" bundle:[NSBundle tt_bundleWithName:@"TTRabbitBundle"]]
                     hideAfterDelay:delay];
}
- (__kindof UIView *)tt_showWarningToast:(NSString *)toast {
    return [self tt_showWarningToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}
- (__kindof UIView *)tt_showWarningToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self tt_showCustomToast:toast
                              image:[UIImage tt_imageNamed:@"icon_toast_warning" bundle:[NSBundle tt_bundleWithName:@"TTRabbitBundle"]]
                     hideAfterDelay:delay];
}

- (__kindof UIView *)tt_showCustomToast:(NSString *)toast image:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay {
    [self tt_hideToasts];
    MBProgressHUD *hud = [self customCommonHUD];
    if (image) {
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.mode = MBProgressHUDModeCustomView;
    }
    hud.label.text = toast;
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

- (UIView *)tt_showTextToast:(NSString *)toast {
    return [self tt_showTextToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}

- (UIView *)tt_showTextToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    [self tt_hideToasts];
    MBProgressHUD *hud = [self customCommonHUD];
    hud.label.text = toast;
    hud.label.numberOfLines = 0;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

- (MBProgressHUD *)customCommonHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.6];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.font = [UIFont systemFontOfSize:14];
    return hud;
}

- (void)tt_hideToasts {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
