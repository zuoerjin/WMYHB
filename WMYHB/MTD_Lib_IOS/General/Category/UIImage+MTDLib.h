//
//  UIImage+MTDLib.h
//  MTDLib
//
//  Created by wangyc on 5/19/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MTDLib)

+ (UIImage*)imageFromView:(UIView*)view;
+ (UIImage *)imageWithColor:(UIColor *)aColor;
+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
+ (UIImage *)adaptImageNamed:(NSString *)imageName; //  如果是750*1334 默认去找name_6的图片 

#pragma mark - Scale

/**
 * Scale the image
 */
- (UIImage *)scaleWithScale:(float)scale;

#pragma mark - Transform

/**
 * Transform the image to custom size
 */
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;

/**
 * fix orientation of the image
 */
- (UIImage *)fixOrientation;

#pragma mark - Mosaic
/**
 * 转换成马赛克,level代表一个点转为多少level*level的正方形
 */
- (UIImage *)transToMosaicImageWithBlockLevel:(NSUInteger)level;

@end
