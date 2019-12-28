//
//  HSYNetworkTools.m
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import "HSYNetworkTools.h"
#import "HSYToolsMacro.h"
#import "RACSignal+Convenients.h"

//请求域名的配置key
HSYNetworkingToolsBaseUrl const HSYNetworkingToolsBaseUrlStringForKey                          = @"baseUrlString";

//AFHTTPSessionManager的http管理者的配置key
HSYNetworkingToolsHttpSession const HSYNetworkingToolsHttpRequestSerializerForKey              = @"hsy_setRequestSerializer:";
HSYNetworkingToolsHttpSession const HSYNetworkingToolsHttpResponseSerializerForKey             = @"hsy_setResponseSerializer:";
HSYNetworkingToolsHttpSession const HSYNetworkingToolsHttpRequestCachePolicyForKey             = @"hsy_setCachePolicy:";
HSYNetworkingToolsHttpSession const HSYNetworkingToolsHttpRequestTimeoutForKey                 = @"hsy_setTimeoutInterval:";
HSYNetworkingToolsHttpSession const HSYNetworkingToolsHttpResponseContentTypesForKey           = @"hsy_setAcceptableContentTypes:";
HSYNetworkingToolsHttpSession const HSYNetworkingToolsHttpRequestHeadersForKey                 = @"hsy_setHeaders:";

//AFURLSessionManager的配置key
HSYNetworkingToolsUrlSession const HSYNetworkingToolsUrlResponseSerializerForKey               = @"hsy_setUrlResponseSerializer:";
HSYNetworkingToolsUrlSession const HSYNetworkingToolsUrlSecurityPolicyForKey                   = @"hsy_setUrlSecurityPolicy:";

static HSYNetworkTools *networkTools = nil;

//*****************************************************************************************************************************************

@interface AFURLSessionManager (Private)

- (void)hsy_setUrlResponseSerializer:(id<AFURLResponseSerialization>)responseSerializer;
- (void)hsy_setUrlSecurityPolicy:(AFSecurityPolicy *)securityPolicy;

@end

@implementation AFURLSessionManager (Private)

- (void)hsy_setUrlResponseSerializer:(id<AFURLResponseSerialization>)responseSerializer
{
    if (responseSerializer) {
        self.responseSerializer = responseSerializer;
    }
}

- (void)hsy_setUrlSecurityPolicy:(AFSecurityPolicy *)securityPolicy
{
    if (securityPolicy) {
        self.securityPolicy = securityPolicy;
    }
}

@end

//*****************************************************************************************************************************************

@interface AFHTTPSessionManager (Private)

- (void)hsy_setHeaders:(NSArray<NSDictionary *> *)headers;
- (void)hsy_setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer;
- (void)hsy_setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer;
- (void)hsy_setTimeoutInterval:(NSNumber *)interval;
- (void)hsy_setAcceptableContentTypes:(NSArray *)contentTypes;
- (void)hsy_setCachePolicy:(NSNumber *)cachePolicy;

@end

@implementation AFHTTPSessionManager (Private)

- (void)hsy_setHeaders:(NSArray<NSDictionary *> *)headers
{
    for (NSDictionary *header in headers) {
        [self.requestSerializer setValue:header.allValues.firstObject forHTTPHeaderField:header.allKeys.firstObject];
    }
}

- (void)hsy_setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer
{
    if (requestSerializer) {
        self.requestSerializer = requestSerializer;
    }
}

- (void)hsy_setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer
{
    if (responseSerializer) {
        self.responseSerializer = responseSerializer;
    }
}

- (void)hsy_setTimeoutInterval:(NSNumber *)interval
{
    if (interval) {
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = interval.doubleValue;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
}

- (void)hsy_setAcceptableContentTypes:(NSArray *)contentTypes
{
    if (!contentTypes.count) {
        NSSet *acceptableContentTypes = [NSSet setWithArray:contentTypes];
        self.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
}

- (void)hsy_setCachePolicy:(NSNumber *)cachePolicy
{
    if (cachePolicy) {
        self.requestSerializer.cachePolicy = (NSURLRequestCachePolicy)cachePolicy.integerValue;
    }
}

@end

//*****************************************************************************************************************************************

@interface HSYNetworkTools () {
    @private NSString *baseUrlString;
}

@property (nonatomic, strong) AFHTTPSessionManager *hsy_httpSessionManager;
@property (nonatomic, strong) AFURLSessionManager *hsy_urlSessionManager;

@end

@implementation HSYNetworkTools 

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkTools = [HSYNetworkTools new];
    });
    return networkTools;
}

#pragma mark - Getter

