//
//  YHUtility.h
//  WMYHB
//
//  Created by wangjian on 2017/9/12.
//  Copyright © 2017年 wangjian. All rights reserved.
//

#import "MTDUtility.h"

@interface YHUtility : MTDUtility

+ (instancetype)sharedInstance;
+ (void)setupControllerUrlMapping;
+ (void)customUIElement;

@end
