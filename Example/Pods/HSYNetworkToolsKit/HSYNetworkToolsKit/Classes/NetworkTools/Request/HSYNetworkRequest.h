//
//  HSYNetworkRequest.h
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYNetworkRequest : NSObject

@property (nonatomic, strong) id paramter;                                                      //请求参数
@property (nonatomic, strong) NSArray<NSDictionary *> *requestHeaders;                          //本次请求的新增请求头信息
@property (nonatomic, assign) BOOL showErrorMessage;                                            //如果请求报错，是否显示错误信息
@property (nonatomic, assign) BOOL showResultMessage;                                           //如果请求成功，是否显示成功结果

/**
 快速创建

 @param paramter 本次请求的参数
 @param headers 本次请求的新增请求头参数
 @param showError HTTP请求错误时是否显示错误信息
 @param showResult 是否显示请求结果信息
 @return HSYNetworkRequest
 */
- (instancetype)initWithParamters:(id)paramter
                   requestHeaders:(NSArray<NSDictionary *> *)headers
                 showErrorMessage:(BOOL)showError
                showResultMessage:(BOOL)showResult;

/**
 快速创建，且如果HTTP错误时显示该HTTP错误，如果有请求结果提示，则显示该请求结果的提示
 
 @param paramter 本次请求的参数
 @param headers 本次请求的新增请求头参数
 @return HSYNetworkRequest
 */
- (instancetype)initWithParamters:(id)paramter
                   requestHeaders:(NSArray<NSDictionary *> *)headers;

/**
 快速创建，默认不设置新增的请求头信息，且如果HTTP错误时显示该HTTP错误，如果有请求结果提示，则显示该请求结果的提示

 @param paramter 本次请求的参数
 @return HSYNetworkRequest
 */
- (instancetype)initWithParamters:(id)paramter;

/**
 通过originalRequestHeaders和self.requestHeaders两个新旧请求头信息，重新整理出一份请求头

 @param originalRequestHeaders 上一次请求的请求头信息
 @return 返回本次请求的请求头信息
 */
- (NSArray<NSDictionary *> *)hsy_networkingRequestHeaders:(NSArray<NSDictionary *> *)originalRequestHeaders;

@end

NS_ASSUME_NONNULL_END
