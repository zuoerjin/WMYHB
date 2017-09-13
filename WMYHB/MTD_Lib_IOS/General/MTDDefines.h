//
//  MMDefines.h
//  MTDMetal
//
//  Created by wangyc on 5/14/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#ifndef MTDLib_MTDDefines_h
#define MTDLib_MTDDefines_h


#ifndef DEBUG_INVALIDATE_ARGUMENTS
#define DEBUG_INVALIDATE_ARGUMENTS NSLog(@"%@- %@ : invalidate arguments", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#endif

#ifndef SelectorDescripation
#define SelectorDescripation    NSLog(@"%@", NSStringFromSelector(_cmd))
#endif

#ifndef UserDefaults
#define UserDefaults            [NSUserDefaults standardUserDefaults]
#endif

#ifndef DefaultNotificationCenter
#define DefaultNotificationCenter       [NSNotificationCenter defaultCenter]
#endif

#define UIColorFromRGB_dec(r,g,b) [UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]
#define UIColorFromRGBA_dec(r,g,b,a) [UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]
#define UIColorFromRGB_hex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA_hex(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// debug output
#if DEBUG
#define MTDLog(fmt, ...) NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(fmt), ##__VA_ARGS__])
#else
#define MTDLog(fmt, ...) ((void)0)
#endif

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) ((void)0)
#endif

#define WEAK_SELF_DEFINE(pSelf)        __weak typeof(self) (pSelf) = self

#ifndef SYSTEM_VERSION
#define SYSTEM_VERSION                      ([[UIDevice currentDevice] systemVersion])
#endif

#ifndef DEVICE_NAME
#define DEVICE_NAME                         ([UIDevice devicePlatformString])
#endif

#define MTD_STRING(key)             NSLocalizedString(key, nil)

#ifndef VERSION
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

#ifndef DEVICETYPE
#define DEVICETYPE @"1"
#endif

#ifndef CLIENTID
#define CLIENTID ([UserDefaults objectForKey:@"clientid"]?[UserDefaults objectForKey:@"clientid"]:@"")
#endif

#ifndef DEVICETOKEN
#define DEVICETOKEN ([UserDefaults objectForKey:@"devicetoken"]?[UserDefaults objectForKey:@"devicetoken"]:@"")
#endif

#ifndef ACCESSTOKEN
#define ACCESSTOKEN ([UserDefaults objectForKey:@"Access_Token"]?[UserDefaults objectForKey:@"Access_Token"]:@"")
#endif

#ifndef HASLOGIN
#define HASLOGIN [UserDefaults boolForKey:@"hasLogin"]
#endif

#ifndef USERPHONENUMBER
#define USERPHONENUMBER ([UserDefaults objectForKey:@"userPhoneNumber"]?[UserDefaults objectForKey:@"userPhoneNumber"]:@"")
#endif

#ifndef FONTSIZE
#define FONTSIZE [UserDefaults floatForKey:@"userFontSize"]
#endif

#ifndef USERID
#define USERID ([UserDefaults objectForKey:@"userid"]?[UserDefaults objectForKey:@"userid"]:@"")
#endif


#ifndef USERPASSWORD
#define USERPASSWORD [UserDefaults objectForKey:@"userPassword"]
#endif

#ifndef SERVICENAME
#define SERVICENAME [UserDefaults objectForKey:@"serviceName"]
#endif

#ifndef SERVICEPHONE
#define SERVICEPHONE ([UserDefaults objectForKey:@"servicePhone"]?[UserDefaults objectForKey:@"servicePhone"]:@"400-811-5599")
#endif

#ifndef LATESTNEWSKEY
#define LATESTNEWSKEY [UserDefaults objectForKey:@"latestNewskey"]
#endif


//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define DPI_WIDTH [UIScreen mainScreen].currentMode.size.width

#ifndef RGB
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#endif

#ifndef RGBA
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#ifndef IS_IOS_7
#define IS_IOS_7 IOS_VERSION >= 7
#endif

#ifndef IS_IOS_6
#define IS_IOS_6 IOS_VERSION >= 6
#endif

#define NIB_FOR_NAME(name) [UINib nibWithNibName:(name) bundle:nil]
#define STRING_FROM_CLASS(cls)  NSStringFromClass([cls class])

#define KeyWindow [UIApplication sharedApplication].keyWindow

#define SendMessageToRefreshOrderList [DefaultNotificationCenter postNotificationName:kNotficationNameReloadSlideOrderList object:nil]

#define URL_STRING(urlString) [[urlString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`^{}\"[]|\\<> "].invertedSet]

#endif
