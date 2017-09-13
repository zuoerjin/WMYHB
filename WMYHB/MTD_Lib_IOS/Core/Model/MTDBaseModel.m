//
//  MMBaseModel.m
//  MTDMetal
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import "MTDBaseModel.h"

NSString *const kMTDUserTokenErrorNotification = @"kMTDUserTokenErrorNotification";

NSString *const KMTDUserTokenErrorUserInfoKeyErrorValue = @"KMTDUserTokenErrorUserInfoKeyErrorValue";
NSString *const kMTDUserTokenErrorUserInfoKeyReturnObjValue = @"kMTDUserTokenErrorUserInfoKeyReturnObjValue";

@implementation MTDApiRetObj

+ (MTDApiRetObj *)processResultDic:(NSDictionary *)dic error:(NSError *__autoreleasing *)error {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        MTDApiRetObj *retObj = [[MTDApiRetObj alloc] initWithReturnDicObj:dic];
        if (retObj.code != 0) {
            *error = retObj.error;
            if (retObj.code == MTDApiErrorCodeUserTokenErrorTokenExpired && ![MTDBaseModel sharedModel].tokenHasExpired) {
                [MTDBaseModel sharedModel].tokenHasExpired = YES;
                [MTDBaseModel sharedModel].lastUserTokenError = retObj.error;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMTDUserTokenErrorNotification object:[MTDBaseModel sharedModel] userInfo:@{kMTDUserTokenErrorUserInfoKeyReturnObjValue: retObj ?: [NSNull null], KMTDUserTokenErrorUserInfoKeyErrorValue: retObj.error ?: [NSNull null]}];
                });
            }
            else if (retObj.code == MTDApiErrorCodeUserTokenErrorHasLoginOnOtherDevice && ![MTDBaseModel sharedModel].hasLoginOnOtherDevice) {
                [MTDBaseModel sharedModel].hasLoginOnOtherDevice = YES;
                [MTDBaseModel sharedModel].lastUserTokenError = retObj.error;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMTDUserTokenErrorNotification object:[MTDBaseModel sharedModel] userInfo:@{kMTDUserTokenErrorUserInfoKeyReturnObjValue: retObj ?: [NSNull null], KMTDUserTokenErrorUserInfoKeyErrorValue: retObj.error ?: [NSNull null]}];
                });
            }
        }
        return retObj;
    }
    return nil;
}

- (instancetype)initWithReturnDicObj:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _originObj = dic;
        _code = [dic intValueForKey:@"code" defaultValue:-1];
        _infoObj = [dic objectForKey:@"info"];
        _msg = [[dic stringValueForKey:@"msg" defaultValue:@""] copy];
    }
    return self;
}

- (NSError *)error {
    return [NSError errorWithDomain:self.msg code:self.code userInfo:nil];
}

@end

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

@implementation MTDBaseModel
@synthesize threadMOC = _threadMOC;

+ (instancetype)sharedModel {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [self new];
    });
    return _s_instance;
}

+ (instancetype)model {
    return [self new];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCoredataDidChangeNotification:) name:kCoreDataBaseFileDidChangeNotification object:nil];
    }
    return self;
}

- (void)onCoredataDidChangeNotification:(id)sender {
    _threadMOC = nil;
}

- (MTDNetworkManager *)networkManager {
    return [MTDNetworkManager sharedManager];
}

- (NSManagedObjectContext *)threadMOC {
    if (!_threadMOC) {
        _threadMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _threadMOC.parentContext = [MTDCoredataManager sharedManager].mainThreadManagedObjectContext;
        _threadMOC.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    return _threadMOC;
}

// for subclass
- (NSDictionary *)configureModelParams:(NSDictionary *)params {
    NSMutableDictionary *mtDic = [params mutableCopy];
    
    if (!mtDic) {
        mtDic = @{}.mutableCopy;
    }
    
    if (self.shouldIgnoreCommonApiParams) {
        [mtDic setObject:@"1" forKey:kShouldIgnoreCommonParamsKey];
    }
    
    if (self.shouldIgnoreParamsSign) {
        [mtDic setObject:@"1" forKey:kShouldIgnoreParamsSignKey];
    }
    
    return mtDic;
}

- (void)callbackUIBlockWithError:(NSError *)error resultData:(id)resultData pharsedData:(id)pharsedData operation:(AFHTTPRequestOperation *)operation {
    ApiCompleteHandler uiblock = [operation getUICallback];
    if (uiblock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            uiblock(error, resultData, pharsedData, operation);
        });
    }
}

