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

- (__kindof UIView *)showLoadingToast:(NSString *)toast {
    [self hideToasts];
    MBProgressHUD *hud = [self customCommonHUD];
    hud.label.text = toast;
    return hud;
}
- (__kindof UIView *)showLoadingToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [self showLoadingToast:toast];
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

- (__kindof UIView *)showErrorToast:(NSString *)toast {
    return [self showErrorToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}
- (__kindof UIView *)showErrorToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self showCustomToast:toast
                           image:[UIImage tt_imageNamed:@"icon_toast_error" bundle:[NSBundle tt_bundleWithName:@"TTKit"]]
                  hideAfterDelay:delay];
}
- (__kindof UIView *)showSuccessToast:(NSString *)toast {
    return [self showSuccessToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}
- (__kindof UIView *)showSuccessToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self showCustomToast:toast
                           image:[UIImage tt_imageNamed:@"icon_toast_success" bundle:[NSBundle tt_bundleWithName:@"TTKit"]]
                  hideAfterDelay:delay];
}
- (__kindof UIView *)showWarningToast:(NSString *)toast {
    return [self showWarningToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}
- (__kindof UIView *)showWarningToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self showCustomToast:toast
                           image:[UIImage tt_imageNamed:@"icon_toast_warning" bundle:[NSBundle tt_bundleWithName:@"TTKit"]]
                  hideAfterDelay:delay];
}

- (__kindof UIView *)showCustomToast:(NSString *)toast image:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay {
    [self hideToasts];
    MBProgressHUD *hud = [self customCommonHUD];
    if (image) {
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.mode = MBProgressHUDModeCustomView;
    }
    hud.label.text = toast;
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

- (UIView *)showTextToast:(NSString *)toast {
    return [self showTextToast:toast hideAfterDelay:TTToastDefaultHideDelay];
}

- (UIView *)showTextToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    [self hideToasts];
    MBProgressHUD *hud = [self customCommonHUD];
    hud.label.text = toast;
    hud.label.numberOfLines = 2;
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

- (void)hideToasts {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