- (AFHTTPSessionManager *)hsy_httpSessionManager
{
    if (!_hsy_httpSessionManager) {
        _hsy_httpSessionManager = [AFHTTPSessionManager manager];
        NSSet *defaultSets = [NSSet setWithObjects:@"application/json",
                                                   @"text/json",
                                                   @"text/javascript",
                                                   @"text/html",
                                                   @"image/jpeg",
                                                   @"text/plain", nil];
        _hsy_httpSessionManager.responseSerializer.acceptableContentTypes = defaultSets;
    }
    return _hsy_httpSessionManager;
}

- (AFURLSessionManager *)hsy_urlSessionManager
{
    if (!_hsy_urlSessionManager) {
        NSURLSessionConfiguration *urlConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _hsy_urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:urlConfiguration];
    }
    return _hsy_urlSessionManager;
}

#pragma mark - Clear ---> Headers

- (void)hsy_clearAllHeaders
{
    [self.hsy_httpSessionManager.requestSerializer clearAuthorizationHeader];
}

- (NSArray<NSDictionary *> *)hsy_originalRequestHeaders
{
    NSDictionary *requestHeaders = self.hsy_httpSessionManager.requestSerializer.HTTPRequestHeaders;
    NSMutableArray<NSDictionary *> *realRequestHeaders = [NSMutableArray arrayWithCapacity:requestHeaders.allKeys.count];
    for (NSString *forKey in requestHeaders.allKeys) {
        [realRequestHeaders addObject:@{forKey : requestHeaders[forKey]}];
    }
    return realRequestHeaders.mutableCopy;
}

#pragma mark - Base Url

- (void)hsy_baseUrlStringConfigs:(NSDictionary<HSYNetworkingToolsBaseUrl, NSString *> *)configs
{
    NSLog(@"\n ========================================================================== ");
    baseUrlString = configs[HSYNetworkingToolsBaseUrlStringForKey];
    NSLog(@"\n alert --> baseUrlString = %@", baseUrlString);
    NSLog(@"\n ========================================================================== ");
    NSParameterAssert(baseUrlString);
    NSParameterAssert([baseUrlString hasPrefix:@"http"]);
}

- (NSString *)hsy_networkingToolUrlString:(NSString *)urlPath
{
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrlString, urlPath];
    return url;
}

#pragma mark - Configs

- (void)hsy_httpSessionConfigs:(NSDictionary<HSYNetworkingToolsHttpSession, id> *)configs
{
    //防止无序键值对的覆盖，因此requestSerializer和responseSerializer需要优先设置
    if ([configs.allKeys containsObject:HSYNetworkingToolsHttpRequestSerializerForKey]) {
        AFHTTPRequestSerializer<AFURLRequestSerialization> *requestSerializer = configs[HSYNetworkingToolsHttpRequestSerializerForKey];
        [self.hsy_httpSessionManager hsy_setRequestSerializer:requestSerializer];
    }
    if ([configs.allKeys containsObject:HSYNetworkingToolsHttpResponseSerializerForKey]) {
        AFHTTPResponseSerializer<AFURLResponseSerialization> *responseSerializer =  configs[HSYNetworkingToolsHttpResponseSerializerForKey];
        [self.hsy_httpSessionManager hsy_setResponseSerializer:responseSerializer];
    }
    //遍历配置项，所有非requestSerializer和responseSerializer的项根据SEL方法名称配置
    for (HSYNetworkingToolsHttpSession httpSessionForKey in configs.allKeys) {
        if ([httpSessionForKey isEqualToString:HSYNetworkingToolsHttpRequestSerializerForKey] || [httpSessionForKey isEqualToString:HSYNetworkingToolsHttpResponseSerializerForKey]) {
            continue;
        }
        HSYCOCOAKIT_IGNORED_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self.hsy_httpSessionManager performSelector:NSSelectorFromString(httpSessionForKey) withObject:configs[httpSessionForKey]]);
    }
}

- (void)hsy_urlSessionConfigs:(NSDictionary<HSYNetworkingToolsUrlSession, id> *)configs
{
    //防止无序键值对的覆盖，因此responseSerializer需要优先设置
    if ([configs.allKeys containsObject:HSYNetworkingToolsUrlResponseSerializerForKey]) {
        id<AFURLResponseSerialization>serialization = configs[HSYNetworkingToolsUrlResponseSerializerForKey];
        [self.hsy_urlSessionManager hsy_setUrlResponseSerializer:serialization];
    }
    //遍历配置项，所有非responseSerializer的项根据SEL方法名称配置
    for (HSYNetworkingToolsUrlSession urlSessionForKey in configs.allKeys) {
        if ([urlSessionForKey isEqualToString:HSYNetworkingToolsUrlResponseSerializerForKey]) {
            continue;
        }
        HSYCOCOAKIT_IGNORED_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self.hsy_urlSessionManager performSelector:NSSelectorFromString(urlSessionForKey) withObject:configs[urlSessionForKey]]);
    }
}

