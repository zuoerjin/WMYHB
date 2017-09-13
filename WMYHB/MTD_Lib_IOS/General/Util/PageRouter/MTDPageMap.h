//
//  MTDPageMap.h
//  MTDLib
//
//  Created by wangyc on 11/3/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDPageMetaInfo.h"

@interface MTDPageMap : NSObject

+ (instancetype)defaultMap;
- (void)appendPageUrl:(NSString *)pageUrl withPageInfoObj:(MTDPageMetaInfo *)pageInfoObj;
- (MTDPageMetaInfo *)pageMetaInfoForPageUrl:(NSString *)pageUrl;

/// setup controller create from code
+ (MTDPageMetaInfo *)appendPageUrl:(NSString *)pageUrl withPageClassString:(NSString *)classString openType:(PageOpenType)openType cacheType:(PageCacheType)cacheType;

/// setup controller create from nib
+ (MTDPageMetaInfo *)appendPageUrl:(NSString *)pageUrl withNibName:(NSString *)nibName pageClassString:(NSString *)classString openType:(PageOpenType)openType cacheType:(PageCacheType)cacheType;

/// setup controller create from storyboard
+ (MTDPageMetaInfo *)appendPageUrl:(NSString *)pageUrl withStoryboardName:(NSString *)storyboardName idString:(NSString *)idString openType:(PageOpenType)openType cacheType:(PageCacheType)cacheType;

@end
