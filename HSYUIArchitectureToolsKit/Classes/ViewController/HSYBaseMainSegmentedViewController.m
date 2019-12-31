//
//  HSYBaseMainSegmentedViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseMainSegmentedViewController.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import "HSYBaseCustomSegmentedPageViewModel.h"

@interface HSYBaseMainSegmentedViewController () <HSYBaseCustomSegmentedPageScrollDelegate, UIViewControllerRuntimeDelegate, HSYBasePageScrollDelegate> {
    @private HSYBasePageScrollView *_pageScrollView;
}

@property (nonatomic, strong, readonly) UIView *mainTableHeaderView;

@end

@implementation HSYBaseMainSegmentedViewController

- (instancetype)initWithMainSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel
{
    if (self = [super init]) {
        self.viewModel = [[HSYBaseMainSegmentedViewModel alloc] initWithMainSegmentedPageModel:segmentedPageModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loading = NO;
    self.customNavigationContentViewBar.hidden = YES;
    [(HSYBaseMainSegmentedViewModel *)self.viewModel hsy_mainSegmentedPageViewController].delegate = self;
    self.mainBodySelectedIndex = [(HSYBaseMainSegmentedViewModel *)self.viewModel mainSegmentedPageControllerModel].segmentedPageControlModel.hsy_itemSelectedIndex;
    self.pageScrollView.userHorizonScroll = YES;
    // Do any additional setup after loading the view.
}

#pragma mark - Setter

- (void)hsy_setMainSegmentedPageIndex:(NSInteger)mainBodySelectedIndex
{
    _mainBodySelectedIndex = mainBodySelectedIndex;
    [(HSYBaseMainSegmentedViewModel *)self.viewModel hsy_mainSegmentedPageViewController].selectedIndex = mainBodySelectedIndex;
    self.pageScrollView.selectedPage = mainBodySelectedIndex;
}

#pragma mark - Lazy

- (HSYBasePageScrollView *)pageScrollView
{
    if (!_pageScrollView) {
        _pageScrollView = [[HSYBasePageScrollView alloc] initWithDelegate:self];
        [self.view addSubview:self.pageScrollView];
    }
    return _pageScrollView;
}

#pragma mark - HSYBasePageScrollDelegate

- (void)hsy_mainTableViewDidScroll:(UIScrollView *)scrollView
{
    //返回mainTableView的tableHeaderView的滚动状态
    if (self.returnMainTableHeaderDidScrollBlock) {
        self.returnMainTableHeaderDidScrollBlock(scrollView, self);
    }
}

- (UIView *)hsy_tableHeaderViewInPageScrollView:(HSYBasePageScrollView *)scrollView
{
    //子类重载这个委托，返回一个UIView视图，作为mainTableView的tableHeaderView
    if (self.returnMainTableHeaderBlock) {
        self->_mainTableHeaderView = self.returnMainTableHeaderBlock(scrollView, self);
        return self.mainTableHeaderView;
    }
    return nil;
}

- (CGFloat)hsy_listViewHeightInPageScrollView:(HSYBasePageScrollView *)scrollView
{
    //子类重载这个委托，返回一个CGFloat高度，作为mainTableView的HSYBaseCustomSegmentedPageViewController=>body区域的高度，默认返回全屏下mainTableView的偏移量和设备最大显示宽度之间的差值
    if (self.returnMainTableBodyHeightsBlock) {
        return self.returnMainTableBodyHeightsBlock(scrollView, self);
    }
    return (IPHONE_HEIGHT - scrollView.mainTableView.contentOffset.y);
}

- (UIView *)hsy_pageViewInPageScrollView:(HSYBasePageScrollView *)scrollView
{
    //返回HSYBaseCustomSegmentedPageViewController分页控制器的view视图作为mainTableView的body
    return [(HSYBaseMainSegmentedViewModel *)self.viewModel hsy_mainSegmentedPageViewController].view;
}

- (NSArray<UIViewController<HSYBasePageTableDelegate> *> *)hsy_listViewsInPageScrollView:(HSYBasePageScrollView *)scrollView
{
    //HSYBaseCustomSegmentedPageViewController分页控制器的子控制器必须添加id<HSYBasePageTableDelegate>协议
    return [(HSYBaseCustomSegmentedPageViewModel *)[(HSYBaseMainSegmentedViewModel *)self.viewModel hsy_mainSegmentedPageViewController].viewModel hsy_viewControllers:self].mutableCopy;
}

#pragma mark - HSYBaseCustomSegmentedPageScrollDelegate

- (void)hsy_segmentedPageWillBeginDragging:(UIScrollView *)scrollView withCurrentIndex:(NSInteger)index
{
    self.pageScrollView.selectedPage = index;
    self.pageScrollView.userHorizonScroll = NO;
}

- (void)hsy_segmentedPageDidEndDecelerating:(UIScrollView *)scrollView withCurrentIndex:(NSInteger)index
{
    self.pageScrollView.selectedPage = index;
    self.pageScrollView.userHorizonScroll = YES;
}

- (void)hsy_segmentedPageDidEndDragging:(UIScrollView *)scrollView withCurrentIndex:(NSInteger)index
{
    self.pageScrollView.userHorizonScroll = YES;
}

#pragma mark - UIViewControllerRuntimeDelegate

- (void)hsy_runtimeDelegate:(UIViewControllerRuntimeObject *)object
{
    
}

@end
