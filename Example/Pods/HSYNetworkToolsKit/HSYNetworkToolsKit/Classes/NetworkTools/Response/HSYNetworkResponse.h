//
//  HSYNetworkResponse.h
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+RACSignal.h"
#import "HSYNetworkError.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *HSYNetworkResponseRequestDataString;
FOUNDATION_EXPORT HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringDataTaskForKey;
FOUNDATION_EXPORT HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringErrorForKey;
FOUNDATION_EXPORT HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringResponseForKey;
FOUNDATION_EXPORT HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringUrlForKey;
FOUNDATION_EXPORT HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringParamtersForKey;
FOUNDATION_EXPORT HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringHeadersForKey;

@class HSYNetworkResponse;
typedef void(^HSYNetworkResponseDownloadCancelDatasBlock)(HSYNetworkResponse *networkResponse, NSData *data);

@interface HSYNetworkResponse : NSObject

@property (nonatomic, assign, readonly) kHSYNetworkingToolsHttpRequestMethods requestMethods;   //请求方法类型
@property (nonatomic, assign, readonly) NSInteger httpStatusCode;                               //HTTP超文本传输协议的结果
//允许使用HSYNetworkResponseRequestDataString配置
@property (nonatomic, strong) NSURLSessionTask *urlSessionDataTask;                             //session请求任务
@property (nonatomic, strong, nullable) HSYNetworkError *error;                                 //错误信息
@property (nonatomic, strong, nullable) id response;                                            //response的JSON结果
@property (nonatomic, copy) NSString *requestUrlString;                                         //本次请求的完整url
@property (nonatomic, strong, nullable) id requestParamters;                                    //本次请求的入参
@property (nonatomic, strong, nullable) NSDictionary *requestHeaders;                           //本次请求的请求头信息


/**
 快速创建

 @param sessionDataTask 短连接、下载任务、上传任务的session
 @param response session任务结果
 @param error session任务失败信息
 @param requestMethods session任务的类型枚举
 @return HSYNetworkResponse
 */
- (instancetype)initWithTask:(nullable NSURLSessionTask *)sessionDataTask
                withResponse:(nullable id)response
                       error:(nullable NSError *)error
          httpRequestMethods:(kHSYNetworkingToolsHttpRequestMethods)requestMethods;

/**
 快速创建，除了self.requestMethods以外都是nil

 @param requestMethods kHSYNetworkingToolsHttpRequestMethods枚举类型
 @return HSYNetworkResponse
 */
- (instancetype)initWithMethods:(kHSYNetworkingToolsHttpRequestMethods)requestMethods;

/**
 下载任务失败后返回已经下载好的数据

 @param cancel HSYNetworkResponseDownloadCancelDatasBlock block
 */
- (void)hsy_downloadWithCancelDatas:(HSYNetworkResponseDownloadCancelDatasBlock)cancel;

/**
 配置若干个属性值

 @param forDictionary @{HSYNetworkResponseRequestDataString : id}
 */
- (void)hsy_setRequestDatas:(NSDictionary<HSYNetworkResponseRequestDataString, id> *)forDictionary;

@end

NS_ASSUME_NONNULL_END
