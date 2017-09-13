//
//  MTDTableViewCell.m
//  MTDLib
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import "MTDTableViewCell.h"

@implementation MTDTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setCellDataObj:(id)cellDataObj {
    id originData = _cellDataObj;
    _cellDataObj = cellDataObj;
    
    if ([self shouldUpdateUIWithOriginCellData:originData newsetCellData:cellDataObj]) {
        [self updateUI];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

+ (CGFloat)cellHeightForDataObj:(id)celldataObj {
    return 0;
}

- (BOOL)shouldUpdateUIWithOriginCellData:(id)originDataObj newsetCellData:(id)newsetCellData {
    return YES;
}

- (void)updateUI {
    
}

@end
