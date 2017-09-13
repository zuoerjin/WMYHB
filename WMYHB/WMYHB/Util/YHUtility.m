//
//  YHUtility.m
//  WMYHB
//
//  Created by wangjian on 2017/9/12.
//  Copyright © 2017年 wangjian. All rights reserved.
//

#import "YHUtility.h"

@implementation YHUtility

- (instancetype)init {
    self = [super init];
    
    if (self) {
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

+ (void)setupControllerUrlMapping {
    // web
//    [MTDPageMap appendPageUrl:kPageUrlWebViewController withNibName:@"MAWebViewController" pageClassString:@"MAWebViewController" openType:PageOpenTypePush cacheType:PageCacheTypeNormal];
    
}

+ (void)customUIElement {
    // navigation bar
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:kNavigationBarTitleFontSize],
                                     NSForegroundColorAttributeName: kUINavigationBarTitleColor,
                                     };
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kMTDAgriThemeColor] forBarMetrics:UIBarMetricsDefault];
    //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:UIColorFromRGB_hex(0xe1e1e1)]];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
}

@end
