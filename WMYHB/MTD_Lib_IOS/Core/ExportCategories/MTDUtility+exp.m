//
//  MTDUtility+exp.m
//  MTDMetal
//
//  Created by wangyc on 8/16/16.
//  Copyright © 2016 SCI99. All rights reserved.
//

#import "MTDUtility+exp.h"
#import "MTDAdaptor.h"

@implementation MTDUtility (exp)

+ (NSString *)processActiveAdLink:(NSString *)link {
    if (HASLOGIN && link.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"product_type":[[MTDAdaptor defaultAdaptor] productType], @"device_type":[[MTDAdaptor defaultAdaptor] deviceType], @"version":[[MTDAdaptor defaultAdaptor] appVersion]}];
        
        NSString *userid = USERID;
        
        if (userid && userid.length != 0) {
            [params setObject:USERID forKey:@"user_id"];
        }
        
        NSString *accesstoken = ACCESSTOKEN;
        
        if (accesstoken  && accesstoken.length != 0) {
            [params setObject:ACCESSTOKEN forKey:@"access_token"];
        }
        
        params = [MTDUtility postDicByParameters:params withPublickey:[[MTDAdaptor defaultAdaptor] publicKey] signatureKey:@"sign"];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:link parameters:params error:nil];
        
        return request.URL.absoluteString;
    }
    
    return link;
}

// 修正url里边的userid等参数
+ (NSString *)getUrlStringByAppendingUserCommonParams:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:URL_STRING(urlString)];
    NSString *baseUrlString = [[url.absoluteString componentsSeparatedByString:@"?"] firstObject];
    // 解析参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *paramPairs = [url.query componentsSeparatedByString:@"&"];
    for (NSString *paramPair in paramPairs) {
        NSArray *pairs = [paramPair componentsSeparatedByString:@"="];
        if (pairs.count == 2) {
            [params setObject:[pairs[1] URLDecodedString] forKey:pairs[0]];
        }
    }
    // 公共参数
    [params setObject:USERID forKey:@"user_id"];
    [params setObject:ACCESSTOKEN forKey:@"access_token"];
    [params setObject:DEVICETYPE forKey:@"device_type"];
    [params setObject:DEVICETOKEN forKey:@"device_token"];
    [params setObject:[[MTDAdaptor defaultAdaptor] productType] forKey:@"product_type"];
    [params setObject:VERSION forKey:@"version"];
    // 移除自带的sign参数，然后对剩余的参数签名
    [params removeObjectForKey:@"sign"];
    params = [NSMutableDictionary dictionaryWithDictionary:[MTDUtility commonPostDicForParams:params]];
    // 整理url
    NSString *correctUrlString;
    BOOL firstParams = YES;
    for (NSString *key in [params allKeys]) {
        NSString *value = [params stringValueForKey:key defaultValue:nil];
        if (value) {
            if (firstParams) {
                correctUrlString = [baseUrlString stringByAppendingFormat:@"?%@=%@", key, value];
                firstParams = NO;
            } else {
                correctUrlString = [correctUrlString stringByAppendingFormat:@"&%@=%@", key, value];
            }
        }
    }
    return correctUrlString;
}

@end
