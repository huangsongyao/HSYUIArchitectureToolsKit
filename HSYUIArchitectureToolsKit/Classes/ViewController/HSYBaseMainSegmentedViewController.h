//
//  HSYBaseMainSegmentedViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseViewController.h"
#import "HSYBasePageScrollView.h"
#import "HSYBaseMainSegmentedViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HSYBaseMainSegmentedViewController;
typedef void(^HSYBaseMainSegmentedPageMainTableHeaderDidScrollBlock)(UIScrollView *scrollView, HSYBaseMainSegmentedViewController *mainSegmentedViewController);
typedef UIView *_Nonnull(^HSYBaseMainSegmentedPageMainTableHeaderViewBlock)(HSYBasePageScrollView *pageScrollView, HSYBaseMainSegmentedViewController *mainSegmentedViewController);
typedef CGFloat(^HSYBaseMainSegmentedPageMainTableBodyHeightsBlock)(HSYBasePageScrollView *pageScrollView, HSYBaseMainSegmentedViewController *mainSegmentedViewController);
@interface HSYBaseMainSegmentedViewController : HSYBaseViewController 

//主界面的ScorllView
@property (nonatomic, strong, readonly) HSYBasePageScrollView *pageScrollView;
//返回mainTableView的tableHeaderView的滚动状态监听
@property (nonatomic, copy) HSYBaseMainSegmentedPageMainTableHeaderDidScrollBlock returnMainTableHeaderDidScrollBlock;
//外部返回mainTableView的tableHeaderView作为HSYBaseMainSegmentedViewController的header头
@property (nonatomic, copy) HSYBaseMainSegmentedPageMainTableHeaderViewBlock returnMainTableHeaderBlock;
//外部返回一个CGFloat作为mainTableView的HSYBaseCustomSegmentedPageViewController=>body的高度
@property (nonatomic, copy) HSYBaseMainSegmentedPageMainTableBodyHeightsBlock returnMainTableBodyHeightsBlock;
//设置当前的子分页控制器所翻页的页码
@property (nonatomic, assign, setter=hsy_setMainSegmentedPageIndex:) NSInteger mainBodySelectedIndex;

/**
 初始化方法
 
 @param segmentedPageModel HSYBaseCustomSegmentedPageControllerModel参数模型
 @return HSYBaseCustomSegmentedPageViewController
 */
- (instancetype)initWithMainSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel;


@end

NS_ASSUME_NONNULL_END
