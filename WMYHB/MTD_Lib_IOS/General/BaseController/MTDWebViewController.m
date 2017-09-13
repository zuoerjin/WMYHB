//
//  MMWebViewController.m
//  MTDMetal
//
//  Created by wangyc on 6/12/15.
//  Copyright (c) 2015 SCI99. All rights reserved.
//

#import "MTDWebViewController.h"
#import "MTDUtility.h"
#import "MTDConsts.h"
#import "MTDDefines.h"
#import "MTDAdaptor.h"

@interface MTDWebViewController (){
    UIActivityIndicatorView *loadingView;
}

@end

@implementation MTDWebViewController

@synthesize loaded;

- (void)setupQueryData:(NSDictionary *)queryData {
    [super setupQueryData:queryData];
    // 如果未配置好urlString 则读取queryData中的url
    if (!self.urlString && !self.urlString.length) {
        self.urlString = [queryData stringValueForKey:kWebviewUrlStringKey defaultValue:nil];
    }
    
    if ([[queryData stringValueForKey:kWebViewShouldShare defaultValue:@"0"] isEqualToString:@"1"]) {
        self.shouldShare = YES;
        self.shareTitle = [queryData stringValueForKey:@"share_title" defaultValue:nil];
        self.shareUrlString = [queryData stringValueForKey:@"share_link" defaultValue:nil];
    }
    if ([[queryData stringValueForKey:kWebViewShouldHelp defaultValue:@"0"] isEqualToString:@"1"]) {
        self.shouldHelp = YES;
        self.helpUrlString = [queryData stringValueForKey:@"help_link" defaultValue:nil];
    }
    if ([[queryData stringValueForKey:kWebViewShouldShowNavigationBar defaultValue:@"0"]isEqualToString:@"1"]) {
        self.shouldHideNavigationBar = YES;
    }
    if ([[queryData stringValueForKey:kWebViewShouldSaveImageToAlbum defaultValue:@"0"]isEqualToString:@"1"]) {
        self.shouldSaveImageToAlbum = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self customBackBarButtonItems];
    [self customRightBarButtonItems];
    
    [self addPageRefreshNotification];
    
    if (!self.title && !self.title.length) {
        self.title = [self.pageQueryData stringValueForKey:kViewControllerTitleKey defaultValue:nil];
    }
    
    for (id subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIWebView class]]) {
            UIWebView *wb = subView;
            if (wb.delegate != self) {
                wb.delegate = self;
            }
        }
    }
    loaded = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (self.shouldHideNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
    [MTDUrlRouter sharedInstance].actionDelegate = self;
    
    if (!loaded) {
        [self refreshWebViewPage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideLoading];
    [self.webView stopLoading];
}

- (void)dealloc {
    [DefaultNotificationCenter removeObserver:self];
    self.webView.delegate = nil;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    [self.webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)addPageRefreshNotification {
    [DefaultNotificationCenter addObserver:self selector:@selector(refreshWebViewPage) name:@"kNetworkResumeAviliableNotification" object:nil];
    [DefaultNotificationCenter addObserver:self selector:@selector(refreshWebViewPage) name:kUserDidLoginNotification object:nil];
    [DefaultNotificationCenter addObserver:self selector:@selector(refreshWebViewPage) name:kUserDidLogoutNotification object:nil];
}

- (void)onBackAction:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - refresh web view

- (void)refreshWebViewPage {
    if (self.urlString) {
        self.urlString = [self getUrlStringByAppendingUserCommonParams:self.urlString];
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        [self.webView loadRequest:requset];
    }
}

// 修正url里边的userid等参数
- (NSString *)getUrlStringByAppendingUserCommonParams:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:URL_STRING(urlString)];
    NSString *baseUrlString = [[url.absoluteString componentsSeparatedByString:@"?"] firstObject];
    // 解析参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *paramPairs = [url.query componentsSeparatedByString:@"&"];
    
    for (NSString *paramPair in paramPairs) {
        NSArray *pairs = [paramPair componentsSeparatedByString:@"="];
        
        if (pairs.count == 2) {
            if (pairs[1] && [pairs[1] length]) {
                [params setObject:[pairs[1] URLDecodedString] forKey:pairs[0]];
            } else {
                [params setObject:pairs[1] forKey:pairs[0]];
            }
        }
    }
    // 公共参数
    if (HASLOGIN) {
        [params setObject:USERID forKey:@"user_id"];
        [params setObject:ACCESSTOKEN forKey:@"access_token"];
        // 老版本key
        [params setObject:USERID forKey:@"userid"];
        [params setObject:ACCESSTOKEN forKey:@"Access_Token"];
    }
    [params setObject:DEVICETYPE forKey:@"device_type"];
    [params setObject:DEVICETOKEN forKey:@"device_token"];
    [params setObject:[[MTDAdaptor defaultAdaptor] productType] forKey:@"product_type"];
    [params setObject:VERSION forKey:@"version"];
    // 老版本页面key
    [params setObject:[[MTDAdaptor defaultAdaptor] productType] forKey:@"producttype"];
    [params setObject:DEVICETYPE forKey:@"devicetype"];
    // 移除自带的sign参数，然后对剩余的参数签名
    [params removeObjectForKey:@"sign"];
    params = [NSMutableDictionary dictionaryWithDictionary:[MTDUtility commonPostDicForParams:params]];
    // 整理url
    NSString *correctUrlString;
    BOOL firstParams = YES;
    
    for (NSString *key in [params allKeys]) {
        NSString *value = [[params stringValueForKey:key defaultValue:nil] URLEncodedString];
        
        if (value) {
            if (firstParams) {
                correctUrlString = [baseUrlString stringByAppendingFormat:@"?%@=%@", key, value];
                firstParams = NO;
            } else {
                correctUrlString = [correctUrlString stringByAppendingFormat:@"&%@=%@", key, value];
            }
        }
    }
    return correctUrlString;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
#if DEBUG
    NSLog(@"%@", request.URL.absoluteString);
#endif
    if ([[[request URL] absoluteString] hasPrefix:@"mtd"]) {
        [self handleOpenUrl:request.URL.absoluteString];
        return NO;
        
    }
    if ([[[request URL] absoluteString] hasPrefix:@"data"]) {
        [self saveImageToPhotoAlbum:[[request URL] absoluteString]];
        return NO;
    }
    [self didFinishProcessLinkParameters:[MTDUtility generateParamsFromParameterString:[[request URL] query]]];
    return YES;
}

