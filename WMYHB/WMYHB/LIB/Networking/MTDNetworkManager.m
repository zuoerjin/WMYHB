//
//  MMNetworkManager.m
//  MTDMetal
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import "MTDNetworkManager.h"
#import "AFNetworkReachabilityManager.h"
#import "MTDAdaptor.h"
#import "MTDUtility.h"

NSString *const kNetworkResumeAviliableNotification = @"kNetworkResumeAviliableNotification";
NSString *const kShouldIgnoreCommonParamsKey = @"kShouldIgnoreCommonParamsKey";
NSString *const kShouldIgnoreParamsSignKey = @"kShouldIgnoreParamsSignKey";

@interface MTDNetworkManager () {
    dispatch_queue_t _dataProcessQueue;
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic, strong) NSMutableArray *debugQueue;

@end

@implementation MTDNetworkManager

+ (void)load {
    __weak id obser = nil;
    obser = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [[MTDNetworkManager sharedManager] startNetworkAviliableNotifier];
        [[NSNotificationCenter defaultCenter] removeObserver:obser];
    }];
}

+ (instancetype)sharedManager {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [[self alloc] init];
    });
    return _s_instance;
}

+ (BOOL)hasNetwork {
    return [[self sharedManager] isNetworkAviliable];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isNetworkAviliable = YES;
        
#if DEBUG
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self outputDebugInfoAndClean];
        }];
#endif
    }
    return self;
}

- (NSMutableArray *)debugQueue {
    if (!_debugQueue) {
        _debugQueue = [NSMutableArray new];
    }
    
    return _debugQueue;
}

#pragma mark - public methods
- (void)startNetworkAviliableNotifier {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable ||
            status == AFNetworkReachabilityStatusUnknown) {
            NSLog(@"network access lost !!");
            _isNetworkAviliable = NO;
        }
        else {
            NSLog(@"network access is ready isWAN %d isWifi %d", (status == AFNetworkReachabilityStatusReachableViaWWAN), (status == AFNetworkReachabilityStatusReachableViaWiFi));
            _isNetworkAviliable = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkResumeAviliableNotification object:nil];
            });
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - get methods
- (AFHTTPRequestOperation *)getRequestWithParams:(NSDictionary *)params
                                         apiPath:(NSString *)apiPath
                                 completeHandler:(ApiCompleteHandler)handler
                               successAFCallback:(AFHttpOperationSuccessHandler)success
                                failedAFCallback:(AFHttpOperationFailedHandler)failed {
    
    AFHTTPRequestOperation *opt = nil;
    
    params = [self configureUserTokenParams:params];
    params = [self configureCommonParams:params];
    params = [self cleanParamsAndSignIfNeededWithPrams:params];

#if DEBUG
    [self appendDebugRequestWithMethod:@"get" apiPath:apiPath params:params];
#endif
    
    opt = [[self defaultAFRequestManager] GET:[[self apiServerUrl] stringByAppendingPathComponent:apiPath]
                                   parameters:params
                                      success:success
                                      failure:failed];
    [opt setUICallback:handler];
    opt.completionQueue = [self dataProcQueue];
    
    return opt;
}

- (id)getWithParams:(NSDictionary *)params
         apiHostUrl:(NSString *)hostUrl
            apiPath:(NSString *)apiPath
    completeHandler:(ApiCompleteHandler)handler
  successAFCallback:(AFHttpOperationSuccessHandler)success
   failedAFCallback:(AFHttpOperationFailedHandler)failed {
    
    AFHTTPRequestOperation *opt = nil;
    NSString *apiHostUrl = hostUrl.length > 0 ? hostUrl : [self apiServerUrl];
    
    params = [self configureUserTokenParams:params];
//    params = [self configureCommonParams:params];
    params = [self cleanParamsAndSignIfNeededWithPrams:params];
    
#if DEBUG
    [self appendDebugRequestWithMethod:@"get" apiPath:apiPath params:params];
#endif
    
    opt = [[self defaultAFRequestManager] GET:[apiHostUrl stringByAppendingPathComponent:apiPath]
                                   parameters:params
                                      success:success
                                      failure:failed];
    [opt setUICallback:handler];
    opt.completionQueue = [self dataProcQueue];
    
    return opt;
}

#pragma mark - post methods
- (AFHTTPRequestOperation *)postRequestWithParams:(NSDictionary *)params
                                          apiPath:(NSString *)apiPath
                                  completeHandler:(ApiCompleteHandler)handler
                                successAFCallback:(AFHttpOperationSuccessHandler)success
                                 failedAFCallback:(AFHttpOperationFailedHandler)failed {
    AFHTTPRequestOperation *opt = nil;
    
    params = [self configureUserTokenParams:params];
//    params = [self configureCommonParams:params];
    params = [self cleanParamsAndSignIfNeededWithPrams:params];
    
#if DEBUG
    [self appendDebugRequestWithMethod:@"post" apiPath:apiPath params:params];
#endif
    
    opt = [[self defaultAFRequestManager] POST:[[self apiServerUrl] stringByAppendingPathComponent:apiPath]
                                    parameters:params
                                       success:success
                                       failure:failed];
    [opt setUICallback:handler];
    opt.completionQueue = [self dataProcQueue];
    
    return opt;
}

