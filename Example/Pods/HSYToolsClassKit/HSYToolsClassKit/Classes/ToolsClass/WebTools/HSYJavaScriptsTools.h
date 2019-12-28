//
//  HSYJavaScriptsTools.h
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/20.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kHSYJavaScriptsToolsLoadType) {
    
    kHSYJavaScriptsToolsLoadTypeUrlString           = 0,        //完整的url地址
    kHSYJavaScriptsToolsLoadTypeHTMLString,                     //html网页的string
    kHSYJavaScriptsToolsLoadTypeHTMLFilePath,                   //html文件地址
    
};

@interface HSYJavaScriptsTools : NSObject

@property (nonatomic, assign) kHSYJavaScriptsToolsLoadType loadType;

/**
 删除某个HTTP地址的cookies，适用于UIWebView，WKWebView不支持
 
 @param urlString 完整的url地址
 */
+ (void)hsy_deleteAllCookies:(NSString *)urlString;

/**
 设置HTTP多个的cookies，适用于UIWebView，WKWebView不支持
 
 @param cookies cookies内容，格式为@[@{@"cookieA--key" : id}, @{@"cookieA--key" : id}, ...]，其中，cookie--key取值为：@[NSHTTPCookieName, NSHTTPCookieValue, NSHTTPCookieOriginURL, NSHTTPCookieVersion, NSHTTPCookieDomain, NSHTTPCookiePath, NSHTTPCookieSecure, NSHTTPCookieExpires, NSHTTPCookieComment, NSHTTPCookieCommentURL, NSHTTPCookieDiscard, NSHTTPCookieMaximumAge, NSHTTPCookiePort]
 */
+ (void)hsy_setCookies:(NSArray<NSDictionary *> *)cookies;

/**
 添加js对native的观察及注入js到web中

 @param userScripts 向web中注入JavaScript，格式为：@[WKUserScript_A, WKUserScript_B, ...]
 @param scriptMessageHandlers 向web中添加监听，格式为：@{id<添加过WKScriptMessageHandler委托的对像>delegate : @[@"JavaScript方法A", @"JavaScript方法B", ...]}
 @return 返回WKWeb的WKWebViewConfiguration配置项信息
 */
+ (WKWebViewConfiguration *)hsy_webViewConfiguration:(NSArray<WKUserScript *> *)userScripts
                            addScriptMessageHandlers:(NSDictionary<id, NSArray<NSString *> *> *)scriptMessageHandlers;

@end

NS_ASSUME_NONNULL_END
