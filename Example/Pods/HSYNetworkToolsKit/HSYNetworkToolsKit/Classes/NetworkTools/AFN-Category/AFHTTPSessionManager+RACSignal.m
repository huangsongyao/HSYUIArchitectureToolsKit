//
//  AFHTTPSessionManager+RACSignal.m
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/10/6.
//

#import "AFHTTPSessionManager+RACSignal.h"
#import "RACSignal+Convenients.h"
#import "HSYNetworkRequest.h"
#import "HSYNetworkResponse.h"

//请求方法的类型
static NSString *const kHSYURLSessionGetStringForValue         = @"GET";
static NSString *const kHSYURLSessionPostStringForValue        = @"POST";
static NSString *const kHSYURLSessionDeleteStringForValue      = @"DELETE";
static NSString *const kHSYURLSessionPutStringForValue         = @"PUT";

@implementation AFHTTPSessionManager (RACSignal)

#pragma mark - Methods

- (RACSignal<HSYNetworkResponse *> *)hsy_request:(kHSYNetworkingToolsHttpRequestMethods)methods
                                             url:(NSString *)url
                                       paramters:(id)paramters
{
    return @{@(kHSYNetworkingToolsHttpRequestMethodsGet) : [self hsy_getRequest:url paramters:paramters],
             @(kHSYNetworkingToolsHttpRequestMethodsPost) : [self hsy_postRequest:url paramters:paramters],
             @(kHSYNetworkingToolsHttpRequestMethodsDelete) : [self hsy_deleteRequest:url paramters:paramters],
             @(kHSYNetworkingToolsHttpRequestMethodsPut) : [self hsy_putRequest:url paramters:paramters], }[@(methods)];
}

- (HSYNetworkResponse *)hsy_requestResponse:(id)response
                           requestUrlString:(NSString *)url
                                  paramters:(id)paramters
                            sessionDataTask:(NSURLSessionDataTask *)task
                             requestMethods:(kHSYNetworkingToolsHttpRequestMethods)methods
{
    HSYNetworkResponse *networkResponse = [[HSYNetworkResponse alloc] initWithMethods:methods];
    NSMutableDictionary *requestDictionary = [@{HSYNetworkResponseRequestDataStringUrlForKey : url,
                                                HSYNetworkResponseRequestDataStringParamtersForKey : paramters,
                                                HSYNetworkResponseRequestDataStringDataTaskForKey : task,
                                                HSYNetworkResponseRequestDataStringResponseForKey : (response ? response : [NSNull null]),
                                                HSYNetworkResponseRequestDataStringHeadersForKey : (self.requestSerializer.HTTPRequestHeaders ? self.requestSerializer.HTTPRequestHeaders : [NSNull null])} mutableCopy];
    [networkResponse hsy_setRequestDatas:requestDictionary];
    return networkResponse;
}

- (HSYNetworkResponse *)hsy_requestError:(NSError *)error
                        requestUrlString:(NSString *)url
                               paramters:(id)paramters
                         sessionDataTask:(NSURLSessionDataTask *)task
                          requestMethods:(kHSYNetworkingToolsHttpRequestMethods)methods
{
    HSYNetworkResponse *networkResponse = [[HSYNetworkResponse alloc] initWithMethods:methods];
    NSMutableDictionary *requestDictionary = [@{HSYNetworkResponseRequestDataStringUrlForKey : url,
                                                HSYNetworkResponseRequestDataStringParamtersForKey : paramters,
                                                HSYNetworkResponseRequestDataStringDataTaskForKey : (task ? task : [NSNull null]),
                                                HSYNetworkResponseRequestDataStringErrorForKey : [HSYNetworkError hsy_error:error],
                                                HSYNetworkResponseRequestDataStringHeadersForKey : (self.requestSerializer.HTTPRequestHeaders ? self.requestSerializer.HTTPRequestHeaders : [NSNull null])} mutableCopy];
    NSLog(@"request failure, error : %@, url = %@", requestDictionary[HSYNetworkResponseRequestDataStringErrorForKey], url);
    [networkResponse hsy_setRequestDatas:requestDictionary];
    return networkResponse;
}

- (RACSignal<HSYNetworkResponse *> *)hsy_getRequest:(NSString *)url
                                          paramters:(id)paramters
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self GET:url parameters:paramters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestResponse:responseObject
                                                      requestUrlString:url
                                                             paramters:paramters
                                                       sessionDataTask:task
                                                        requestMethods:kHSYNetworkingToolsHttpRequestMethodsGet]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestError:error
                                                   requestUrlString:url
                                                          paramters:paramters
                                                    sessionDataTask:task
                                                     requestMethods:kHSYNetworkingToolsHttpRequestMethodsGet]];
        }];
    }];
}

- (RACSignal<HSYNetworkResponse *> *)hsy_postRequest:(NSString *)url
                                           paramters:(id)paramters
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self POST:url parameters:paramters progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestResponse:responseObject
                                                      requestUrlString:url
                                                             paramters:paramters
                                                       sessionDataTask:task
                                                        requestMethods:kHSYNetworkingToolsHttpRequestMethodsPost]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestError:error
                                                   requestUrlString:url
                                                          paramters:paramters
                                                    sessionDataTask:task
                                                     requestMethods:kHSYNetworkingToolsHttpRequestMethodsPost]];
        }];
    }];
}

- (RACSignal<HSYNetworkResponse *> *)hsy_deleteRequest:(NSString *)url
                                             paramters:(id)paramters
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self DELETE:url parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestResponse:responseObject
                                                      requestUrlString:url
                                                             paramters:paramters
                                                       sessionDataTask:task
                                                        requestMethods:kHSYNetworkingToolsHttpRequestMethodsDelete]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestError:error
                                                   requestUrlString:url
                                                          paramters:paramters
                                                    sessionDataTask:task
                                                     requestMethods:kHSYNetworkingToolsHttpRequestMethodsDelete]];
        }];
    }];
}

- (RACSignal<HSYNetworkResponse *> *)hsy_putRequest:(NSString *)url
                                          paramters:(id)paramters
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self PUT:url parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestResponse:responseObject
                                                      requestUrlString:url
                                                             paramters:paramters
                                                       sessionDataTask:task
                                                        requestMethods:kHSYNetworkingToolsHttpRequestMethodsPut]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[self hsy_requestError:error
                                                   requestUrlString:url
                                                          paramters:paramters
                                                    sessionDataTask:task
                                                     requestMethods:kHSYNetworkingToolsHttpRequestMethodsPut]];
        }];
    }];
}

#pragma mark - Static

+ (NSString *)hsy_toRequestMethodString:(kHSYNetworkingToolsHttpRequestMethods)methods
{
    return @{@(kHSYNetworkingToolsHttpRequestMethodsGet) : kHSYURLSessionGetStringForValue,
             @(kHSYNetworkingToolsHttpRequestMethodsPost) : kHSYURLSessionPostStringForValue,
             @(kHSYNetworkingToolsHttpRequestMethodsDelete) : kHSYURLSessionDeleteStringForValue,
             @(kHSYNetworkingToolsHttpRequestMethodsPut) : kHSYURLSessionPutStringForValue, }[@(methods)];
}

@end
