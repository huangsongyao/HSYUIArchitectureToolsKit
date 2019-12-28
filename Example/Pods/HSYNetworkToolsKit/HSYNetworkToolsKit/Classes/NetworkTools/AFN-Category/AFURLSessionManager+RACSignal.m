//
//  AFURLSessionManager+RACSignal.m
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/10/6.
//

#import "AFURLSessionManager+RACSignal.h" 
#import "HSYNetworkTools.h"
#import "RACSignal+Convenients.h"
#import "HSYNetworkResponse.h"

@implementation AFURLSessionManager (RACSignal)

#pragma mark - Download

- (RACSignal<HSYNetworkResponse *> *)hsy_downloadFileRequestUrl:(NSURL *)url
                                                    forFilePath:(NSString *)filePath
                                                  setHTTPMethod:(kHSYNetworkingToolsHttpRequestMethods)type
                                             completionProgress:(AFURLSessionManagerFileDataTaskBlock)progress
{
    NSParameterAssert(url);
    NSParameterAssert(filePath);
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:[AFHTTPSessionManager hsy_toRequestMethodString:type]];
        __block NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                CGFloat fractionCompleted = MIN((downloadProgress.fractionCompleted * 100), 1.0f);
                progress(downloadProgress, fractionCompleted);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            return fileURL;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                NSLog(@"request failure, error : %@, url = %@", error, url);
            }
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[[HSYNetworkResponse alloc] initWithTask:downloadTask
                                                                         withResponse:filePath
                                                                                error:error
                                                                   httpRequestMethods:type]];
        }];
        [downloadTask resume];
    }];
}

#pragma mark - Upload

- (RACSignal<HSYNetworkResponse *> *)hsy_uploadFileRequestUrl:(NSURL *)url
                                                  forFileData:(NSData *)fileData
                                                setHTTPMethod:(kHSYNetworkingToolsHttpRequestMethods)type
                                           completionProgress:(AFURLSessionManagerFileDataTaskBlock)progress
{
    NSParameterAssert(url);
    NSParameterAssert(fileData);
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:[AFHTTPSessionManager hsy_toRequestMethodString:type]];
        __block NSURLSessionUploadTask *uploadTask = [self uploadTaskWithRequest:request fromData:fileData progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                CGFloat fractionCompleted = MIN((uploadProgress.fractionCompleted * 100.0f), 1.0f);
                progress(uploadProgress, fractionCompleted);
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"request failure, error : %@, url = %@", error, url);
            }
            [RACSignal hsy_performSendSignal:subscriber
                                   forObject:[[HSYNetworkResponse alloc] initWithTask:uploadTask 
                                                                         withResponse:responseObject
                                                                                error:error
                                                                   httpRequestMethods:type]];

        }];
        [uploadTask resume];
    }];
}


@end
