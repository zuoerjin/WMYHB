//
//  BaseViewController.m
//  KKLib
//
//  Created by Lethe HD on 15/1/3.
//  Copyright (c) 2015年 MTD. All rights reserved.
//

#import "MTDBaseViewController.h"

@interface MTDBaseViewController ()

@property (nonatomic, strong) NSMutableArray *pi_observers;

@end

@implementation MTDBaseViewController

- (void)setupQueryData:(NSDictionary *)queryData {
    self.pageQueryData = queryData;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (id obs in self.pi_observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:obs];
    }
    self.pi_observers = nil;
}

- (NSMutableArray *)pi_observers {
    if (!_pi_observers) {
        _pi_observers = [[NSMutableArray alloc] init];
    }
    return _pi_observers;
}

- (id)mtd_addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
    
    id obsObj = [[NSNotificationCenter defaultCenter] addObserverForName:name object:obj queue:queue usingBlock:block];
    
    if (obsObj) {
        [self.pi_observers addObject:obsObj];
    }
    
    return obsObj;
}

@end
