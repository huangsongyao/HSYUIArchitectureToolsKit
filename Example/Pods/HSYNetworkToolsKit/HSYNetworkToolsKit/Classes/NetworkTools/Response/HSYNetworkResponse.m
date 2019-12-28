//
//  HSYNetworkResponse.m
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import "HSYNetworkResponse.h"

HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringDataTaskForKey       = @"urlSessionDataTask";
HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringErrorForKey          = @"error";
HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringResponseForKey       = @"response";
HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringUrlForKey            = @"requestUrlString";
HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringParamtersForKey      = @"requestParamters";
HSYNetworkResponseRequestDataString const _Nullable HSYNetworkResponseRequestDataStringHeadersForKey        = @"requestHeaders";

@implementation HSYNetworkResponse

- (instancetype)initWithTask:(nullable NSURLSessionTask *)sessionDataTask
                withResponse:(nullable id)response
                       error:(nullable NSError *)error
          httpRequestMethods:(kHSYNetworkingToolsHttpRequestMethods)requestMethods
{
    if (self = [super init]) {
        _urlSessionDataTask = sessionDataTask;
        _error = [HSYNetworkError hsy_error:error];
        _response = response;
        _httpStatusCode = self.hsy_urlRequestResponseStatusCode;
        _requestMethods = requestMethods;
    }
    return self;
}

- (instancetype)initWithMethods:(kHSYNetworkingToolsHttpRequestMethods)requestMethods
{
    return [self initWithTask:nil
                 withResponse:nil
                        error:nil
           httpRequestMethods:requestMethods];
} 

- (instancetype)initWithTask:(NSURLSessionTask *)sessionDataTask
                withResponse:(id)response
          httpRequestMethods:(kHSYNetworkingToolsHttpRequestMethods)requestMethods
{
    return [self initWithTask:sessionDataTask
                 withResponse:response
                        error:nil
           httpRequestMethods:requestMethods];
}

- (NSInteger)hsy_urlRequestResponseStatusCode
{
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)self.urlSessionDataTask.response;
    return urlResponse.statusCode;
}

- (void)hsy_downloadWithCancelDatas:(HSYNetworkResponseDownloadCancelDatasBlock)cancel
{
    NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)self.urlSessionDataTask;
    @weakify(self);
    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        @strongify(self);
        if (cancel) {
            cancel(self, resumeData);
        }
    }];
}

- (void)hsy_setRequestDatas:(NSDictionary<HSYNetworkResponseRequestDataString,id> *)forDictionary
{
    for (HSYNetworkResponseRequestDataString forKey in forDictionary.allKeys) {
        if ([self respondsToSelector:NSSelectorFromString(forKey)]) {
            [self setValue:forDictionary[forKey] forKey:forKey];
        }
    }
    _httpStatusCode = self.hsy_urlRequestResponseStatusCode;
}

@end