#pragma mark - HTTP Methods

- (void)hsy_resetRequestHeaders:(HSYNetworkRequest *)paramter
{
    if (paramter.requestHeaders.count) {
        /*
         1.先将上一次请求的请求头信息和本次请求新增的请求头信息合并整理出一份本次请求的请求头信息;
         2.然后再移除ANF中缓存的上一次请求头信息;
         3.最后重新将本次请求的请求头信息set进去;
         */
        NSArray<NSDictionary *> *originalRequestHeaders = self.hsy_originalRequestHeaders;
        NSArray<NSDictionary *> *requestHeaders = [paramter hsy_networkingRequestHeaders:originalRequestHeaders];
        [self hsy_clearAllHeaders];
        [self.hsy_httpSessionManager hsy_setHeaders:requestHeaders];
    }
}

- (RACSignal *)hsy_requestByGet:(NSString *)path requestParamter:(HSYNetworkRequest *)paramter
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self hsy_resetRequestHeaders:paramter];
        NSString *url = [self hsy_networkingToolUrlString:path];
        [[[self.hsy_httpSessionManager hsy_getRequest:url paramters:(paramter.paramter ? paramter.paramter : @{})] deliverOn:[RACScheduler currentScheduler]] subscribeNext:^(HSYNetworkResponse * _Nullable x) {
            [RACSignal hsy_performSendSignal:subscriber forObject:x];
        }];
    }];
}

- (RACSignal *)hsy_requestByGet:(NSString *)path paramter:(nullable NSDictionary *)paramter
{
    HSYNetworkRequest *requestObject = [[HSYNetworkRequest alloc] initWithParamters:paramter];
    return [self hsy_requestByGet:path requestParamter:requestObject];
}

- (RACSignal *)hsy_requestByPost:(NSString *)path requestParamter:(HSYNetworkRequest *)paramter
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [self hsy_resetRequestHeaders:paramter];
        NSString *url = [self hsy_networkingToolUrlString:path];
        [[[self.hsy_httpSessionManager hsy_postRequest:url paramters:(paramter.paramter ? paramter.paramter : @{})] deliverOn:[RACScheduler currentScheduler]] subscribeNext:^(HSYNetworkResponse * _Nullable x) {
            [RACSignal hsy_performSendSignal:subscriber forObject:x];
        }];
    }];
}

- (RACSignal *)hsy_requestByPost:(NSString *)path paramter:(nullable NSDictionary *)paramter
{
    HSYNetworkRequest *requestObject = [[HSYNetworkRequest alloc] initWithParamters:paramter];
    return [self hsy_requestByPost:path requestParamter:requestObject];
}

#pragma mark - File Methods

- (RACSignal *)hsy_fileDownloadByPost:(NSString *)urlString
                          forFilePath:(NSString *)filePath
                withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    return [self.hsy_urlSessionManager hsy_downloadFileRequestUrl:url
                                                      forFilePath:filePath
                                                    setHTTPMethod:kHSYNetworkingToolsHttpRequestMethodsPost
                                               completionProgress:taskProgressBlock];
}

- (RACSignal *)hsy_fileDownloadByGet:(NSString *)urlString
                         forFilePath:(NSString *)filePath
               withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    return [self.hsy_urlSessionManager hsy_downloadFileRequestUrl:url
                                                      forFilePath:filePath
                                                    setHTTPMethod:kHSYNetworkingToolsHttpRequestMethodsGet
                                               completionProgress:taskProgressBlock];
}

- (RACSignal *)hsy_fileUploadByPost:(NSString *)urlString
                        forFileData:(NSData *)fileData
              withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    return [self.hsy_urlSessionManager hsy_uploadFileRequestUrl:url
                                                    forFileData:fileData
                                                  setHTTPMethod:kHSYNetworkingToolsHttpRequestMethodsPost
                                             completionProgress:taskProgressBlock];
}

- (RACSignal *)hsy_fileUploadByGet:(NSString *)urlString
                       forFileData:(NSData *)fileData
             withFileDataTaskBlock:(AFURLSessionManagerFileDataTaskBlock)taskProgressBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    return [self.hsy_urlSessionManager hsy_uploadFileRequestUrl:url
                                                    forFileData:fileData
                                                  setHTTPMethod:kHSYNetworkingToolsHttpRequestMethodsGet
                                             completionProgress:taskProgressBlock];
}

@end
