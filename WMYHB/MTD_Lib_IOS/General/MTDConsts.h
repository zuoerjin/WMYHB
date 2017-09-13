//
//  MTDConsts.h
//  MTDLib
//
//  Created by 张志彬 on 16/7/6.
//  Copyright © 2016年 MTD. All rights reserved.
//

#ifndef MTDConsts_h
#define MTDConsts_h

static NSString *const k400ServicePhone = @"400-811-5599";
static NSString *const k400ServiceName = @"全国统一服务热线";

// global key （新增kPreViewControllerClassKey记录之前页面）
static NSString *const kWebviewUrlStringKey = @"link";
static NSString *const kViewControllerTitleKey = @"title";
static NSString *const kBaiduPageKey = @"baiduPage";

// webView
static NSString *const kWebViewShouldShare = @"share";
static NSString *const kWebViewShouldHelp = @"help";
static NSString *const kWebViewShouldShowNavigationBar = @"kWebViewShouldShowNavigationBar";
static NSString *const kWebViewShouldSaveImageToAlbum = @"WebViewShouldSaveImageToAlbum";
static NSString *const kWebViewShouldOpenURLInSafari = @"new_window";
//正文获取所需参数
static NSString *const kArticalParaNewsIdKey = @"newskey";
static NSString *const kArticalParaInfoTypeKey = @"infotype";
static NSString *const kArticalParaIfNeedShowBottomBarKey = @"if_need_show_bottom_bar";
//正文图片全屏显示相关通知
static NSString *const kNotficationNameFullImageDismiss = @"notficationName_fullImageDismiss";

// 热点推送
static NSString *const kHotPushKey = @"hot_push_bool";
static NSString *const kHotPushNotification = @"hot_push_notification";

/**
 * Notification:产品订阅模块联动刷新
 */
static NSString *const kNotficationNameReloadSlideOrderList = @"reloadSlideOrderList" ;
// 侧滑页面
static NSString *const kSlideMainViewControlerIdentifier = @"kSlideMainViewControlerIdentifier";
static NSString *const kSlideSideViewControlerIdentifier = @"kSlideSideViewControlerIdentifier";
static NSString *const kSlideMainViewControllerIsNavigation = @"kSlideMainViewControllerIsNavigation";
static NSString *const kSlideViewControlerShowNavigationBar = @"kSlideViewControllerShowNavigationBar";
/**
 * 隐藏导航栏标题下拉菜单
 */
static NSString *const kNotificationNameHideClassificationView = @"kNotificationNameHideClassificationView";
/**
 * 登录
 */
static NSString *const kNotficationNameLogin = @"kNotficationNameLogin";
/**
 * 修改密码
 */
static NSString *const kNotficationNameChangePWDSucceed = @"kNotficationName_ChangePWDSucceed";
/**
 * 在其他设备登陆
 */
static NSString *const kNotficationNameLoginOtherDevice = @"kNotficationNameLoginOtherDevice";
/**
 * 返回上一页并弹其他设备登录框
 */
static NSString *const kNotficationNameBackRelogin = @"kNotficationNameBackRelogin";
/**
 * 价格库权限过期
 */
static NSString *const kNotficationNamePowerIsOutOfDate = @"kNotficationNamePowerIsOutOfDate";
/**
 * webView share
 */
static NSString *const kNotficationNameWebViewShareAction = @"kNotficationNameWebViewShareAction";
/**
 * webView goBack
 */
static NSString *const kNotficationNameWebViewBackAction = @"kNotficationNameWebViewBackAction";
/**
 * 产品中心页
 */
static NSString *const kNotficationNameProductList = @"kNotficationNameProductList";
/**
 * 带交互的Web页
 */
static NSString *const kPageUrlWebViewController = @"webview_with_native";
/**
 * 不带交互的Web页
 */
static NSString *const kPageUrlSimpleWebViewController = @"simple_webview";
/**
 * 产品列表
 */
static NSString *const kPageUrlProductList = @"product_list";
/**
 * 卓创与部委页面标题
 */
