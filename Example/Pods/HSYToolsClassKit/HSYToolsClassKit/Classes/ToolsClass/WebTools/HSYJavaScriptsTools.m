//
//  HSYJavaScriptsTools.m
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/20.
//

#import "HSYJavaScriptsTools.h"

@implementation HSYJavaScriptsTools

#pragma mark - Cookies

+ (void)hsy_deleteAllCookies:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

+ (void)hsy_setCookies:(NSArray<NSDictionary *> *)cookies
{
    for (NSDictionary *cookieDictionary in cookies) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

+ (NSDictionary *)hsy_setDefaultCookies:(NSString *)urlString defaultsCookie:(NSDictionary *)cookie
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *host = url.host;
    NSString *path = url.path;
    NSNumber *port = url.port;
    NSMutableDictionary *cookies = [@{NSHTTPCookieName : cookie.allKeys.firstObject, NSHTTPCookieValue : cookie.allValues.firstObject, } mutableCopy];
    if (host.length > 0) {
        cookies[NSHTTPCookieDomain] = host;
    }
    if (path.length > 0) {
        cookies[NSHTTPCookiePath] = path;
    }
    if (port) {
        cookies[NSHTTPCookiePort] = port;
    }
    return cookies;
}

#pragma mark - Configs

+ (WKWebViewConfiguration *)hsy_webViewConfiguration:(NSArray<WKUserScript *> *)userScripts
                            addScriptMessageHandlers:(NSDictionary<id, NSArray<NSString *> *> *)scriptMessageHandlers
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContent = [[WKUserContentController alloc] init];
    if (userScripts.count > 0) {
        for (WKUserScript *userScript in userScripts) {
            [userContent addUserScript:userScript];
        }
    }
    if (scriptMessageHandlers) {
        id<WKScriptMessageHandler>delegate = scriptMessageHandlers.allKeys.firstObject;
        NSArray<NSString *> *scriptHandlers = scriptMessageHandlers.allValues.firstObject; 
        for (NSString *script in scriptHandlers) {
            [userContent addScriptMessageHandler:delegate name:script];
        }
    }
    configuration.userContentController = userContent;
    return configuration;
}

@end
