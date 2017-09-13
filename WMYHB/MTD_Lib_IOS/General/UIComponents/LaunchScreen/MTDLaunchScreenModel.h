//
//  MTDLaunchScreenModel.h
//  MTDLib
//
//  Created by wangyc on 12/8/15.
//  Copyright © 2015 MTD. All rights reserved.
//

#import "MTDBaseModel.h"

extern NSString *const kMTDLaunchScreenInfoDicKey;

@interface MTDLaunchScreenModel : MTDBaseModel

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, copy) NSString *fileFolderPath;
@property (nonatomic, copy) NSString *imageFilePath;

- (BOOL)shouldDisplayLaunchScreenFromLocal;
- (id)refreshLaunchScreenInfoFromServer;
- (UIImage *)imageFromLocalFile;

@end
