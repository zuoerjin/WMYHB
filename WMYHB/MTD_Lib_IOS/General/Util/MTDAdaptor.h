//
//  MTDAdaptor.h
//  Pods
//
//  Created by wangyc on 8/6/15.
//
//

#import <Foundation/Foundation.h>

@protocol MTDConfigure <NSObject>

@required
- (NSString *)publicKey;
- (NSString *)SHAPublicKey;
- (NSString *)appVersion;
- (NSString *)deviceType;
- (NSString *)productType;
- (NSString *)appID;

// server url
- (NSString *)serverHostUrl;
- (NSString *)apiHostUrl;
- (NSString *)imageUrl;

// launch screen
- (id)launchScreenModel;
- (BOOL)shouldDisplayLaunchScreen;

// config api params
- (BOOL)shouldConfigureCommonParams;
- (NSMutableDictionary *)configureCommomPostParams:(NSDictionary *)params;
- (NSMutableDictionary *)configureUserTokenPostParams:(NSDictionary *)params;
- (NSString *)paramsSignatureKey;

/// url handling
- (BOOL)handleOpenUrl:(NSString *)urlString;

@end

@protocol MTDAdaptor <NSObject>

@required
- (void)loadConfig:(id<MTDConfigure>)config;

@end

@interface MTDAdaptor : NSObject

+ (id<MTDConfigure, MTDAdaptor>)defaultAdaptor;

@end