static NSString *const kGovDetailPageTitleKey = @"name";
/**
 * 卓创与部委页面类型
 */
static NSString *const kGovDetailPageTypeKey = @"gov_page_type";
/**
 * 价格库页面类型
 */
static NSString *const kPricePageTypeKey = @"price_page_type";
/**
 * 高端咨询类型
 */
static NSString *const kConsultPageTypeKey = @"consult_page_type";
/**
 * 价格库baseURL
 */
static NSString *const priceBaseHostURL = @"https://mapi.sci99.com/price/1/";

// notifications
static NSString *const kUserDidLoginNotification = @"kUserDidLoginNotification";
static NSString *const kUserDidLogoutNotification = @"kUserDidLogoutNotification";
static NSString *const kUserPowerDidFinishRefreshNotification = @"kUserPowerDidFinishRefreshNotification";
static NSString *const kUserDidLoginNotification_AccessTokenError = @"kUserDidLoginNotification_AccessTokenError";
static NSString *const kUserCollectInformationSuccessfully = @"kUserCollectInformationSuccessfully";
static NSString *const kUserCollectInformationSuccessfully_sx = @"kUserCollectInformationSuccessfully_sx"; // 商讯收藏
static NSString *const kUserCollectInformationSuccessfully_jgk = @"kUserCollectInformationSuccessfully_jgk"; // 商讯收藏
static NSString *const kHomePageDidAppearNotification = @"kHomePageDidAppearNotification";
static NSString *const kDidReceiveNewPushNewsNotification = @"kDidReceiveNewPushNewsNotification";
static NSString *const kTabControllerChangePage = @"kTabControllerChangePage";

// badge
static NSString const *badgeKey = @"badgeKey";
static NSString const *badgeBGColorKey = @"badgeBGColorKey";
static NSString const *badgeTextColorKey = @"badgeTextColorKey";
static NSString const *badgeFontKey = @"badgeFontKey";
static NSString const *badgePaddingKey = @"badgePaddingKey";
static NSString const *badgeMinSizeKey = @"badgeMinSizeKey";
static NSString const *badgeOriginXKey = @"badgeOriginXKey";
static NSString const *badgeOriginYKey = @"badgeOriginYKey";
static NSString const *badgeRightMarginKey = @"badgeRightMarginKey";
static NSString const *badgeTopMarginKey = @"badgeTopMarginKey";
static NSString const *shouldHideBadgeAtZeroKey = @"shouldHideBadgeAtZeroKey";
static NSString const *shouldAnimateBadgeKey = @"shouldAnimateBadgeKey";
static NSString const *badgeValueKey = @"badgeValueKey";

//信息类型
typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypeSelected = 1, // 精选资讯
    NewsTypeByProduct = 2, // 按产品获取
    NewsTypeByColumn = 3, // 按栏目获取
    NewsTypeCollect = 6, // 收藏
    NewsTypeHot = 7, // 热点
    NewsTypePublic = 8, // 公共信息
    NewsTypePoint = 9, // 卓创视点
    NewsTypeHomeSelected = 12, // 3.2版本 新增首页精选资讯（为了fix上一条下一条不对的bug
};

typedef enum{
    BusinessNewsTypeAll = 0,
    BusinessNewsTypeBuy = 1,
    BusinessNewsTypeSell = 2
}BusinessNewsType;

// 卓创与部委 页面类型
typedef enum{
    GovPageNone = 0,
    GovPageFGVSteel = 1,
    GovPageFGVMetal = 2,
    GovPageFGVZSJD = 3,
    GovPageTJJ = 4,
    // 化工
    GovPageFGVJGBD = 5,
    GovPageTJJJGHZ = 6,
    GovPageZCYW = 7,
    GovPageCPYZS = 8,
}GovPageClass;

typedef enum{
    PricePageNone = 0,
    PricePageWeek = 1,
    PricePageMonth = 2
}PricePageClass;

typedef enum{
    ConsultPageNone = 0,
    ConsultPageReport = 1,
    ConsultPageCase = 2
}ConsultPageClass;

#endif /* MTDConsts_h */
