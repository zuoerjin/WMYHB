//
//  MAEmptyInfoView.h
//  MTDChem
//
//  Created by wangyc on 9/2/15.
//  Copyright (c) 2015 sci99. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAEmptyInfoView;

typedef void(^InfoViewTapAction)(MAEmptyInfoView *infoView);

typedef NS_ENUM(NSUInteger, EmptyInfoViewType) {
    EmptyInfoViewTypeServer,
    EmptyInfoViewTypeBadNetwork,
    EmptyInfoViewTypeNoNetwork,
    EmptyInfoViewTypeSearch,
    EmptyInfoViewTypeEmpty,
};

@interface MAEmptyInfoView : UIView

@property (nonatomic, copy) InfoViewTapAction infotap;

+ (instancetype)viewFromNib;

- (void)updateInfoWithViewType:(EmptyInfoViewType)type infoText:(NSString *)infoText subInfoText:(NSString *)subInfoText tapActionHandler:(InfoViewTapAction)handler;

- (void)upateInfoWithViewImage:(UIImage *)image infoText:(NSString *)infoText subInfoText:(NSString *)subInfoText tabActionHandler:(InfoViewTapAction)handler;

@end
