//
//  MTDLaunchScreenManager.m
//  MTDLib
//
//  Created by wangyc on 12/8/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDAdaptor.h"
#import "MTDLaunchWindow.h"
#import "MTDLaunchScreenManager.h"
#import "MTDLaunchScreenModel.h"

static CGFloat const kLaunchScreenDisplayDuration = 3.0f;

@interface MTDLaunchScreenManager ()

@property (nonatomic, strong) MTDLaunchScreenModel *model;
@property (nonatomic, strong) MTDLaunchWindow *launchWindow;
@property (nonatomic, assign) BOOL hasLaunched;
@property (nonatomic, assign) BOOL needToDisplayLaunchScreen;

@end

@implementation MTDLaunchScreenManager

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[self sharedManager] showLaunchScreenIfNeeded];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[self sharedManager] onApplicationBecomeActive];
    }];
}

+ (instancetype)sharedManager {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [self new];
    });
    return _s_instance;
}

- (void)showLaunchScreenIfNeeded {
    if (![[MTDAdaptor defaultAdaptor] shouldDisplayLaunchScreen]) {
        return;
    }
    
    UIImage *img = [self.model imageFromLocalFile];
    if ([self.model shouldDisplayLaunchScreenFromLocal] && img) {
        MTDLaunchWindow *wd = [MTDLaunchWindow launchWindow];
        wd.launchImage = img;
        [wd showWithDuration:kLaunchScreenDisplayDuration];
        self.launchWindow = wd;
        
        self.needToDisplayLaunchScreen = YES;
    }
    [self.model refreshLaunchScreenInfoFromServer];
}

- (void)onApplicationBecomeActive {
    if (!self.hasLaunched) {
        
        if (self.needToDisplayLaunchScreen) {
            [self.launchWindow startCountdown];
        }
        
        self.hasLaunched = YES;
    }
}

#pragma mark - properties
- (MTDLaunchScreenModel *)model {
    if (!_model) {
        
        if ([[MTDAdaptor defaultAdaptor] shouldDisplayLaunchScreen]) {
            id model = [[MTDAdaptor defaultAdaptor] launchScreenModel];
            if ([model isKindOfClass:[MTDLaunchScreenModel class]]) {
                _model = model;
            }
        }
        
        if (!_model) {
            _model = [MTDLaunchScreenModel model];
        }
    }
    return _model;
}

@end
