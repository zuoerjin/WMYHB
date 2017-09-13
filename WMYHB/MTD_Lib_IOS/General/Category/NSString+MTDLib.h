//
//  NSString+MTDLib.h
//  MTDLib
//
//  Created by wangyc on 6/8/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MTDLib)

- (BOOL)isValidEmail;
/**
 * 固话 & 手机
 */
- (BOOL)isValidPhoneNumber;
/**
 * 固话
 */
- (BOOL)isValidTelephoneNumber;
/**
 * 手机
 */
- (BOOL)isValidMobilePhoneNumber;
/**
 * 传真
 */
- (BOOL)isValidFaxNumber;

- (NSString *)trim;
// remove html tag
- (NSString *)stringByStrippingHTML;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSString *)MD5String;
- (NSString *)SHA256;
- (NSString *)SHA256WithKey:(NSString *)key;

/*!
 @brief 中文转换为拼音字母
 */

- (NSString *)toPinYin;

- (NSString *)toDateStringWithFormat:(NSString *)dateFormat;

@end
