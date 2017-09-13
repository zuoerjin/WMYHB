//
//  MTDLaunchWindow.m
//  MTDLib
//
//  Created by wangyc on 12/8/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import "MTDLaunchWindow.h"

@interface MTDLaunchWindow ()

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation MTDLaunchWindow

+ (instancetype)launchWindow {
    MTDLaunchWindow *wd = [[MTDLaunchWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    wd.windowLevel = UIWindowLevelStatusBar - 0.1f;
    wd.backgroundColor = [UIColor clearColor];
    wd.rootViewController = [[UIViewController alloc] init];
    return wd;
}

- (void)showWithDuration:(NSTimeInterval)duration {
    self.duration = duration;
    [self makeKeyAndVisible];
}

- (void)hideLaunchScreen {
    [UIView animateWithDuration:0.3 animations:^{
        self.imgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [[MTDUtility keyAppWindow] makeKeyAndVisible];
    }];
}

- (void)startCountdown {
    self.startTime = [NSDate date];
    CADisplayLink *dpl = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTimeTrick:)];
    [dpl addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - action
- (void)onTimeTrick:(CADisplayLink *)link {
    NSDate *date = [NSDate date];    
    if ([date timeIntervalSinceDate:self.startTime] >= self.duration) {
        [link invalidate];
        [self hideLaunchScreen];
    }
}

#pragma mark - properties
- (void)setLaunchImage:(UIImage *)launchImage {
    _launchImage = launchImage;
    self.imgView.image = _launchImage;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.rootViewController.view addSubview:_imgView];
        self.rootViewController.view.backgroundColor = [UIColor clearColor];
    }
    return _imgView;
}

@end