#pragma mark - get methods
- (AFHTTPRequestOperation *)getRequestWithParams:(NSDictionary *)params apiPath:(NSString *)apiPath completeHandler:(ApiCompleteHandler)handler successAFCallback:(AFHttpOperationSuccessHandler)success {
    WEAK_SELF_DEFINE(pSelf);
    AFHttpOperationFailedHandler failed = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [pSelf callbackUIFailedWithError:error operation:operation];
    };
    
    return [[self networkManager] getWithParams:[self configureModelParams:params]
                                     apiHostUrl:self.apiHostUrl
                                        apiPath:apiPath
                                completeHandler:handler
                              successAFCallback:success
                               failedAFCallback:failed];
}

- (AFHTTPRequestOperation *)getRequestWithParams:(NSDictionary *)params
                                         apiPath:(NSString *)apiPath
                                 completeHandler:(ApiCompleteHandler)handler
                               successAFCallback:(AFHttpOperationSuccessHandler)success
                                failedAFCallback:(AFHttpOperationFailedHandler)failed {
    
    return [[self networkManager] getWithParams:[self configureModelParams:params]
                                     apiHostUrl:self.apiHostUrl
                                        apiPath:apiPath
                                completeHandler:handler
                              successAFCallback:success
                               failedAFCallback:failed];
}

#pragma mark - post methods
- (AFHTTPRequestOperation *)postRequestWithParams:(NSDictionary *)params
                                          apiPath:(NSString *)apiPath
                                  completeHandler:(ApiCompleteHandler)handler
                                successAFCallback:(AFHttpOperationSuccessHandler)success {
    
    WEAK_SELF_DEFINE(pSelf);
    AFHttpOperationFailedHandler failed = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [pSelf callbackUIFailedWithError:error operation:operation];
    };
    
    return [[self networkManager] postRequestWithParams:[self configureModelParams:params]
                                             apiHostUrl:self.apiHostUrl
                                                apiPath:apiPath
                                        completeHandler:handler
                                      successAFCallback:success
                                       failedAFCallback:failed];
}

- (AFHTTPRequestOperation *)postRequestWithParams:(NSDictionary *)params
                                          apiPath:(NSString *)apiPath
                                  completeHandler:(ApiCompleteHandler)handler
                                successAFCallback:(AFHttpOperationSuccessHandler)success
                                 failedAFCallback:(AFHttpOperationFailedHandler)failed {
    
    return [[self networkManager] postRequestWithParams:[self configureModelParams:params]
                                             apiHostUrl:self.apiHostUrl
                                                apiPath:apiPath
                                        completeHandler:handler
                                      successAFCallback:success
                                       failedAFCallback:failed];
}

#pragma mark - private

- (void)callbackUIFailedWithError:(NSError *)error operation:(AFHTTPRequestOperation *)opt {
    NSLog(@"%@ failed with error %@",opt.request.URL, [error localizedDescription]);
    ApiCompleteHandler uicallback = [opt getUICallback];
    WEAK_SELF_DEFINE(pSelf);
    if (uicallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *pharsedErr = error;
            
            if (![pSelf.networkManager isNetworkAviliable]) {
                pharsedErr = [NSError errorWithDomain:MTD_STRING(@"no_networking") code:MTDApiErrorCodeNoNetworking userInfo:error.userInfo];
            }
            else if (error.code == NSURLErrorTimedOut || error.code == kCFURLErrorNetworkConnectionLost) {
                pharsedErr = [NSError errorWithDomain:MTD_STRING(@"bad_networking") code:MTDApiErrorCodeBadNetworking userInfo:error.userInfo];
            }
            else if (error.code == kCFURLErrorCannotConnectToHost){
                pharsedErr = [NSError errorWithDomain:MTD_STRING(@"connect_failed") code:MTDApiErrorCodeConnectFailed userInfo:error.userInfo];
            }
            else {
                pharsedErr = [NSError errorWithDomain:MTD_STRING(@"server_error") code:MTDApiErrorCodeConnectFailed userInfo:error.userInfo];
            }
            
            
            uicallback(pharsedErr, nil, nil, opt);
        });
    }
}

@end
