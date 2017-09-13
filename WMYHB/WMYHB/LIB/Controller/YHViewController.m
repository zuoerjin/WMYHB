//
//  YHViewController.m
//  WMYHB
//
//  Created by wangjian on 2017/9/12.
//  Copyright © 2017年 wangjian. All rights reserved.
//

#import "YHViewController.h"

@interface YHViewController ()

@end

@implementation YHViewController

+ (instancetype)controllerLoadFromXib {
    return [[self alloc] initWithNibName:STRING_FROM_CLASS(self) bundle:nil];
}

- (void)dealloc {
    [self cancelAllrequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -30;
    //
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    //    [setBtn setTitle:@"退出登录" forState:0];
    //    setBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    [setBtn setTitleColor:UIColorFromRGB_hex(0x0398ff) forState:0];
    //    setBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [setBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[spacer, [[UIBarButtonItem alloc] initWithCustomView:setBtn]];
    
    
    
    
    //将返回按钮的文字position设置不在屏幕上显示
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (!self.shouldHideNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setPopGestrureEnable:(BOOL)enable {
#if 0
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = enable;
        }
    }
#endif
}

- (void)customBackBtn {
    self.navigationItem.backBarButtonItem = nil;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_backBtn setImage:[UIImage imageNamed:@"ic_nav_back"] forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_backBtn addTarget:self action:@selector(onBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    _backBtn.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItems = @[spacer, [[UIBarButtonItem alloc] initWithCustomView:_backBtn]];
}

- (void)setupQueryData:(NSDictionary *)queryData {
    [super setupQueryData:queryData];
    self.title = [queryData stringValueForKey:kViewControllerTitleKey defaultValue:@""];
}

- (BOOL)handleCommonApiError:(NSError *)error {
    BOOL bHandled = NO;
    //
    //    if (error.code == MTDApiErrorCodeUserTokenErrorHasLoginOnOtherDevice || error.code == MTDApiErrorCodeUserTokenErrorTokenExpired) {
    //        ALERT_FORACCESSTOKENERROR(error.domain);
    //        bHandled = YES;
    //    } else if (error.code == MTDApiErrorCodeUserPowerErrorNoPower) {
    //        NSString *phone = (SERVICEPHONE ? SERVICEPHONE : @"4008115599");
    //
    //        NSString *msg = @"";
    //
    //        if ([phone isEqualToString:@"4008115599"]) {
    //            msg = [NSString stringWithFormat:@"%@ %@", error.domain, phone];
    //        } else {
    //            msg = [NSString stringWithFormat:@"%@ %@(%@)", error.domain, phone, SERVICENAME];
    //        }
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"不,谢谢" otherButtonTitles:@"拨打电话", nil];
    //
    //        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
    //            if (buttonIndex == 1) {
    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phone]]];
    //            }
    //        }];
    //        bHandled = YES;
    //    } else if (error.code == MTDApiErrorCodeBadNetworking) {
    //        [self showBadNetworkInfo];
    //        bHandled = YES;
    //    } else if (error.code == MTDApiErrorCodeNoNetworking) {
    //        [self showNoNetworkInfo];
    //        bHandled = YES;
    //    } else if (error.code == MTDApiErrorCodeConnectFailed) {
    //        [self showServerErrorInfo];
    //        bHandled = YES;
    //    } else if (error.code == MTDApiErrorCodeNoMoreData) {
    //        [self showEmptyInfoViewWithType:EmptyInfoViewTypeEmpty infoText:error.domain subinfoText:nil tapRetryAction:NULL];
    //        bHandled = YES;
    //    }
    
    return bHandled;
}

//- (void)showInfoString:(NSString *)infoStr {
//    if (!_infoLabel) {
//        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10 * 2, SCREEN_HEIGHT)];
//        _infoLabel.backgroundColor = [UIColor clearColor];
//        _infoLabel.numberOfLines = 0;
//        _infoLabel.textAlignment = NSTextAlignmentCenter;
//        _infoLabel.preferredMaxLayoutWidth = _infoLabel.width;
//        _infoLabel.font = [UIFont systemFontOfSize:18];
//        _infoLabel.textColor = [UIColor grayColor];
//        _infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self.view addSubview:_infoLabel];
//    }
//    _infoLabel.text = infoStr;
//    [self.view bringSubviewToFront:_infoLabel];
//}
//
//- (void)showInfoString:(NSString *)infoStr withDuration:(NSTimeInterval)duration {
//    [self showInfoString:infoStr];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self hideInfoString];
//    });
//}
//
//- (void)hideInfoString {
//    if (_infoLabel) {
//        _infoLabel.hidden = YES;
//        [_infoLabel removeFromSuperview];
//        _infoLabel = nil;
//    }
//}

- (void)cancelAllrequest {
    if (self.currentPageRequest) {
        [self.currentPageRequest setUICallback:NULL];
        [self.currentPageRequest cancel];
        self.currentPageRequest = nil;
    }
}

#pragma mark - actions

- (void)onBackAction:(id)sender {
    [self cancelAllrequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/// 无相关内容展示
- (void)showNoDataInfo {
    [self showEmptyInfoViewWithType:EmptyInfoViewTypeEmpty infoText:MTD_STRING(@"no_data") subinfoText:nil tapRetryAction:NULL];
}



- (void)showEmptyInfoViewWithType:(EmptyInfoViewType)type infoText:(NSString *)infoText subinfoText:(NSString *)subInfoText tapRetryAction:(InfoViewTapAction)action {
    
    [self.emptyInfoView updateInfoWithViewType:type infoText:infoText subInfoText:subInfoText tapActionHandler:action];
    [self.view bringSubviewToFront:self.emptyInfoView];
    
    for (UIView *topView in self.viewsAboveEmptyView) {
        if (topView.superview == self.view) {
            [self.view bringSubviewToFront:topView];
        }
    }
    self.emptyInfoView.hidden = NO;
}

- (MAEmptyInfoView *)emptyInfoView {
    
    __weak __typeof(self)weakSelf = self;
    
    if (!_emptyInfoView) {
        _emptyInfoView = [MAEmptyInfoView viewFromNib];
        _emptyInfoView.frame = self.view.bounds;
        _emptyInfoView.backgroundColor = [UIColor clearColor];
        
        _emptyInfoView.infotap = ^(MAEmptyInfoView *infoView) {
            
            [weakSelf onViewTapRetryAction:nil];
        };
        _emptyInfoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_emptyInfoView];
    }
    
    return _emptyInfoView;
}


@end
