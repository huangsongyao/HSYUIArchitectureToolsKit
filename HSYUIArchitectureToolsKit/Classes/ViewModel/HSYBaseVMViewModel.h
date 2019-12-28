//
//  HSYBaseVMViewModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/25.
//

#import "HSYBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

//网络请求的Signal函数
typedef RACSignal * _Nonnull (^HSYNetworkSignalBlock)(void);
//网络请求的Signal函数的返回结果的map映射函数
typedef id _Nonnull (^HSYNetworkMapBlock)(id result);
//网络请求的Signal函数的返回结果的map映射函数对应的model模型类名
typedef NSString * _Nonnull (^HSYNetworkMapClassBlock)(id result);

@interface HSYBaseVMViewModel : HSYBaseViewModel

@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong, readonly) RACSubject *combineSubject;

/**
 网络请求api，map函数的返回值是基由这个map函数在外部所映射的model对象
 
 @param network 请求的RACSignal
 @param map 请求结果映射函数
 @return RACSignal
 */
- (RACSignal *)hsy_requsetNetwork:(RACSignal *(^)(void))network toMap:(id(^)(id result))map;
+ (RACSignal *)hsy_requsetNetwork:(RACSignal *(^)(void))network toMap:(id(^)(id result))map;

/**
 网络请求api，map函数的返回值是这个函数回调的value所对应的模型的类名

 @param network 请求的RACSignal
 @param map 请求结果映射函数
 @return RACSignal
 */
+ (RACSignal *)hsy_requsetNetwork:(HSYNetworkSignalBlock)network toMapClass:(HSYNetworkMapClassBlock)map;
- (RACSignal *)hsy_requsetNetwork:(HSYNetworkSignalBlock)network toMapClass:(HSYNetworkMapClassBlock)map;

/**
 合并多个请求信号，如果signals的count为0，则直接返回一个nil的signal，否则返回由这个signals请求结果的映射model模型的Tuple元组

 @param signals 请求信号和每个请求信号对应的结果映射模型，格式为：@[@{RACSignal *networkSignalA : networkSignalA.result.map.model.class}, @{RACSignal *networkSignalB : networkSignalB.result.map.model.class}, ... ]
 @return RACSignal<RACTuple *> *
 */
- (RACSignal<RACTuple *> *)hsy_zipSignals:(NSArray<NSDictionary<RACSignal *, NSString *> *> *)signals;

/**
 添加一个RAC计时器，本计时器会再主线程发起回调
 
 @param interval 间隔触发时间
 @param block 回调事件，返回一个BOOL值，YES表示关闭计时器，NO表示不关闭计时器
 */
- (void)hsy_intervalTimer:(NSTimeInterval)interval intervalBlock:(BOOL(^)(NSDate *date, NSTimeInterval currenctCount))block;


@end

NS_ASSUME_NONNULL_END
