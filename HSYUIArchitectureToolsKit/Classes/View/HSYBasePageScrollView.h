//
//  HSYBasePageScrollView.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//********************************************************************************************************************************************************************************************************************************************************

@protocol HSYBasePageTableDelegate <NSObject>

@required

/**
 由外部的分页子控制器返回它所持有的UIScrollview类族对象[UITableView、UICollectionView]
 
 @return UIScrollView
 */
- (UIScrollView *)hsy_listScrollView;

@end

//********************************************************************************************************************************************************************************************************************************************************

@class HSYBasePageScrollView;
@protocol HSYBasePageScrollDelegate <NSObject>

@required

/**
 通过委托，由外部返回一个作为mainScrollView的headerView的视图
 
 @param scrollView self
 @return mainScrollView的headerView的视图
 */
- (UIView *)hsy_tableHeaderViewInPageScrollView:(HSYBasePageScrollView *)scrollView;

/**
 通过委托，由外部返回一个作为mainScrollView的body的视图，这个视图主要是作为segmentPageController分页控制器的容器视图
 
 @param scrollView self
 @return mainScrollView的body的视图
 */
- (UIView *)hsy_pageViewInPageScrollView:(HSYBasePageScrollView *)scrollView;

/**
 通过委托，由外部返回一个作为mainScrollView的body的视图的高度
 
 @param scrollView self
 @return mainScrollView的body的视图的高度
 */
- (CGFloat)hsy_listViewHeightInPageScrollView:(HSYBasePageScrollView *)scrollView;

/**
 通过委托，由外部将签订了<HSYBasePageTableDelegate>委托的UIViewController控制器对象的集合返回过来

 @param scrollView HSYBasePageScrollView对象
 @return NSArray<UIViewController<HSYBasePageTableDelegate> *> *
 */
- (NSArray<UIViewController<HSYBasePageTableDelegate> *> *)hsy_listViewsInPageScrollView:(HSYBasePageScrollView *)scrollView;

@optional

/**
 用于额外做动态头部变化的委托回调
 
 @param scrollView scrollView
 */
- (void)hsy_mainTableViewDidScroll:(UIScrollView *)scrollView;

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBasePageTableView : UITableView <UIGestureRecognizerDelegate>

/**
 初始化一个主界面UITableView

 @param tableHeaderView UITableView的tableHeaderView头部
 @return HSYBasePageTableView
 */
- (instancetype)initWithTableHeaderView:(UIView *)tableHeaderView;

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBasePageScrollView : UIView

//委托
@property (nonatomic, weak) id<HSYBasePageScrollDelegate>delegate;
//主界面底部的tableView
@property (nonatomic, strong, readonly) HSYBasePageTableView *mainTableView;
//临界值的偏移量，默认为0.0f，此时临界值为self.mainTableView.tableHeaderView.height，当这个属性有值时，此时偏移量为(self.mainTableView.tableHeaderView.height + self.criticalScrollValue)
@property (nonatomic, assign) CGFloat criticalScrollValue;
//设置左右滑动及上下滑动冲突时的禁止横向滚动的行为
@property (nonatomic, assign, setter=hsy_startHorizonScroll:) BOOL userHorizonScroll;
//当前选中的页面
@property (nonatomic, assign) NSInteger selectedPage;

/**
 初始化方法

 @param delegate <HSYBasePageScrollDelegate>委托
 @return HSYBasePageScrollView
 */
- (instancetype)initWithDelegate:(id<HSYBasePageScrollDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
