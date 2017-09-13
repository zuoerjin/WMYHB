//
//  MTDPageMap.m
//  MTDLib
//
//  Created by wangyc on 11/3/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import "MTDPageMap.h"
#import "NSDictionary+MTDLib.h"

@interface MTDPageMap ()

@property (nonatomic, strong) NSMutableDictionary *pageCacheDic;

@end

@implementation MTDPageMap

+ (instancetype)defaultMap {
    static id _s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_instance = [self new];
    });
    return _s_instance;
}

- (void)appendPageUrl:(NSString *)pageUrl withPageInfoObj:(MTDPageMetaInfo *)pageInfoObj {
    if (pageUrl.length > 0 && [pageInfoObj isKindOfClass:[MTDPageMetaInfo class]]) {
        [self.pageCacheDic setObject:pageInfoObj forKey:pageUrl];
    }
}

- (MTDPageMetaInfo *)pageMetaInfoForPageUrl:(NSString *)pageUrl {
    if (pageUrl.length > 0) {
        return [self.pageCacheDic objectForKey:pageUrl ofClass:[MTDPageMetaInfo class] defaultObj:nil];
    }
    return nil;
}

/// setup controller create from code
+ (MTDPageMetaInfo *)appendPageUrl:(NSString *)pageUrl withPageClassString:(NSString *)classString openType:(PageOpenType)openType cacheType:(PageCacheType)cacheType {
    if (pageUrl.length > 0 && classString.length > 0) {
        
        MTDPageMetaInfo *pageObj = [MTDPageMetaInfo new];
        pageObj.pageUrlString = pageUrl;
        pageObj.pageClassNameString = classString;
        pageObj.openType = openType;
        pageObj.cacheType = cacheType;
        pageObj.sourceType = PageSourceTypeCode;
        pageObj.animated = YES;
        
        [[self defaultMap] appendPageUrl:pageUrl withPageInfoObj:pageObj];
        
        return pageObj;
    }
    return nil;
}

/// setup controller create from nib
+ (MTDPageMetaInfo *)appendPageUrl:(NSString *)pageUrl withNibName:(NSString *)nibName pageClassString:(NSString *)classString openType:(PageOpenType)openType cacheType:(PageCacheType)cacheType {
    if (pageUrl.length > 0 && nibName.length > 0) {
        
        MTDPageMetaInfo *pageObj = [MTDPageMetaInfo new];
        pageObj.pageUrlString = pageUrl;
        pageObj.pageNibName = nibName;
        pageObj.pageClassNameString = classString;
        pageObj.openType = openType;
        pageObj.cacheType = cacheType;
        pageObj.sourceType = PageSourceTypeNib;
        pageObj.animated = YES;
        
        [[self defaultMap] appendPageUrl:pageUrl withPageInfoObj:pageObj];
        
        return pageObj;
    }
    return nil;
}

/// setup controller create from storyboard
+ (MTDPageMetaInfo *)appendPageUrl:(NSString *)pageUrl withStoryboardName:(NSString *)storyboardName idString:(NSString *)idString openType:(PageOpenType)openType cacheType:(PageCacheType)cacheType {
    
    if (pageUrl.length > 0 && idString.length > 0) {
        
        MTDPageMetaInfo *pageObj = [MTDPageMetaInfo new];
        pageObj.pageUrlString = pageUrl;
        pageObj.pageStoryboardName = storyboardName;
        pageObj.identifier = idString;
        pageObj.openType = openType;
        pageObj.cacheType = cacheType;
        pageObj.sourceType = PageSourceTypeStoryboard;
        pageObj.animated = YES;
        
        [[self defaultMap] appendPageUrl:pageUrl withPageInfoObj:pageObj];
        
        return pageObj;
    }
    return nil;
}

#pragma mark - properties
- (NSMutableDictionary *)pageCacheDic {
    if (!_pageCacheDic) {
        _pageCacheDic = [[NSMutableDictionary alloc] init];
    }
    return _pageCacheDic;
}

@end
