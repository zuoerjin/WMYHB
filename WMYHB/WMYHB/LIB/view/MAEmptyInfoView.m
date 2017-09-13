//
//  MAEmptyInfoView.m
//  MTDChem
//
//  Created by wangyc on 9/2/15.
//  Copyright (c) 2015 sci99. All rights reserved.
//

#import "MAEmptyInfoView.h"

@interface MAEmptyInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *subInfoLabel;
@property (nonatomic, copy) InfoViewTapAction tapAction;

@end

@implementation MAEmptyInfoView

+ (instancetype)viewFromNib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.infoLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30 * 2;
    self.subInfoLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30 * 2;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
}

- (void)updateInfoWithViewType:(EmptyInfoViewType)type infoText:(NSString *)infoText subInfoText:(NSString *)subInfoText tapActionHandler:(InfoViewTapAction)handler {
    
    self.tapAction = handler;
    self.infoLabel.text = infoText;
    self.subInfoLabel.text = subInfoText;
    
    switch (type) {
        case EmptyInfoViewTypeBadNetwork:
            self.iconView.image = [UIImage imageNamed:@"info_icon_network"];
            
            break;
            
        case EmptyInfoViewTypeNoNetwork:
            self.iconView.image = [UIImage imageNamed:@"info_icon_wifi"];
            
            break;
            
        case EmptyInfoViewTypeSearch:
            self.iconView.image = [UIImage imageNamed:@"info_icon_search"];
            
            break;
            
        case EmptyInfoViewTypeServer:
            self.iconView.image = [UIImage imageNamed:@"info_icon_cloud"];
            
            break;
            
        case EmptyInfoViewTypeEmpty:
            self.iconView.image = [UIImage imageNamed:@"info_icon_empty"];
            
            break;
            
        default:
            self.iconView.image = [UIImage imageNamed:@"info_icon_cloud"];
            
            break;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)upateInfoWithViewImage:(UIImage *)image infoText:(NSString *)infoText subInfoText:(NSString *)subInfoText tabActionHandler:(InfoViewTapAction)handler {
    
    self.tapAction = handler;
    self.infoLabel.text = infoText;
    self.subInfoLabel.text = subInfoText;
    self.iconView.image = image;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - action

- (void)viewTapped:(id)sender {
    if (self.tapAction) {
        self.tapAction(self);
    }
    
    _infotap(self);
}

@end
