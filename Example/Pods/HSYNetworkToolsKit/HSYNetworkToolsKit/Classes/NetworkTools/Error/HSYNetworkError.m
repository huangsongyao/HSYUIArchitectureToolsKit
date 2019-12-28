//
//  HSYNetworkError.m
//  HSYNetworkToolsKit
//
//  Created by anmin on 2019/9/30.
//

#import "HSYNetworkError.h"

NSErrorDomain const kHSYNetworkErrorDomain = @"HSYNetworkErrorDomain";
NSErrorUserInfoKey const kHSYNetworkErrorDomainKey = @"HSYNetworkErrorDomainKey";
NSInteger const kHSYNetworkErrorDomainCode = -1212;

@implementation HSYNetworkError

+ (HSYNetworkError *)hsy_error:(NSError *)error
{
    if (error) {
        return [HSYNetworkError errorWithDomain:error.domain
                                           code:error.code
                                       userInfo:error.userInfo];
    }
    return [HSYNetworkError errorWithDomain:kHSYNetworkErrorDomain
                                       code:kHSYNetworkErrorDomainCode
                                   userInfo:@{kHSYNetworkErrorDomainKey : @"Default Error!"}];
}

@end
