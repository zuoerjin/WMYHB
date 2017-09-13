//
//  MMNetworkManager.h
//  MTDMetal
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation+MMNetwork.h"

extern NSString *const kNetworkResumeAviliableNotification;
extern NSString *const kShouldIgnoreCommonParamsKey;
extern NSString *const kShouldIgnoreParamsSignKey;

@interface MTDNetworkManager : NSObject
@property (readonly) BOOL isNetworkAviliable;

+ (instancetype)sharedManager;
+ (BOOL)hasNetwork;
- (void)startNetworkAviliableNotifier;

// get methods
- (AFHTTPRequestOperation *)getRequestWithParams:(NSDictionary *)params
                                         apiPath:(NSString *)apiPath
                                 completeHandler:(ApiCompleteHandler)handler
                               successAFCallback:(AFHttpOperationSuccessHandler)success
                                failedAFCallback:(AFHttpOperationFailedHandler)failed;

// 更新v2.0: 支持自定义host url
- (id)getWithParams:(NSDictionary *)params
         apiHostUrl:(NSString *)hostUrl
            apiPath:(NSString *)apiPath
    completeHandler:(ApiCompleteHandler)handler
  successAFCallback:(AFHttpOperationSuccessHandler)success
   failedAFCallback:(AFHttpOperationFailedHandler)failed;

// post methods
- (AFHTTPRequestOperation *)postRequestWithParams:(NSDictionary *)params
                                          apiPath:(NSString *)apiPath
                                  completeHandler:(ApiCompleteHandler)handler
                                successAFCallback:(AFHttpOperationSuccessHandler)success
                                 failedAFCallback:(AFHttpOperationFailedHandler)failed;

// 更新v2.0: 支持自定义host url
- (id)postRequestWithParams:(NSDictionary *)params
                 apiHostUrl:(NSString *)hostUrl
                    apiPath:(NSString *)apiPath
            completeHandler:(ApiCompleteHandler)handler
          successAFCallback:(AFHttpOperationSuccessHandler)success
           failedAFCallback:(AFHttpOperationFailedHandler)failed;

// override for subclass
- (NSString *)apiServerUrl;

- (NSDictionary *)configureUserTokenParams:(NSDictionary *)params;
- (NSDictionary *)configureCommonParams:(NSDictionary *)params;

@end
