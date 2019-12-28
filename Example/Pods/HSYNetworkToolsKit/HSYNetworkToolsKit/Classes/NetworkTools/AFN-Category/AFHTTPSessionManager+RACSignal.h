//
//  AFHTTPSessionManager+RACSignal.h
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/10/6.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kHSYNetworkingToolsHttpRequestMethods) {
    
    kHSYNetworkingToolsHttpRequestMethodsGet        = 2018,
    kHSYNetworkingToolsHttpRequestMethodsPost,
    kHSYNetworkingToolsHttpRequestMethodsDelete,
    kHSYNetworkingToolsHttpRequestMethodsPut,
};

@class HSYNetworkResponse;
@interface AFHTTPSessionManager (RACSignal)

/**
 get请求
 
 @param url 完整的url请求地址
 @param paramters 参数
 @return RACSignal<XQCNetworkingReponseObject *> *
 */ 
- (RACSignal<HSYNetworkResponse *> *)hsy_getRequest:(NSString *)url
                                          paramters:(id)paramters;

/**
 post请求
 
 @param url 完整的url请求地址
 @param paramters 参数
 @return RACSignal<XQCNetworkingReponseObject *> *
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_postRequest:(NSString *)url
                                           paramters:(id)paramters;

/**
 http请求，根据枚举变动请求格式
 
 @param methods kXQCNetworkingToolsHttpRequestMethods枚举，请求格式
 @param url 完整的url请求地址
 @param paramters 参数
 @return RACSignal<XQCNetworkingReponseObject *> *
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_request:(kHSYNetworkingToolsHttpRequestMethods)methods
                                             url:(NSString *)url
                                       paramters:(id)paramters;

/**
 静态方法，通过kHSYNetworkingToolsHttpRequestMethods返回对应请求方法类型的string

 @param methods kHSYNetworkingToolsHttpRequestMethods枚举
 @return 对应请求方法类型的string
 */
+ (NSString *)hsy_toRequestMethodString:(kHSYNetworkingToolsHttpRequestMethods)methods;

@end

NS_ASSUME_NONNULL_END