- (id)postRequestWithParams:(NSDictionary *)params
                 apiHostUrl:(NSString *)hostUrl
                    apiPath:(NSString *)apiPath
            completeHandler:(ApiCompleteHandler)handler
          successAFCallback:(AFHttpOperationSuccessHandler)success
           failedAFCallback:(AFHttpOperationFailedHandler)failed {
    
    AFHTTPRequestOperation *opt = nil;
    NSString *apiHostUrl = hostUrl.length > 0 ? hostUrl : [self apiServerUrl];
    
    params = [self configureUserTokenParams:params];
    params = [self configureCommonParams:params];
    params = [self cleanParamsAndSignIfNeededWithPrams:params];
    
#if DEBUG
    [self appendDebugRequestWithMethod:@"post" apiPath:apiPath params:params];
#endif
    
    opt = [[self defaultAFRequestManager] POST:[apiHostUrl stringByAppendingPathComponent:apiPath]
                                    parameters:params
                                       success:success
                                       failure:failed];
    [opt setUICallback:handler];
    opt.completionQueue = [self dataProcQueue];
    
    return opt;
}

#pragma mark - config
- (NSString *)apiServerUrl {
    return [[MTDAdaptor defaultAdaptor] apiHostUrl];
}

- (AFHTTPRequestOperationManager *)defaultAFRequestManager {
    return self.operationManager;
}

- (AFHTTPRequestOperationManager *)operationManager {
    if (!_operationManager) {
        _operationManager = [AFHTTPRequestOperationManager manager];
    }
    return _operationManager;
}

- (NSDictionary *)configureCommonParams:(NSDictionary *)params {
    if ([params intValueForKey:kShouldIgnoreCommonParamsKey defaultValue:0] == 1) {
        
        return params;
    }
    
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mtDic = [params mutableCopy];
        
        if ([[MTDAdaptor defaultAdaptor] shouldConfigureCommonParams]) {
            if (![mtDic objectForKey:@"producttype"]) {
                [mtDic setObject:[[MTDAdaptor defaultAdaptor] productType] forKey:@"producttype"];
            }
            
            if (![mtDic objectForKey:@"devicetype"]) {
                [mtDic setObject:[[MTDAdaptor defaultAdaptor] deviceType] forKey:@"devicetype"];
            }
            
            if (![mtDic objectForKey:@"version"]) {
                [mtDic setObject:[[MTDAdaptor defaultAdaptor] appVersion] forKey:@"version"];
            }
        }
        
        params = [[MTDAdaptor defaultAdaptor] configureCommomPostParams:mtDic];
    }
    
    return params;
}

- (NSDictionary *)configureUserTokenParams:(NSDictionary *)params {
    // for sub class
    if ([params intValueForKey:kShouldIgnoreCommonParamsKey defaultValue:0] == 1) {
        
        return params;
    } else {
        
        return [[MTDAdaptor defaultAdaptor] configureUserTokenPostParams:params];
    }
}

- (NSDictionary *)cleanParamsAndSignIfNeededWithPrams:(NSDictionary *)params {
    BOOL needIgnoreSign = [params intValueForKey:kShouldIgnoreParamsSignKey defaultValue:0] == 1;
    
    if (params && params.count > 0) {
        NSMutableDictionary *mtDic = [params mutableCopy];
        
        [mtDic removeObjectForKey:kShouldIgnoreCommonParamsKey];
        [mtDic removeObjectForKey:kShouldIgnoreParamsSignKey];
        
        params = mtDic;
    }
    
    if (!needIgnoreSign) {
        NSString *signatureKey = [[MTDAdaptor defaultAdaptor] paramsSignatureKey];
        if (signatureKey.length > 0) {
            params = [MTDUtility commonPostDicForParams:params signatureKey:signatureKey];
        }
        else {
            params = [MTDUtility commonPostDicForParams:params];
        }
    }
    
    return params;
}

#pragma mark - private
- (dispatch_queue_t)dataProcQueue {
    if (!_dataProcessQueue) {
        _dataProcessQueue = dispatch_queue_create("com.sci99.dataprocq", DISPATCH_QUEUE_SERIAL);
    }
    return _dataProcessQueue;
}

#pragma mark - callback
- (void)callbackUIFailedWithError:(NSError *)error operation:(AFHTTPRequestOperation *)opt {
    ApiCompleteHandler uicallback = [opt getUICallback];
    if (uicallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            uicallback(error, nil, nil, opt);
        });
    }
}

#pragma mark - debug 
- (void)appendDebugRequestWithMethod:(NSString *)method apiPath:(NSString *)apiPath params:(NSDictionary *)params {
#if DEBUG
    NSMutableArray *allParams = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, obj];
        [allParams addObject:pair];
    }];
    
    [self.debugQueue addObject:[NSString stringWithFormat:@"api path:%@ %@ params: %@", apiPath, method, [allParams componentsJoinedByString:@","]]];
#endif
}

- (void)outputDebugInfoAndClean {
    printf("\nrequest track\n~~~~~~~~~~~\n\n\n");
    
    for (NSString *info in self.debugQueue) {
        printf("\n\n%s\n\n", [info dataUsingEncoding:NSUTF8StringEncoding].bytes);
    }
    
    printf("\n~~~~~~~~~~~~");
    
    [self.debugQueue removeAllObjects];
}

@end
