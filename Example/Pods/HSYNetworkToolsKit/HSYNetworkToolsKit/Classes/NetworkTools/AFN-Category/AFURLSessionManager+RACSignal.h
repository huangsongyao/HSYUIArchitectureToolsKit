//
//  AFURLSessionManager+RACSignal.h
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/10/6.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager+RACSignal.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AFURLSessionManagerFileDataTaskBlock)(NSProgress *progress, CGFloat downloadProgress);

@class HSYNetworkResponse;
@interface AFURLSessionManager (RACSignal)

#pragma mark - Download File

/**
 文件下载
 
 @param url 下载的远端地址
 @param filePath 存入本地的一个绝对路径
 @param type method的类型，get或者post
 @param progress 下载进度的回调
 @return RACSignal文件下载结果信号
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_downloadFileRequestUrl:(NSURL *)url
                                                    forFilePath:(NSString *)filePath
                                                  setHTTPMethod:(kHSYNetworkingToolsHttpRequestMethods)type
                                             completionProgress:(AFURLSessionManagerFileDataTaskBlock)progress NS_AVAILABLE_IOS(8_0);

#pragma mark - Upload File

/**
 文件上传，默认不设置method
 
 @param url 上传的远端地址
 @param fileData 要上传的本地文件的二进制数据
 @param type method的类型，get或者post
 @param progress 文件上传的进度回调
 @return RACSignal文件上传结果信号
 */
- (RACSignal<HSYNetworkResponse *> *)hsy_uploadFileRequestUrl:(NSURL *)url
                                                  forFileData:(NSData *)fileData
                                                setHTTPMethod:(kHSYNetworkingToolsHttpRequestMethods)type
                                           completionProgress:(AFURLSessionManagerFileDataTaskBlock)progress NS_AVAILABLE_IOS(8_0);

@end

NS_ASSUME_NONNULL_END
