//
//  MTDUrlRouter.h
//  MTDLib
//
//  Created by 张志彬 on 16/7/18.
//  Copyright © 2016年 MTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const kMTDUrlScheme = @"mtd://";

@protocol MTDWebViewActionDelegate <NSObject>

@optional
- (void)login:(NSDictionary *)params;
- (void)open_new_view:(NSDictionary *)params;
- (void)product_list:(NSDictionary *)params;
- (void)login_another_device:(NSDictionary *)params;
- (void)back_relogin:(NSDictionary *)params;
- (void)PWD_ChangeSucceed:(NSDictionary *)params;
- (void)permission_error:(NSDictionary *)params;
- (void)share:(NSDictionary *)params;
- (void)go_back:(NSDictionary *)params;
- (void)collect_price:(NSDictionary *)params;
- (void)pwd_callback_success:(NSDictionary *)params;
- (void)go_home:(NSDictionary *)params;
- (void)integral:(NSDictionary *)params;

@end

@interface MTDUrlRouter : NSObject

@property (weak, nonatomic) id<MTDWebViewActionDelegate> actionDelegate;

+ (instancetype)sharedInstance;

- (BOOL)handleOpenUrl:(NSString *)urlString;
- (BOOL)handleMTDUrlContent:(NSString *)urlContent;

- (NSMutableDictionary *)processParmasComponents:(NSArray *)paramsComps;

@end
