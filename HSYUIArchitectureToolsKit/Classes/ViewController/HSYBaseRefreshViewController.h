//
//  HSYBaseRefreshViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/25.
//

#import "HSYBaseViewController.h"
#import "HSYBaseRefreshViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseRefreshViewController : HSYBaseViewController 

@property (nonatomic, assign, setter=addAllRefreshOperation:) BOOL addAllRefresh;       //是否添加上拉+下拉
@property (nonatomic, assign, setter=addDownRefreshOperation:) BOOL addRefreshForDown;  //是否添加下拉，每次下拉时，会根据addRefreshForUp的状态来决定是否执行resetNoMoreData方法
@property (nonatomic, assign, setter=addUpRefreshOperation:) BOOL addRefreshForUp;      //是否添加上拉，当设置为NO时，会执行endRefreshingWithNoMoreData来隐藏上拉
@property (nonatomic, copy) NSString *refreshNormalHeaderClass;                                     //默认为MJRefreshNormalHeader，如果需要定制，则子类重写这个方法，并返回定制的类名
@property (nonatomic, copy) NSString *refreshNormalFooterClass;                                     //默认为MJRefreshNormalFooter，如果需要定制，则子类重写这个方法，并返回定制的类名

/**
 自动执行下拉刷新过度动画及下拉操作
 */
- (void)hsy_performFirstRequest;

/**
 下拉刷新结果回调，子类重写这个方法，可以获取到对应状态

 @param viewModel 返回VM
 @param result 本次的请求结果
 */
- (void)hsy_callBackDownRefresh:(HSYBaseRefreshViewModel *)viewModel requestResult:(id)result;

/**
 上拉加载更多结果回调，子类重写这个方法，可以获取到对应状态
 
 @param viewModel 返回VM
 @param result 本次的请求结果
 */
- (void)hsy_callBackUpRefresh:(HSYBaseRefreshViewModel *)viewModel requestResult:(id)result;


@end

NS_ASSUME_NONNULL_END
