//
//  HSYBaseCustomSegmentedPageViewController.m
//  HSYUIArchitectureToolsKit
//
//  Created by anmin on 2019/12/28.
//

#import "HSYBaseCustomSegmentedPageViewController.h"
#import "HSYBaseTabBarViewController.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIScrollView+Pages.h>
#import <HSYMethodsToolsKit/UIImage+Canvas.h>
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

@interface HSYBaseCustomSegmentedPageViewController () <UIViewControllerRuntimeDelegate, HSYBaseCustomSegmentedPageControlDelegate> {
    @private HSYBaseCustomSegmentedPageControl *_segmentedPageControl;
    @private UIImageView *_segmentedPageControlBackgroundView;
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
    NSArray<UIViewController *> *viewControllers = [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_viewControllers:self];
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

- (void)hsy_resetSegmentedPageControlHeights:(CGFloat)heights
{
    self.segmentedPageControl.height = heights;
    self.scrollView.y = self.segmentedPageControl.bottom;
    self.scrollView.height = self.view.height - self.scrollView.y;
    NSArray<NSString *> *subviews = [HSYBaseTabBarViewController hsy_listOfSubviews];
    NSArray<UIViewController *> *viewControllers = [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_viewControllers:self];
    for (UIViewController *viewController in viewControllers) {
        viewController.view.size = self.scrollView.size;
        for (NSString *subview in subviews) {
            if ([viewController respondsToSelector:NSSelectorFromString(subview)]) {
                UIView *realSubview = [viewController valueForKey:subview];
                realSubview.size = viewController.view.size;
            }
        }
    }
}

#pragma mark - Lazy

- (UIImageView *)segmentedPageControlBackgroundView
{
    if (!_segmentedPageControlBackgroundView) {
        UIImage *image = [UIImage hsy_imageWithFillColor:UIColor.clearColor];
        _segmentedPageControlBackgroundView = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        _segmentedPageControlBackgroundView.userInteractionEnabled = YES;
        [self.view addSubview:_segmentedPageControlBackgroundView];
    }
    return _segmentedPageControlBackgroundView;
}

- (HSYBaseCustomSegmentedPageControl *)segmentedPageControl
{
    if (!_segmentedPageControl) {
        _segmentedPageControl = [[HSYBaseCustomSegmentedPageControl alloc] initWithSegmentedPageModel:[(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_toSegmentedPageControlModel]];
        _segmentedPageControl.delegate = self;
        if ([(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_toSegmentedPageControlModel].hsy_segmentedPageControlTitleViewFormat) {
            self.hsy_realNavigationBarItem.titleView = _segmentedPageControl;
        } else {
            self.customNavigationContentViewBar.hidden = YES;
            self.segmentedPageControlBackgroundView.size = CGSizeMake(self.view.width, _segmentedPageControl.height);
            [self.view addSubview:_segmentedPageControl];
        }
    }
    return _segmentedPageControl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        CGFloat y = ([(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_toSegmentedPageControlModel].hsy_segmentedPageControlTitleViewFormat ? self.customNavigationContentViewBar.bottom : self.segmentedPageControl.bottom);
        _scrollView = [[UIScrollView alloc] initWithSize:CGSizeMake(self.view.width, (self.view.height - y))];
        _scrollView.y = y;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        NSArray<UIViewController *> *viewControllers = [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel hsy_viewControllers:self];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_segmentedPageDidEndDecelerating:withCurrentIndex:)]) {
        [self.delegate hsy_segmentedPageDidEndDecelerating:scrollView withCurrentIndex:self.selectedIndex];
    }
    NSLog(@"- scrollViewDidEndScrollingAnimation: 按钮翻页结束, 当前页面位置:%@", @(self.selectedIndex));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.hsy_currentPage;
    if (self.scrollEndedBlock) {
        self.scrollEndedBlock(self.selectedIndex, kHSYBaseCustomSegmentedPageDidScrollEndedTypeScrollPaging, [(HSYBaseCustomSegmentedPageViewModel *)self.viewModel segmentedPageControllerModel]);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_segmentedPageDidEndDecelerating:withCurrentIndex:)]) {
        [self.delegate hsy_segmentedPageDidEndDecelerating:scrollView withCurrentIndex:self.selectedIndex];
    }
    NSLog(@"- scrollViewDidEndDecelerating: 拖拽滚动手势结束, 当前页面位置:%@", @(self.selectedIndex));
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_segmentedPageWillBeginDragging:withCurrentIndex:)]) {
        [self.delegate hsy_segmentedPageWillBeginDragging:scrollView withCurrentIndex:self.selectedIndex];
    }
    NSLog(@"- scrollViewWillBeginDragging: 即将开始拖拽滚动手势, 当前页面位置:%@", @(self.selectedIndex));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_segmentedPageDidEndDragging:withCurrentIndex:)]) {
            [self.delegate hsy_segmentedPageDidEndDragging:scrollView withCurrentIndex:self.selectedIndex];
        }
    }
    NSLog(@"- scrollViewDidEndDragging:willDecelerate: 拖拽滚动手势开始减速, 当前页面位置:%@", @(self.selectedIndex));
}

#pragma mark - HSYBaseCustomSegmentedPageControlDelegate

- (void)hsy_clickedSelectedIndex:(NSInteger)index withSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel bySegmentedPageControl:(HSYBaseCustomSegmentedPageControl *)segmentedPageControl
{
    self.scrollFinished = NO;
    [self hsy_setPages:index];
}

@end
