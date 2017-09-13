//
//  NSDate+MTDLib.m
//  MTDLib
//
//  Created by wangyc on 6/5/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import "NSDate+MTDLib.h"

NSDateFormatter *sharedDateFormatter() {
    static NSDateFormatter *_s_dateformatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_dateformatter = [[NSDateFormatter alloc] init];
    });
    return _s_dateformatter;
}

@implementation NSDate (MTDLib)

- (NSString *)apiDateString {
    NSDateFormatter *fmt = sharedDateFormatter();
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt stringFromDate:self];
}

@end
