//
//  UIAlertView+MTD.m
//  MTDLib
//
//  Created by wangyc on 1/18/16.
//  Copyright © 2016 MTD. All rights reserved.
//

#import "Aspects.h"
#import "UIAlertView+MTD.h"

@implementation UIAlertView (MTD)

+ (void)load {
    [self aspect_hookSelector:@selector(show) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        id _alert = [aspectInfo instance];
        
        [[NSNotificationCenter defaultCenter] addObserver:_alert selector:@selector(_auto_hide) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
    }error:NULL];
}

- (void)_auto_hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    if (self.isVisible) {
        [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
    }
}

@end
