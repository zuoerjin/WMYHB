//
//  MTDUtility.m
//  MTDLib
//
//  Created by sci99 on 15/5/27.
//  Copyright (c) 2015年 MTD. All rights reserved.
//

#import "Aspects.h"
#import "MTDBaseViewController.h"
#import "MTDUtility.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonHMAC.h>
#import "MTDDefines.h"

@interface MTDUtility ()

@property (nonatomic, strong) UIStoryboard *mainStoryBoard;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MTDUtility

- (instancetype)init {
    self = [super init];
    if (self) {
        _mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [self new];
    });
    return _s_instance;
}

#pragma mark-
#pragma mark HMAC加密算法
+ (NSString *)hmac_sha1:(NSString*)key text:(NSString*)text {
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [HMAC base64Encoding];
    return hash;
}


#pragma mark-
#pragma mark 生成post方式参数列表
+ (NSMutableDictionary *)postDicByParameters:(NSMutableDictionary *)parametersDic withPublickey:(NSString *)publickey signatureKey:(NSString *)signatureKey
{
    NSString *sigKey = signatureKey.length > 0 ? signatureKey : @"sign";
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    [parametersDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [array addObject:[key stringByAppendingString:obj]];
    }];
    
    NSArray *resultArr = [array sortedArrayUsingSelector:@selector(compare:)];
    NSString *str = [resultArr componentsJoinedByString:@""];
    
    NSString *sign =[self hmac_sha1:publickey text:str];
    
    
    [parametersDic setObject:sign forKey:sigKey];
    
    return parametersDic;
}

#pragma mark-
#pragma mark 获取UUID

+ (NSString*)getUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


+ (UIWindow *)keyAppWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

+ (CGSize)mainScreenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (NSString *)documentDirString {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSDictionary *)commonPostDicForParams:(NSDictionary *)params {
    return [self postDicByParameters:[params mutableCopy] withPublickey:[[MTDAdaptor defaultAdaptor] publicKey] signatureKey:@"sign"];
}

+ (NSDictionary *)commonPostDicForParams:(NSDictionary *)params signatureKey:(NSString *)signKey {
    return [self postDicByParameters:[params mutableCopy] withPublickey:[[MTDAdaptor defaultAdaptor] publicKey] signatureKey:signKey];
}

+ (NSDictionary *)generateParamsFromParameterString:(NSString *)paramStr {
    if (paramStr.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSArray *paramPairs = [paramStr componentsSeparatedByString:@"&"];
        
        for (NSString *paramPair in paramPairs) {
            NSArray *pairs = [paramPair componentsSeparatedByString:@"="];
            if (pairs.count == 2) {
                if (pairs[1] && [pairs[1] length]) {
                    [params setObject:[pairs[1] URLDecodedString] forKey:pairs[0]];
                } else {
                    [params setObject:pairs[1] forKey:pairs[0]];
                }
            }
        }
        
        return params;
    }
    return nil;
}

- (void)setupAOPHooks {
    [self hookWhatUNeed];
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier {
    id controllerInstance = nil;
    @try {
        controllerInstance = [self.mainStoryBoard instantiateViewControllerWithIdentifier:identifier];
    }
    @catch (NSException *exception) {
        NSLog(@"%@ catch exception %@", NSStringFromSelector(_cmd), exception);
    }
    @finally {
        return controllerInstance;
    }
}

- (void)showControllerWithSegueIdentifier:(NSString *)identifier queryData:(NSDictionary *)queryData {
    if ([identifier isKindOfClass:[NSString class]] &&
        [queryData isKindOfClass:[NSDictionary class]]) {
        [[self currentTopViewController] performSegueWithIdentifier:identifier sender:queryData];
    }
}

- (void)pushControllerWithIdentifier:(NSString *)identifier queryData:(NSDictionary *)queryData {
    MTDBaseViewController *vc = [self instantiateViewControllerWithIdentifier:identifier];
    
    if (!vc) {
        NSLog(@"%@ - no controller fount with identifier %@", NSStringFromSelector(_cmd), identifier);
        return;
    }
    
    if ([vc isKindOfClass:[MTDBaseViewController class]]) {
        [vc setupQueryData:queryData];
    }
    
    [self.currentNavigationController pushViewController:vc animated:YES];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if ([self.currentNavigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.currentNavigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)presentControllerWithIdentifier:(NSString *)identifier queryData:(NSDictionary *)queryData
{
    MTDBaseViewController *vc = [self instantiateViewControllerWithIdentifier:identifier];
    if ([vc isKindOfClass:[MTDBaseViewController class]]) {
        [vc setupQueryData:queryData];
    }
    
    [self.currentNavigationController presentViewController:vc animated:YES completion:^{
    }];
    
}

- (UIViewController *)currentTopViewController {
    return self.currentNavigationController.topViewController;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSDate *)dateFromTimestrampString:(NSString *)timestramp {
    return [NSDate dateWithTimeIntervalSince1970:[timestramp doubleValue]];
}

- (NSString *)commontDateStringFromTimestrampString:(NSString *)timestramp {
    return [self dateStringFromTimestrampString:timestramp forDateFormatter:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)dateStringFromTimestrampString:(NSString *)timestramp forDateFormatter:(NSString *)fmt {
    NSTimeInterval timeInterval = [timestramp doubleValue];
    return [self dateStringWithFormatter:fmt fromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

- (NSString *)dateStringWithFormatter:(NSString *)fmt fromDate:(NSDate *)date {
    if (fmt.length > 0 && date) {
        self.dateFormatter.dateFormat = fmt;
        return [self.dateFormatter stringFromDate:date];
    }
    return nil;
}

#pragma mark - private
- (void)hookWhatUNeed {
    NSError *error = nil;
    // UIViewController navigation
    [UIViewController aspect_hookSelector:@selector(prepareForSegue:sender:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   NSArray *arguments = [aspectInfo arguments];
                                   if (arguments.count > 1) {
                                       UIStoryboardSegue *segue = arguments[0];
                                       id sender = arguments[1];
                                       
                                       if ([segue isKindOfClass:[UIStoryboardSegue class]] &&
                                           [sender isKindOfClass:[NSDictionary class]]) {
                                           if ([segue.destinationViewController isKindOfClass:[MTDBaseViewController class]]) {
                                               [(MTDBaseViewController *)segue.destinationViewController setupQueryData:sender];
                                           }
                                       }
                                   }
                               }
                                    error:&error];
    
    if (error) {
        NSLog(@"aspect_hookSelector:@selector(prepareForSegue:sender:)- error with %@", error);
    }
    
    error = nil;
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *vc = [aspectInfo instance];
                                   if (vc.navigationController != nil) {
                                       self.currentNavigationController = vc.navigationController;
                                   }
                               }
                                    error:&error];
    
    if (error) {
        NSLog(@"aspect_hookSelector:@selector(viewWillAppear:)- error with %@", error);
    }
}

@end
