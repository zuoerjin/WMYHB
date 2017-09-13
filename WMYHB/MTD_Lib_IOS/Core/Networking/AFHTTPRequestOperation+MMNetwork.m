//
//  AFHTTPRequestOperation+MMNetwork.m
//  MTDMetal
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import <objc/runtime.h>
#import "AFHTTPRequestOperation+MMNetwork.h"

static const NSString *kUICallbackKey = @"MTD_UI_CALLBACK";

@implementation AFHTTPRequestOperation (MMNetwork)

- (ApiCompleteHandler)getUICallback {
    return objc_getAssociatedObject(self, (__bridge const void *)(kUICallbackKey));
}

- (void)setUICallback:(ApiCompleteHandler)handler {
    objc_setAssociatedObject(self,
                             (__bridge const void *)(kUICallbackKey),
                             handler,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
