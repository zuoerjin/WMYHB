//
//  MTDAdaptor.m
//  Pods
//
//  Created by wangyc on 8/6/15.
//
//

#import "MTDAdaptor.h"

@implementation MTDAdaptor {
    id<MTDConfigure> _currentConfigWrapper;
}

+ (id<MTDConfigure, MTDAdaptor>)defaultAdaptor {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [self new];
    });
    return _s_instance;
}

#pragma mark - MTDAdaptor
- (void)loadConfig:(id<MTDConfigure>)config {
    _currentConfigWrapper = config;
}

#pragma mark - message forward
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSAssert(_currentConfigWrapper, @"config wrapper instance cant be nil");
    return _currentConfigWrapper;
}

@end
