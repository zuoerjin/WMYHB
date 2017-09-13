//
//  MTDCollectionViewCell.h
//  MTDLib
//
//  Created by zhangzb on 2017/5/4.
//  Copyright © 2017年 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) id cellDataObj;

@property (strong, nonatomic) NSIndexPath *itemIndexPath;

+ (CGSize)cellSizeForCellDataObj:(id)cellDataObj;

// for sub class
- (BOOL)shouldUpdateUIWithOriginCellData:(id)originDataObj newsetCellData:(id)newsetCellData; // 默认返回YES
- (void)updateUI;

@end
