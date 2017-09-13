//
//  MTDUtility+exp.h
//  MTDMetal
//
//  Created by wangyc on 8/16/16.
//  Copyright © 2016 SCI99. All rights reserved.
//

#import "MTDUtility.h"

@interface MTDUtility (exp)

/// 处理活动广告link
+ (NSString *)processActiveAdLink:(NSString *)link;
// urlString 拼接公共参数
+ (NSString *)getUrlStringByAppendingUserCommonParams:(NSString *)urlString;

@end
