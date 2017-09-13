//
//  YHViewController.h
//  WMYHB
//
//  Created by wangjian on 2017/9/12.
//  Copyright © 2017年 wangjian. All rights reserved.
//

#import "MTDBaseViewController.h"

#import "AFHTTPRequestOperation+MMNetwork.h"
#import "MAEmptyInfoView.h"

@protocol MAViewControllerProtocol <NSObject>

@required
- (void)customBackBtn;

@end

@interface YHViewController : MTDBaseViewController<MAViewControllerProtocol>

@property (nonatomic, strong) AFHTTPRequestOperation *currentPageRequest;

/// 页面自定义navigationbar的话 需要对这个属性赋值，否则可能会被empty view遮挡
@property (nonatomic, strong) NSArray *viewsAboveEmptyView;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) BOOL shouldHideNavigationBar;

@property (nonatomic, strong) MAEmptyInfoView *emptyInfoView;

+ (instancetype)controllerLoadFromXib;


- (void)setPopGestrureEnable:(BOOL)enable;


- (BOOL)handleCommonApiError:(NSError *)error;

/*!
 @brief
 取消页面request
 */
- (void)cancelAllrequest;

#pragma mark - simple text info

/*!
 @brief 在页面中心展示文本信息
 
 @param infoStr 需要展示的文本信息
 */
//- (void)showInfoString:(NSString *)infoStr;
//
/*!
 @brief 在页面中心展示文本信息
 
 @param infoStr 需要展示的文本信息
 @param duration 信息展示时长，自动隐藏
 */
//- (void)showInfoString:(NSString *)infoStr withDuration:(NSTimeInterval)duration;

/*!
 @brief 隐藏页面中心文本信息
 */
//- (void)hideInfoString;

#pragma mark - override for subclass

// for sub class override
- (void)onBackAction:(id)sender;
- (void)onViewTapRetryAction:(id)sender;


/// 无相关内容展示
- (void)showNoDataInfo;



@end
