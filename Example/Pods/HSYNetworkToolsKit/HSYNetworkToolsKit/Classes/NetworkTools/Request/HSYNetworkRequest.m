//
//  HSYNetworkRequest.m
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import "HSYNetworkRequest.h"

#pragma mark - Private Category

@interface NSArray (Keys)

//整理出旧的请求头信息所包含的所有key
- (NSArray<NSString *> *)originalRequestHeaderKeys;

@end

@implementation NSArray (Keys)

- (NSArray<NSString *> *)originalRequestHeaderKeys
{
    NSMutableArray<NSString *> *originalRequestHeaderKeys = [NSMutableArray arrayWithCapacity:self.count];
    for (NSDictionary *originalHeader in self) {
        [originalRequestHeaderKeys addObject:originalHeader.allKeys.firstObject];
    }
    return originalRequestHeaderKeys.mutableCopy;
}

@end

@implementation HSYNetworkRequest

- (instancetype)initWithParamters:(id)paramter
{
    return [self initWithParamters:paramter requestHeaders:@[]];
}

- (instancetype)initWithParamters:(id)paramter
                   requestHeaders:(NSArray<NSDictionary *> *)headers
{
    return [self initWithParamters:paramter
                    requestHeaders:headers
                  showErrorMessage:YES
                 showResultMessage:YES];
}

- (instancetype)initWithParamters:(id)paramter
                   requestHeaders:(NSArray<NSDictionary *> *)headers
                 showErrorMessage:(BOOL)showError
                showResultMessage:(BOOL)showResult
{
    if (self = [super init]) {
        _paramter = paramter;
        _requestHeaders = headers;
        _showErrorMessage = showError;
        _showResultMessage = showResult;
    }
    return self;
}

- (NSArray<NSDictionary *> *)hsy_networkingRequestHeaders:(NSArray<NSDictionary *> *)originalRequestHeaders
{
    /*
     规则:1.如果本次请求没有新增请求头信息，则直接返回上一次请求的旧的请求头信息; 2.如果本次请求新增了请求头信息，则将上一次请求头的信息复制一份作为本次请求头信息的旧数据备用，然后对本次请求新增的请求头信息和上一次请求的旧的请求头信息进行二重遍历，当新增请求头信息的key不包含在旧请求头信息中，则直接添加，否则替换旧请求头信息中的旧数据;
     */
    if (!self.requestHeaders.count) {
        return originalRequestHeaders;
    }
    NSMutableArray<NSDictionary *> *requestHeaders = originalRequestHeaders.mutableCopy;
    NSArray<NSString *> *originalRequestHeaderKeys = originalRequestHeaders.originalRequestHeaderKeys;
    for (NSDictionary *requestHeader in self.requestHeaders) {
        NSDictionary *thisHeader = requestHeader;
        if ([originalRequestHeaderKeys containsObject:requestHeader.allKeys.firstObject]) {
            for (NSDictionary *originalHeader in originalRequestHeaders) {
                if ([originalHeader.allKeys.firstObject isEqualToString:requestHeader.allKeys.firstObject]) {
                    [requestHeaders removeObject:originalHeader];
                    break;
                }
            }
        }
        [requestHeaders addObject:thisHeader];
    }
    return requestHeaders.mutableCopy;
}

@end
