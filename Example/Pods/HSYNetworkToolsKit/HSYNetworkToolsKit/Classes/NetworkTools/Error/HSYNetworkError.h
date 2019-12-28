//
//  HSYNetworkError.h
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const kHSYNetworkErrorDomain;
FOUNDATION_EXPORT NSErrorUserInfoKey const kHSYNetworkErrorDomainKey;
FOUNDATION_EXPORT NSInteger const kHSYNetworkErrorDomainCode;

@interface HSYNetworkError : NSError

/**
 返回一个错误信息对象，如果error为nil，则返回默认的信息

 @param error error错误信息
 @return HSYNetworkError
 */
+ (HSYNetworkError *)hsy_error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
