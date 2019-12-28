//
//  HSYBaseRefreshViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/25.
//

#import "HSYBaseRefreshViewController.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <MJRefresh/MJRefresh.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HSYBaseRefreshViewController+Operation.h"

@interface HSYBaseRefreshViewController ()

@end

@implementation HSYBaseRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Methods

- (void)closedPullUpRefresh
{
    if (self.addRefreshForUp) {
        [self endRefreshingNoMoreDatas];
    }
}

- (void)endRefreshingNoMoreDatas
{
    UIScrollView *scrollView = self.refreshScrollView;
    NSParameterAssert(scrollView);
    if (scrollView.mj_footer) { 
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)resetRefreshingNoMoreDatas
{
    UIScrollView *scrollView = self.refreshScrollView;
    NSParameterAssert(scrollView);
    if (scrollView.mj_footer) {
        [scrollView.mj_footer resetNoMoreData];
    }
}

- (UIScrollView *)refreshScrollView
{
    UIScrollView *scrollView = nil;
    NSString *tableViewName = @"tableView";
    NSString *collectionViewName = @"collectionView";
    scrollView = ([self respondsToSelector:NSSelectorFromString(tableViewName)] ? [self valueForKey:tableViewName] : ([self respondsToSelector:NSSelectorFromString(collectionViewName)] ? [self valueForKey:collectionViewName] : nil));
    return scrollView;
}

#pragma mark - First Request

- (void)hsy_performFirstRequest
{
    UIScrollView *scrollView = self.refreshScrollView;
    NSParameterAssert(scrollView);
    NSParameterAssert(scrollView.mj_header);
    [scrollView.mj_header beginRefreshing];
}

#pragma mark - Setter

- (void)addAllRefreshOperation:(BOOL)addAllRefresh
{
    _addAllRefresh = addAllRefresh;
    self.addRefreshForUp = addAllRefresh;
    self.addRefreshForDown = addAllRefresh;
}

- (void)addDownRefreshOperation:(BOOL)addRefreshForDown
{
    _addRefreshForDown = addRefreshForDown;
    if (addRefreshForDown) {
        @weakify(self);
        [self hsy_addRefreshHeader:^(HSYBaseRefreshViewModel *viewModel, id x) {
            @strongify(self);
            [self hsy_callBackDownRefresh:viewModel requestResult:x];
        }];
    }
}

- (void)addUpRefreshOperation:(BOOL)addRefreshForUp
{
    _addRefreshForUp = addRefreshForUp;
    @weakify(self);
    [self hsy_addRefreshFooter:^(HSYBaseRefreshViewModel *viewModel, id x) {
        @strongify(self);
        [self hsy_callBackUpRefresh:viewModel requestResult:x];
    }];
}

#pragma mark - MJRefresh

- (void)hsy_addRefreshHeader:(void(^)(HSYBaseRefreshViewModel *viewModel, id x))refresh
{
    UIScrollView *scrollView = self.refreshScrollView;
    NSParameterAssert(scrollView);
    @weakify(self);
    scrollView.mj_header = [NSClassFromString(self.hsy_refreshNormalHeaderClassName) headerWithRefreshingBlock:^{
        @strongify(self);
        [[[self.viewModel hsy_refreshForDown] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple *tuple) {
            [scrollView.mj_header endRefreshingWithCompletionBlock:^{
                @strongify(self);
                if (refresh) {
                    //如果添加了上拉，并且下拉刷新的数据源的值为0，则代表没有下一页数据，不需要继续保留翻页的上拉加载功能
                    if (![tuple.first count]) {
                        [self closedPullUpRefresh];
                    } else {
                        //如果添加了上拉，并且下拉刷新的数据源的值大于0，则重置上拉加载功能
                        if (self.addRefreshForUp) {
                            [self resetRefreshingNoMoreDatas];
                        }
                    }
                    refresh(self.viewModel, tuple.first);
                }
            }];
        }];
    }];
}

- (void)hsy_addRefreshFooter:(void(^)(HSYBaseRefreshViewModel *viewModel, id x))refresh
{
    UIScrollView *scrollView = self.refreshScrollView;
    NSParameterAssert(scrollView);
    if (!self.addRefreshForUp) {
        [self endRefreshingNoMoreDatas];
        return;
    }
    @weakify(self);
    scrollView.mj_footer = [NSClassFromString(self.hsy_refreshNormalFooterClassName) footerWithRefreshingBlock:^{
        @strongify(self);
        [[[self.viewModel hsy_refreshForUp] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple *tuple) {
            [scrollView.mj_footer endRefreshingWithCompletionBlock:^{
                @strongify(self);
                if (refresh) {
                    NSArray *listResult = tuple.second;
                    //如果上拉加载到的数据源的值为0，则代表没有下一页数据，此时关闭上拉加载更多的功能
                    if (!listResult.count) {
                        [self endRefreshingNoMoreDatas];
                    }
                    refresh(self.viewModel, tuple.first);
                }
            }];
        }];
    }];
    scrollView.mj_footer.ignoredScrollViewContentInsetBottom = (HSY_IS_iPhoneX ? 34.0f : 0.0f);
}

#pragma mark - Load

- (void)hsy_callBackDownRefresh:(HSYBaseRefreshViewModel *)viewModel requestResult:(id)result
{
    NSLog(@"viewModel = %@, refresh down result = %@", viewModel, result);
}

- (void)hsy_callBackUpRefresh:(HSYBaseRefreshViewModel *)viewModel requestResult:(id)result
{
    NSLog(@"viewModel = %@, refresh up result = %@", viewModel, result);
}

- (NSString *)hsy_refreshNormalHeaderClassName
{
    if (self.refreshNormalHeaderClass.length) {
        return self.refreshNormalHeaderClass;
    }
    return NSStringFromClass([MJRefreshNormalHeader class]);
}

- (NSString *)hsy_refreshNormalFooterClassName
{
    if (self.refreshNormalFooterClass.length) {
        return self.refreshNormalFooterClass;
    }
    return NSStringFromClass([MJRefreshBackNormalFooter class]);
}

@end
