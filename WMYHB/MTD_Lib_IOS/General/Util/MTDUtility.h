//
//  MTDUtility.h
//  MTDLib
//
//  Created by sci99 on 15/5/27.
//  Copyright (c) 2015年 MTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MTDGlobal.h"
#import "MTDAdaptor.h"
#import <UIKit/UIKit.h>

@interface MTDUtility : NSObject

@property (nonatomic, weak) UINavigationController *currentNavigationController;
@property (nonatomic, readonly) UIViewController *currentTopViewController;

+ (instancetype)sharedInstance;

+ (UIWindow *)keyAppWindow;
+ (CGSize)mainScreenSize;

/// 系统doc目录
+ (NSString *)documentDirString;

// app version info
+ (NSString *)appVersionString;

// 通用参数
+ (NSDictionary *)commonPostDicForParams:(NSDictionary *)params;

+ (NSDictionary *)commonPostDicForParams:(NSDictionary *)params signatureKey:(NSString *)signKey;

// 参数解析
+ (NSDictionary *)generateParamsFromParameterString:(NSString *)paramStr;

// aop
- (void)setupAOPHooks;

//签名字典
+ (NSMutableDictionary *)postDicByParameters:(NSMutableDictionary *)parametersDic withPublickey:(NSString *)publickey signatureKey:(NSString *)signatureKey;

//hmac加密
+ (NSString *)hmac_sha1:(NSString*)key text:(NSString*)text;

//获取UUID
+ (NSString*)getUUID;

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier;
- (void)showControllerWithSegueIdentifier:(NSString *)identifier queryData:(NSDictionary *)queryData;
- (void)pushControllerWithIdentifier:(NSString *)identifier queryData:(NSDictionary *)queryData;
- (void)presentControllerWithIdentifier:(NSString *)identifier queryData:(NSDictionary *)queryData;

// date
- (NSDate *)dateFromTimestrampString:(NSString *)timestramp;
- (NSString *)commontDateStringFromTimestrampString:(NSString *)timestramp;
- (NSString *)dateStringFromTimestrampString:(NSString *)timestramp forDateFormatter:(NSString *)fmt;

// date formatter
- (NSString *)dateStringWithFormatter:(NSString *)fmt fromDate:(NSDate *)date;

@end
