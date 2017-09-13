//
//  UIControl+MTDLib.h
//  MTDLib
//
//  Created by wangyc on 5/28/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIControlBlock)(UIControl *control);

@interface UIControl (MTDLib)

- (void)addActionBlock:(UIControlBlock)actionBlock forControlEvents:(UIControlEvents)event;
- (void)setActionBlock:(UIControlBlock)actionBlock forControlEvents:(UIControlEvents)event;

@end
