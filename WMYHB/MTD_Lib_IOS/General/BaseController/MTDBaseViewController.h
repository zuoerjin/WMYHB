//
//  BaseViewController.h
//  KKLib
//
//  Created by Lethe HD on 15/1/3.
//  Copyright (c) 2015年 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDBaseViewController : UIViewController

@property (nonatomic, strong) NSDictionary *pageQueryData;

// override for subclass
- (void)setupQueryData:(NSDictionary *)queryData;

// 添加notifiation通知方法 便于统一移除
- (id)mtd_addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;

@end
