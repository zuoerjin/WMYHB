//
//  MTDCollectionViewCell.m
//  MTDLib
//
//  Created by zhangzb on 2017/5/4.
//  Copyright © 2017年 MTD. All rights reserved.
//

#import "MTDCollectionViewCell.h"

@implementation MTDCollectionViewCell

+ (CGSize)cellSizeForCellDataObj:(id)cellDataObj; {
    return CGSizeMake(0, 0);
}

- (void)setCellDataObj:(id)cellDataObj {
    id originData = _cellDataObj;
    _cellDataObj = cellDataObj;
    
    if ([self shouldUpdateUIWithOriginCellData:originData newsetCellData:cellDataObj]) {
        [self updateUI];
    }
}

- (BOOL)shouldUpdateUIWithOriginCellData:(id)originDataObj newsetCellData:(id)newsetCellData {
    return YES;
}

- (void)updateUI {
    
}

@end
