//
//  MTDTableViewCell.h
//  MTDLib
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDTableViewCell : UITableViewCell

@property (nonatomic, strong) id cellDataObj;

+ (CGFloat)cellHeightForDataObj:(id)celldataObj;

// for sub class
- (BOOL)shouldUpdateUIWithOriginCellData:(id)originDataObj newsetCellData:(id)newsetCellData; // 默认返回YES
- (void)updateUI;

@end
