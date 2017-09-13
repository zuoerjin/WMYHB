//
//  MTDPageManager.h
//  MTDLib
//
//  Created by wangyc on 11/3/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDPageMap.h"

@interface MTDPageManager : NSObject

+ (instancetype)defaultManager;
- (id)openUrl:(NSString *)url withQueryData:(NSDictionary *)queryData;

@end
