//
//  HSYNetworkTools.h
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import <Foundation/Foundation.h>
#import "HSYNetworkRequest.h" 
#import "AFHTTPSessionManager+RACSignal.h"
#import "AFURLSessionManager+RACSignal.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *HSYNetworkingToolsBaseUrl;
FOUNDATION_EXPORT HSYNetworkingToolsBaseUrl const _Nullable HSYNetworkingToolsBaseUrlStringForKey;

typedef NSString *HSYNetworkingToolsHttpSession;
FOUNDATION_EXPORT HSYNetworkingToolsHttpSession const _Nullable HSYNetworkingToolsHttpRequestSerializerForKey;
FOUNDATION_EXPORT HSYNetworkingToolsHttpSession const _Nullable HSYNetworkingToolsHttpResponseSerializerForKey;
FOUNDATION_EXPORT HSYNetworkingToolsHttpSession const _Nullable HSYNetworkingToolsHttpRequestCachePolicyForKey;
FOUNDATION_EXPORT HSYNetworkingToolsHttpSession const _Nullable HSYNetworkingToolsHttpRequestTimeoutForKey;
FOUNDATION_EXPORT HSYNetworkingToolsHttpSession const _Nullable HSYNetworkingToolsHttpResponseContentTypesForKey;
FOUNDATION_EXPORT HSYNetworkingToolsHttpSession const _Nullable HSYNetworkingToolsHttpRequestHeadersForKey;

typedef NSString *HSYNetworkingToolsUrlSession;
FOUNDATION_EXPORT HSYNetworkingToolsUrlSession const _Nullable HSYNetworkingToolsUrlResponseSerializerForKey;
FOUNDATION_EXPORT HSYNetworkingToolsUrlSession const _Nullable HSYNetworkingToolsUrlSecurityPolicyForKey;

@class RACSignal, HSYNetworkResponse;
@interface HSYNetworkTools : NSObject

/**
 单例
 
 @return XQCNetworkingTools
 */
+ (instancetype)sharedInstance;

/**
 清空请求头的信息
 */
- (void)hsy_clearAllHeaders;

#pragma mark - Configs

/**
 配置base-url的域名地址
 
 @param configs 配置项，@{kXQCNetworkingToolsBaseUrl : @"http://..."}
 */
- (void)hsy_baseUrlStringConfigs:(NSDictionary<HSYNetworkingToolsBaseUrl, NSString *> *)configs;

/**
 配置http请求的session的相关内容
 
 @param configs 配置项，@{XQCNetworkingToolsHttpRequestSerializerForKey : id, ...}
 */
- (void)hsy_httpSessionConfigs:(NSDictionary<HSYNetworkingToolsHttpSession, id> *)configs;

/**
 配置http下的file download或者file upload的相关内容
 
 @param configs 配置项，@{XQCNetworkingToolsUrlResponseSerializerForKey : id, ...}
 */
- (void)hsy_urlSessionConfigs:(NSDictionary<HSYNetworkingToolsUrlSession, id> *)configs;

#pragma mark - HTTP Methods

/**
 http-get请求

 @param path 请求的url
 @param paramter 请求参数
 @return RACSignal
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_requestByGet:(NSString *)path
                                      requestParamter:(HSYNetworkRequest *)paramter;

/**
 http-get请求
 
 @param path 请求的url
 @param paramter 请求参数
 @return RACSignal
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_requestByGet:(NSString *)path
                       paramter:(nullable NSDictionary *)paramter;

/**
 http-post请求
 
 @param path 请求的url
 @param paramter 请求参数
 @return RACSignal
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_requestByPost:(NSString *)path
                 requestParamter:(HSYNetworkRequest *)paramter;

/**
 http-post请求
 
 @param path 请求的url
 @param paramter 请求参数
 @return RACSignal
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_requestByPost:(NSString *)path
                                              paramter:(nullable NSDictionary *)paramter;

#pragma mark - File Methods

/**
 post请求格式的文件下载方法

 @param urlString 文件下载的完整url地址
 @param filePath 文件下载写入的本地沙盒地址
 @param taskProgressBlock 下载任务进度block
 @return RACSignal-下载结果
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_fileDownloadByPost:(NSString *)urlString
                                                forFilePath:(NSString *)filePath
                                      withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock;

/**
 get请求格式的文件下载方法

 @param urlString 文件下载的完整url地址
 @param filePath 文件下载写入的本地沙盒地址
 @param taskProgressBlock 下载任务进度block
 @return RACSignal-下载结果
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_fileDownloadByGet:(NSString *)urlString
                                               forFilePath:(NSString *)filePath
                                     withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock;

/**
 post请求格式的文件上传方法

 @param urlString 文件上传的完整url地址
 @param fileData 要上传的本地文件的二进制数据
 @param taskProgressBlock 上传任务的进度block
 @return RACSignal-上传结果
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_fileUploadByPost:(NSString *)urlString
                                              forFileData:(NSData *)fileData
                                    withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock;

/**
 get请求格式的文件上传方法
 
 @param urlString 文件上传的完整url地址
 @param fileData 要上传的本地文件的二进制数据
 @param taskProgressBlock 上传任务的进度block
 @return RACSignal-上传结果
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_fileUploadByGet:(NSString *)urlString
                                             forFileData:(NSData *)fileData
                                   withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock;
@end

NS_ASSUME_NONNULL_END