- (void)webViewDidStartLoad:(nonnull UIWebView *)webView {
    [self hideErrorMessage];
    [self showLoading];
}

- (void)webViewDidFinishLoad:(nonnull UIWebView *)webView {
    loaded = YES;
    // 禁用长按弹自定义菜单
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self hideLoading];
    if (!self.title) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    // 解决UIWebView存在内存泄漏的问题
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [self hideLoading];
    [self loadFailedWithError:error];
}

#pragma mark - action

- (void)handleOpenUrl:(NSString *)urlString {
    [[MTDUrlRouter sharedInstance] handleOpenUrl:urlString];
}

- (void)loadFailedWithError:(NSError *)error {
    NSLog(@"%@",error.domain);
}

- (void)hideErrorMessage {
    
}

- (void)didFinishProcessLinkParameters:(NSDictionary *)params {
#if DEBUG
    NSLog(@"params : %@",params);
#endif
}

#pragma mark - Save Image

- (void)saveImageToPhotoAlbum:(NSString *)imgUrl {
    // 保存图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        UIImage *image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
   });
}
// 保存图片的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self imageSavedWithImage:image Error:error];
}

- (void)imageSavedWithImage:(UIImage *)image Error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error.domain);
    } else {
        NSLog(@"图片保存成功");
    }
}

#pragma mark - open new page

- (void)showHelp {
    if (self.helpUrlString) {
        [[MTDPageManager defaultManager]openUrl:kPageUrlWebViewController withQueryData:@{kViewControllerTitleKey:self.title, kWebviewUrlStringKey:self.helpUrlString}];
    } else {
        NSLog(@"help urlString is nil");
    }
}

#pragma mark - private
- (void)showLoading {
    if (!loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 30);
        loadingView.hidesWhenStopped = YES;
        [self.view addSubview:loadingView];
    }
    loadingView.hidden = NO;
    [loadingView startAnimating];
}

- (void)hideLoading {
    [loadingView stopAnimating];
}

- (void)customBackBarButtonItems {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? -6 : 5;
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_backBtn setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_backBtn addTarget:self action:@selector(onBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 22)];
    self.navigationItem.leftBarButtonItems = @[spacer, [[UIBarButtonItem alloc] initWithCustomView:_backBtn]];
}

- (void)customRightBarButtonItems {
    NSMutableArray *rightItems = [NSMutableArray array];
    
    if (self.shouldShare) {
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [shareBtn setImage:[UIImage imageNamed:@"ic_nav_share"] forState:UIControlStateNormal];
        if ([self respondsToSelector:@selector(share:)]) {
            [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            NSLog(@"unsupport action (share:)");
        }
        [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        [rightItems addObject:shareItem];
    }
    
    if (self.shouldHelp) {
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [helpBtn setImage:[UIImage imageNamed:@"ic_nav_help"] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
        [helpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithCustomView:helpBtn];
        [rightItems addObject:helpItem];
    }
    [self.navigationItem setRightBarButtonItems:rightItems];
}

@end
