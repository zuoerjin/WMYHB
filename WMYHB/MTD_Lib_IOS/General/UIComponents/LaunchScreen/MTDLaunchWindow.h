//
//  MTDLaunchWindow.h
//  MTDLib
//
//  Created by wangyc on 12/8/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDLaunchWindow : UIWindow

@property (nonatomic, strong) UIImage *launchImage;

+ (instancetype)launchWindow;
- (void)showWithDuration:(NSTimeInterval)duration;
- (void)startCountdown;

@end
