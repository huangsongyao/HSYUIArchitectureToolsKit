//
//  HSYBaseCustomSegmentedPageViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseCustomSegmentedPageViewController.h"
#import "HSYBaseTabBarViewController.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIScrollView+Pages.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>

//********************************************************************************************************************************************************************************************************************************************************

@interface UIScrollView (PrivatedScales)

/**
 通过HSYBaseCustomSegmentedPageViewController分页的页码数，计算出滚动HSYBaseCustomSegmentedPageViewController的UIScrollView的滚动距离的百分比

 @param controlCounts HSYBaseCustomSegmentedPageViewController分页的页码数
 @return 滚动HSYBaseCustomSegmentedPageViewController的UIScrollView的滚动距离的百分比
 */
- (CGFloat)hsy_toScrollScales:(NSInteger)controlCounts;

@end

@implementation UIScrollView (PrivatedScales)

- (CGFloat)hsy_toScrollScales:(NSInteger)controlCounts
{
    CGFloat scale = self.contentOffset.x / (self.width * (MAX(controlCounts, 1) - 1));
    return scale;
}

@end

//********************************************************************************************************************************************************************************************************************************************************

@implementation UIViewController (LayoutReset)

- (RACSignal *)hsy_layoutReset
{
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        NSValue *superviewGCRect = [NSValue valueWithCGRect:self.view.superview.frame];
        NSValue *viewCGRect = [NSValue valueWithCGRect:self.view.frame];
        [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack(viewCGRect, superviewGCRect)];
    }];
}

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBaseCustomSegmentedPageViewController () <UIViewControllerRuntimeDelegate, UIScrollViewDelegate, HSYBaseCustomSegmentedPageControlDelegate> {
    @private HSYBaseCustomSegmentedPageControl *_segmentedPageControl;
}

//滚动条
@property (nonatomic, strong) UIScrollView *scrollView;
//滚动状态标志位，用于区分HSYBaseCustomSegmentedPageControl的item触发滚动后于self.scrollView触发滚动后的冲突情况
@property (nonatomic, assign) BOOL scrollFinished;

@end

@implementation HSYBaseCustomSegmentedPageViewController

- (instancetype)initWithSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel
{
    if (self = [super init]) {
        self.viewModel = [[HSYBaseCustomSegmentedPageViewModel alloc] initWithSegmentedPageModel:segmentedPageModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始状态配置
    self.scrollFinished = YES;
    self.loading = NO;
    self.selectedIndex = 0;
    //通过一个全局的Category，当分页控制器的UI绘制完毕后，在viewDidLoad方法结尾返回每个子控制器的通知
    NSArray<UIViewController *> *viewControllers = [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel viewControllers:self];
    for (UIViewController *viewController in viewControllers) {
        [[[viewController hsy_layoutReset] rac_willDeallocSignal] hsy_performCompletedSignal];
    }
    // Do any additional setup after loading the view.
}

#pragma mark - Setter

- (void)hsy_setSegmentedPaging:(BOOL)segmentedPaging
{
    _segmentedPaging = segmentedPaging;
    self.scrollView.scrollEnabled = segmentedPaging;
}

- (void)hsy_setSegmentedPagingIndex:(NSInteger)selectedIndex
{
    [self hsy_setPages:selectedIndex];
    self.segmentedPageControl.selectedIndex = selectedIndex;
}

#pragma mark - Methods

- (void)hsy_setPages:(NSInteger)pages
{
    _selectedIndex = pages;
    [self.scrollView hsy_setXPage:pages animated:self.segmentedPaging];
}

#pragma mark - Lazy

- (HSYBaseCustomSegmentedPageControl *)segmentedPageControl
{
    if (!_segmentedPageControl) {
        _segmentedPageControl = [[HSYBaseCustomSegmentedPageControl alloc] initWithSegmentedPageModel:[(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_toSegmentedPageControlModel]];
        _segmentedPageControl.delegate = self;
        self.hsy_realNavigationBarItem.titleView = _segmentedPageControl;
    }
    return _segmentedPageControl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        CGFloat y = self.customNavigationContentViewBar.bottom;
        _scrollView = [[UIScrollView alloc] initWithSize:CGSizeMake(self.view.width, (self.view.height - y))];
        _scrollView.y = y;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        NSArray<UIViewController *> *viewControllers = [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel viewControllers:self];
        CGFloat x = 0.0f;
        NSArray<NSString *> *subviews = [HSYBaseTabBarViewController hsy_listOfSubviews];
        for (UIViewController *viewController in viewControllers) {
            viewController.view.size = _scrollView.size;
            viewController.view.x = x;
            [_scrollView hsy_addSubview:viewController.view];
            for (NSString *subview in subviews) {
                if ([viewController respondsToSelector:NSSelectorFromString(subview)]) {
                    UIView *realSubview = [viewController valueForKey:subview];
                    realSubview.size = viewController.view.size;
                }
            }
            x = viewController.view.right;
        }
        _scrollView.contentSize = CGSizeMake(x, 0.0f);
        self.segmentedPaging = YES;
    }
    return _scrollView;
}

#pragma mark - UIViewControllerRuntimeDelegate

- (void)hsy_runtimeDelegate:(UIViewControllerRuntimeObject *)object
{
    if (self.runtimeDelegateBlock) {
        self.runtimeDelegateBlock(self, self.selectedIndex, object);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollFinished) {
        CGFloat scale = [self.scrollView hsy_toScrollScales:[(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_toSegmentedPageControlModel].controlModels.count];
        [self.segmentedPageControl hsy_setContentOffsets:scale];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrollFinished = YES;
    self.selectedIndex = scrollView.hsy_currentPage;
    if (self.scrollEndedBlock) {
        self.scrollEndedBlock(self.selectedIndex, kHSYBaseCustomSegmentedPageDidScrollEndedTypeTouchControlItem, [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel segmentedPageControllerModel]);
    }
    NSLog(@"- scrollViewDidEndScrollingAnimation: 按钮翻页结束, 当前页面位置:%@", @(self.selectedIndex));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.hsy_currentPage;
    if (self.scrollEndedBlock) {
        self.scrollEndedBlock(self.selectedIndex, kHSYBaseCustomSegmentedPageDidScrollEndedTypeScrollPaging, [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel segmentedPageControllerModel]);
    }
    NSLog(@"- scrollViewDidEndDecelerating: 滚动手势结束, 当前页面位置:%@", @(self.selectedIndex));
}

#pragma mark - HSYBaseCustomSegmentedPageControlDelegate

- (void)hsy_clickedSelectedIndex:(NSInteger)index withSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel bySegmentedPageControl:(HSYBaseCustomSegmentedPageControl *)segmentedPageControl
{
    self.scrollFinished = NO;
    [self hsy_setPages:index];
}

@end
