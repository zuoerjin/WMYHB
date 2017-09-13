//
//  MMWebViewController.h
//  MTDMetal
//
//  Created by wangyc on 6/12/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import "MTDBaseViewController.h"
#import "MTDUrlRouter.h"

@interface MTDWebViewController : MTDBaseViewController<UIWebViewDelegate, MTDWebViewActionDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) BOOL shouldSaveImageToAlbum;
@property (nonatomic, assign) BOOL shouldHideNavigationBar;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

/**
 * 是否显示navigationBar的分享按钮，默认为NO
 */
@property (nonatomic, assign) BOOL shouldShare;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareUrlString;
// load 成功标识
@property (nonatomic, assign) BOOL loaded;
/**
 * 是否显示NavigationBar的帮助按钮，默认为NO
 */
@property (nonatomic, assign) BOOL shouldHelp;
@property (nonatomic, strong) NSString *helpUrlString;

- (void)customRightBarButtonItems;
- (void)customBackBarButtonItems;

- (void)refreshWebViewPage;
- (void)onBackAction:(id)sender;
- (void)handleOpenUrl:(NSString *)urlString;
- (void)hideErrorMessage;
- (void)loadFailedWithError:(NSError *)error;
- (void)didFinishProcessLinkParameters:(NSDictionary *)params;
- (void)imageSavedWithImage:(UIImage *)image Error:(NSError *)error;

@end
