//
//  MMBaseModel.h
//  MTDMetal
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDNetworkManager.h"
#import "NSManagedObject+MTD.h"
#import "MTDCoredataManager.h"

// 用户登录信息过期、失效之后统一发送这个通知
// notification object 对象为MTDBaseModel单例对象
// notification user info 存放具体的错误信息、接口返回信息 相关字段key定义
extern NSString *const kMTDUserTokenErrorNotification;

// userinfo -- > NSError
extern NSString *const KMTDUserTokenErrorUserInfoKeyErrorValue;

// userinfo -- > MTDApiRetObj
extern NSString *const kMTDUserTokenErrorUserInfoKeyReturnObjValue;

// 通用网络、api返回错误
typedef NS_ENUM(NSInteger, MTDApiErrorCode) {
    MTDApiErrorCodeNoNetworking = kCFURLErrorNotConnectedToInternet,
    MTDApiErrorCodeBadNetworking = kCFURLErrorTimedOut,
    MTDApiErrorCodeConnectFailed = kCFURLErrorCannotConnectToHost,
    
    // 该文章已在其他设备上查看过
    MTDApiErrorCodeArticalHasBeenReadOnOtherDevice = 1007,
    
    // user token error
    MTDApiErrorCodeUserTokenErrorTokenExpired = 1012,
    MTDApiErrorCodeUserTokenErrorHasLoginOnOtherDevice = 1011,
    MTDApiErrorCodeUserHasNotLoginYet = 1024,
    
    // 无法查看更多相关信息
    MTDApiErrorCodeNoMoreData = 1035,
    
    // user auth power 用户权限相关
    MTDApiErrorCodeUserPowerErrorNoPower = 1013,
    
    // 用户手机绑定情况
    MTDApiErrorCodeUserNeedBindPhone = 1062,
};

@interface MTDApiRetObj : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) id infoObj;
@property (nonatomic, strong) id originObj;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, readonly) NSError *error;

- (instancetype)initWithReturnDicObj:(NSDictionary *)dic;

+ (MTDApiRetObj *)processResultDic:(NSDictionary *)dic error:(NSError **)error;

@end

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

@interface MTDBaseModel : NSObject

@property (nonatomic, strong) MTDNetworkManager *networkManager; // default [MTDNetworkManager sharedManager]
@property (nonatomic, readonly) NSManagedObjectContext *threadMOC;
@property (nonatomic, assign) BOOL tokenHasExpired;
@property (nonatomic, assign) BOOL hasLoginOnOtherDevice;
@property (nonatomic, strong) NSError *lastUserTokenError;
@property (nonatomic, copy) NSString *apiHostUrl; // 自定义host url
@property (nonatomic, assign) BOOL shouldIgnoreCommonApiParams; // 是否需要忽略公共参数  default NO
@property (nonatomic, assign) BOOL shouldIgnoreParamsSign; // 是否忽略参数签名步骤

+ (instancetype)sharedModel;
+ (instancetype)model;

// override for subclass
- (NSDictionary *)configureModelParams:(NSDictionary *)params;

// callback
- (void)callbackUIBlockWithError:(NSError *)error resultData:(id)resultData pharsedData:(id)pharsedData operation:(AFHTTPRequestOperation *)operation;
- (void)callbackUIFailedWithError:(NSError *)error operation:(AFHTTPRequestOperation *)opt;

// get methods
- (AFHTTPRequestOperation *)getRequestWithParams:(NSDictionary *)params
                                         apiPath:(NSString *)apiPath
                                 completeHandler:(ApiCompleteHandler)handler
                               successAFCallback:(AFHttpOperationSuccessHandler)success;

- (AFHTTPRequestOperation *)getRequestWithParams:(NSDictionary *)params
                                         apiPath:(NSString *)apiPath
                                 completeHandler:(ApiCompleteHandler)handler
                               successAFCallback:(AFHttpOperationSuccessHandler)success
                                failedAFCallback:(AFHttpOperationFailedHandler)failed;

// post methods
- (AFHTTPRequestOperation *)postRequestWithParams:(NSDictionary *)params
                                          apiPath:(NSString *)apiPath
                                  completeHandler:(ApiCompleteHandler)handler
                                successAFCallback:(AFHttpOperationSuccessHandler)success;

- (AFHTTPRequestOperation *)postRequestWithParams:(NSDictionary *)params
                                          apiPath:(NSString *)apiPath
                                  completeHandler:(ApiCompleteHandler)handler
                                successAFCallback:(AFHttpOperationSuccessHandler)success
                                 failedAFCallback:(AFHttpOperationFailedHandler)failed;

@end
