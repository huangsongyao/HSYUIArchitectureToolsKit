//
//  HSYBaseRefreshViewModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/25.
//

#import "HSYBaseVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSArray *_Nonnull(^HSYNetworkRefreshMapBlock)(id result);

typedef NS_ENUM(NSUInteger, kHSYNetworkRefreshState) {
    
    kHSYNetworkRefreshStateDown         = 1991,
    kHSYNetworkRefreshStateUp           = 2018,
    
};

@interface HSYBaseRefreshViewModel : HSYBaseVMViewModel

@property (nonatomic, strong) NSNumber *paging;                 //翻页当前的页码，默认为0
@property (nonatomic, strong, readonly) NSNumber *firstPage;    //第一页，默认为1
@property (nonatomic, strong) NSNumber *branches;               //每页的总条数，默认为100

/**
 下拉刷新方法
 
 @param network 网络请求的signal
 @param map 映射结果
 @return RACSignal
 */
- (RACSignal *)hsy_refreshForDown:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map;

/**
 子类如果添加了下拉头部，请在vm中重写本方法，并实现”- (RACSignal *)hsy_refreshForDown:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map“函数
 example:
 - (RACSignal *)hsy_refreshForDown
 {
 return [self hsy_refreshForDown:^RACSignal * _Nonnull{
 return [RACSignal empty];
 } toMap:^NSArray * _Nonnull(id _Nonnull result) {
 NSArray *list = ....【请解析result成list后返回】
 return list;
 }];
 }
 
 @return RACSignal
 */
- (RACSignal *)hsy_refreshForDown;

/**
 上拉加载更多的方法
 
 @param network 网络请求的signal
 @param map 映射结果
 @return RACSignal
 */
- (RACSignal *)hsy_refreshForUp:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map;

/**
 子类如果添加了上拉头部，请在vm中重写本方法，并实现”- (RACSignal *)hsy_refreshForUp:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map“函数
 example:
 - (RACSignal *)hsy_refreshForUp
 {
 return [self hsy_refreshForDown:^RACSignal * _Nonnull{
 return [RACSignal empty];
 } toMap:^NSArray * _Nonnull(id _Nonnull result) {
 NSArray *list = ....【请解析result成list后返回】
 return list;
 }];
 }
 
 @return RACSignal
 */
- (RACSignal *)hsy_refreshForUp;


@end

NS_ASSUME_NONNULL_END
