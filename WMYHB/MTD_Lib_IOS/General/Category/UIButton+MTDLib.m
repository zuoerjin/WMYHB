//
//  UIButton+MTDLib.m
//  MTDLib
//
//  Created by zhangzb on 2017/3/17.
//  Copyright © 2017年 MTD. All rights reserved.
//

#import "UIButton+MTDLib.h"

@implementation UIButton (MTDLib)

- (void)fixWithdistance:(NSInteger)distance {
    [self setImageEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - distance / 2, 0, 0, -self.titleLabel.intrinsicContentSize.width)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.currentImage.size.height + distance / 2, -self.currentImage.size.width, 0, 0)];
}

@end
