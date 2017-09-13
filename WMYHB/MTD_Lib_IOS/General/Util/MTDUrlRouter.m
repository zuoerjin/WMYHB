//
//  MTDUrlRouter.m
//  MTDLib
//
//  Created by 张志彬 on 16/7/18.
//  Copyright © 2016年 MTD. All rights reserved.
//

#import "MTDUrlRouter.h"
#import "MTDDefines.h"
#import "MTDConsts.h"
#import "MTDPageManager.h"
#import "NSDictionary+MTDLib.h"
#import "NSString+MTDLib.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation MTDUrlRouter

+ (instancetype)sharedInstance {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [self new];
    });
    
    return _s_instance;
}

- (BOOL)handleOpenUrl:(NSString *)urlString {
    BOOL bRet = NO;
    
    if ([urlString hasPrefix:kMTDUrlScheme]) {
        return [self handleMTDUrlContent:[urlString substringFromIndex:kMTDUrlScheme.length]];
    }
    
    return bRet;
}

#pragma mark - private

- (BOOL)handleMTDUrlContent:(NSString *)urlContent {
    
    BOOL bRet = NO;
    
    if (urlContent.length > 0) {
        
        NSArray *comps = [urlContent componentsSeparatedByString:@"?"];
        
        if (comps.count > 0) {
            
            NSString *target = [comps[0] stringByAppendingString:@":"];
            NSString *paramStr = comps.count > 1 ? comps[1] : nil;
            NSArray *paramsComps = [paramStr componentsSeparatedByString:@"&"];
            NSMutableDictionary *params = [self processParmasComponents:paramsComps];
            
            NSMutableDictionary *pageQueryDic = params ?: [NSMutableDictionary dictionary];
            
            if ([self.actionDelegate respondsToSelector:NSSelectorFromString(target)]) {
                SuppressPerformSelectorLeakWarning(
                    [self.actionDelegate performSelector:NSSelectorFromString(target) withObject:pageQueryDic];
                );
                
            }
        }
    }
    
    return bRet;
}

- (NSMutableDictionary *)processParmasComponents:(NSArray *)paramsComps {
    if (paramsComps.count > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        for (NSString *paramPair in paramsComps) {
            NSArray *pair = [paramPair componentsSeparatedByString:@"="];
            
            if (pair.count == 2) {
                [params setObject:[pair[1] URLDecodedString] forKey:pair[0]];
            }
        }
        
        return params;
    }
    
    return nil;
}

@end
