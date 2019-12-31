//
//  HSYBaseCustomSegmentedPageViewController.h
//  HSYUIArchitectureToolsKit
//
//  Created by anmin on 2019/12/28.
//

#import "HSYBaseViewController.h"
#import "HSYBaseCustomSegmentedPageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kHSYBaseCustomSegmentedPageDidScrollEndedType) {
    
    kHSYBaseCustomSegmentedPageDidScrollEndedTypeTouchControlItem = 1232, //control按钮翻页类型
    kHSYBaseCustomSegmentedPageDidScrollEndedTypeScrollPaging = 4312, //滚动手势翻页类型
    
};

@interface UIViewController (LayoutReset)

/**
 返回一个RACTuple元组的RACSignal冷信号，元组中包裹了两个数据，1、first => 当前子控制器的self.view.frame，类型为NSValue；2、second => 当前子控制器的self.view.superview.frame，类型为NSValue
 
 @return 返回一个RACTuple元组的RACSignal冷信号
 */
- (RACSignal<RACTuple *> *)hsy_layoutReset;

@end

//********************************************************************************************************************************************************************************************************************************************************

@class HSYBaseCustomSegmentedPageViewController;
@protocol HSYBaseCustomSegmentedPageScrollDelegate <NSObject>

@optional

/**
 监听即将开始拖拽滚动

 @param scrollView 分页的scrollView
 @param index 当前的分页页码位置
 */
- (void)hsy_segmentedPageWillBeginDragging:(UIScrollView *)scrollView withCurrentIndex:(NSInteger)index;

/**
 监听拖拽滚动结束[会监听"- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView"和"- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView"]

 @param scrollView 分页的scrollView
 @param index 当前的分页页码位置
 */
- (void)hsy_segmentedPageDidEndDecelerating:(UIScrollView *)scrollView withCurrentIndex:(NSInteger)index;

/**
 监听拖拽滚动开始减速

 @param scrollView 分页的scrollView
 @param index 当前的分页页码位置
 */
- (void)hsy_segmentedPageDidEndDragging:(UIScrollView *)scrollView withCurrentIndex:(NSInteger)index;

@end

typedef void(^HSYBaseCustomSegmentedPageDidScrollEndedBlock)(NSInteger selectedIndex, kHSYBaseCustomSegmentedPageDidScrollEndedType scrollType, HSYBaseCustomSegmentedPageControllerModel *segmentedPageControllerModel);
typedef void(^HSYBaseCustomSegmentedPageRuntimeDelegateBlock)(HSYBaseCustomSegmentedPageViewController *segmentedPageViewController, NSInteger selectedIndex, UIViewControllerRuntimeObject *object);
@interface HSYBaseCustomSegmentedPageViewController : HSYBaseViewController <UIScrollViewDelegate>

//titleView的分页control
@property (nonatomic, strong, readonly) HSYBaseCustomSegmentedPageControl *segmentedPageControl;
//外部设置分页控制器是否支持手指左右滚动，默认为支持[YES]
@property (nonatomic, assign, setter=hsy_setSegmentedPaging:) BOOL segmentedPaging;
//外部设置分页控制器当前选中的位置，默认选中0
@property (nonatomic, assign, setter=hsy_setSegmentedPagingIndex:) NSInteger selectedIndex;
//UIScrollView滚动结束后的状态监听，"- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView"和"- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView"两个委托触发时，这个block均会回调外部
@property (nonatomic, copy) HSYBaseCustomSegmentedPageDidScrollEndedBlock scrollEndedBlock;
//监听子控制器的全局委托协议的回调事件，这个block会把回调信号事件返回到外部的子类中
@property (nonatomic, copy) HSYBaseCustomSegmentedPageRuntimeDelegateBlock runtimeDelegateBlock;
//监听几个UIScrollViewDelegate的委托
@property (nonatomic, weak) id<HSYBaseCustomSegmentedPageScrollDelegate>delegate;

/**
 初始化方法
 
 @param segmentedPageModel HSYBaseCustomSegmentedPageControllerModel参数模型
 @return HSYBaseCustomSegmentedPageViewController
 */
- (instancetype)initWithSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel;

@end

NS_ASSUME_NONNULL_END
