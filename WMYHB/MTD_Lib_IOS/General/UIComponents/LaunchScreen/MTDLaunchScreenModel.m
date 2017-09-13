//
//  MTDLaunchScreenModel.m
//  MTDLib
//
//  Created by wangyc on 12/8/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import "MTDLaunchScreenModel.h"

NSString *const kMTDLaunchScreenInfoDicKey = @"kMTDLaunchScreenInfoDicKey";

@interface MTDLaunchScreenModel ()

@end

@implementation MTDLaunchScreenModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kMTDLaunchScreenInfoDicKey];
    }
    return self;
}

- (BOOL)shouldDisplayLaunchScreenFromLocal {
    // 判断本地缓存、缓存是否过期
    NSString *filePath = self.imageFilePath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }
    
    NSDate  *endDate = [[MTDUtility sharedInstance] dateFromTimestrampString:[self.infoDic stringValueForKey:@"endtime" defaultValue:nil]];
    if ([endDate timeIntervalSinceDate:[NSDate date]] <= 0) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        return NO;
    }
    
    return YES;
}

- (UIImage *)imageFromLocalFile {
    NSString *filePath = self.imageFilePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[UIImage alloc] initWithContentsOfFile:filePath];
    }
    
    return nil;
}

- (id)refreshLaunchScreenInfoFromServer {
    if ([MTDNetworkManager hasNetwork]) {
        WEAK_SELF_DEFINE(pSelf);
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat scale = [UIScreen mainScreen].scale;
        NSDictionary *param = @{
                                @"size": [NSString stringWithFormat:@"%@*%@", @(screenSize.height * scale), @(screenSize.width * scale)]
                                };
                
        return [self getRequestWithParams:param apiPath:@"getstartscreen" completeHandler:NULL successAFCallback:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
            MTDApiRetObj *retObj = [MTDApiRetObj processResultDic:responseObject error:&error];
            
            if (!error && [retObj.infoObj isKindOfClass:[NSDictionary class]]) {
                pSelf.infoDic = retObj.infoObj;
                [pSelf downloadImageFileIfNeeded];
            } else {
                pSelf.infoDic = nil;
            }

        }];
    }
    return nil;
}

- (void)downloadImageFileIfNeeded {
    NSString *fileUrl = [self.infoDic stringValueForKey:@"picurl" defaultValue:nil];
    NSString *hash = [self.infoDic stringValueForKey:@"pichash" defaultValue:nil];
    NSString *imagePath = [self.fileFolderPath stringByAppendingPathComponent:hash];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        return;
    }
    
    if (fileUrl.length > 0) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:fileUrl] options:SDWebImageDownloaderContinueInBackground | SDWebImageDownloaderHighPriority progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (!error && data.length > 0) {
                [data writeToFile:imagePath atomically:YES];
            }
        }];
    }
}

#pragma mark - properties
- (void)setInfoDic:(NSDictionary *)infoDic {
    if (![_infoDic isEqualToDictionary:infoDic]) {
        // remove old files
        NSString *hash = [_infoDic stringValueForKey:@"pichash" defaultValue:nil];
        NSString *imagePath = [self.fileFolderPath stringByAppendingPathComponent:hash];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
        }
        
        _infoDic = infoDic;

        if (_infoDic) {
            [[NSUserDefaults standardUserDefaults] setObject:_infoDic forKey:kMTDLaunchScreenInfoDicKey];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMTDLaunchScreenInfoDicKey];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)fileFolderPath {
    NSString *docPath = [MTDUtility documentDirString];
    NSString *folderPath = [docPath stringByAppendingPathComponent:@"launchScreens"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return folderPath;
}

- (NSString *)imageFilePath {
    NSString *hash = [self.infoDic stringValueForKey:@"pichash" defaultValue:nil];
    if (hash.length > 0) {
        return  [self.fileFolderPath stringByAppendingPathComponent:hash];
    }
    
    return @"";
}

@end
