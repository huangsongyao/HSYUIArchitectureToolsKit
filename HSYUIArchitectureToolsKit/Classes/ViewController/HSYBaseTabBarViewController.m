//
//  HSYBaseTabBarViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/23.
//

#import "HSYBaseTabBarViewController.h"
#import <Masonry/Masonry.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMethodsToolsKit/UIImage+Canvas.h>
#import <HSYMethodsToolsKit/UIScrollView+Pages.h>
#import "HSYBaseTabBarItemCell.h"

static NSString *const kHSYBaseTabBarItemIdentifierForKey = @"HSYBaseTabBarItemIdentifierForKey";

@interface HSYBaseTabBarViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *tabBarBackgroundImageView;
@property (nonatomic, strong) UIScrollView *mainPageView;

@end

@implementation HSYBaseTabBarViewController

- (instancetype)initWithConfigs:(NSArray<HSYBaseTabBarItemConfig *> *)configs;
{
    if (self = [super init]) {
        self.viewModel = [[HSYBaseTabBarViewModel alloc] initWithConfigs:configs];
        self.collectionDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = [(HSYBaseTabBarViewModel *)self.viewModel itemSize];
    }
    return self;
}

- (void)viewDidLoad {
    self.registerClasses = @[@{kHSYBaseTabBarItemIdentifierForKey : @"HSYBaseTabBarItemCell"}];
    [super viewDidLoad];
    //移除默认的loading
    self.loading = NO;
    //隐藏默认的定制导航栏
    self.customNavigationContentViewBar.hidden = YES;
    //重置伪tabBar的位置和大小
    self.collectionView.height = self.itemSize.height; 
    self.collectionView.y = IPHONE_HEIGHT - self.collectionView.height;
    //给伪tabBar添加默认的背景图
    self.tabBarBackgroundImage = [UIImage hsy_imageWithFillColor:UIColor.whiteColor];
    //设置tabBarController默认的index位置
    self.selectedIndex = [(HSYBaseTabBarViewModel *)self.viewModel hsy_currentSelectedIndex];
    //添加tabBarController的item标签点击监听
    @weakify(self);
    self.hsy_deselectRowBlock = ^(NSIndexPath * _Nonnull indexPath, UIScrollView * _Nonnull scrollView, UIView * _Nonnull cell) {
        @strongify(self);
        self.selectedIndex = indexPath.row;
    };
    // Do any additional setup after loading the view.
}

#pragma mark - Static Methods

+ (NSArray<NSString *> *)hsy_listOfSubviews
{
    NSArray *subviews = @[@"tableView", @"collectionView", @"webView"];
    return subviews;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([(HSYBaseTabBarViewModel *)self.viewModel tabBarConfigs].count) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [(HSYBaseTabBarViewModel *)self.viewModel tabBarConfigs].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSYBaseTabBarItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHSYBaseTabBarItemIdentifierForKey forIndexPath:indexPath];
    cell.tabBarItemConfig = [(HSYBaseTabBarViewModel *)self.viewModel tabBarConfigs][indexPath.row];
    return cell;
}

#pragma mark - Lazy

- (UIImageView *)tabBarBackgroundImageView
{
    if (!_tabBarBackgroundImageView) {
        _tabBarBackgroundImageView = [[UIImageView alloc] init];
        _tabBarBackgroundImageView.frame = self.collectionView.frame;
        [self.hsy_view insertSubview:_tabBarBackgroundImageView aboveSubview:self.collectionView];
    }
    return _tabBarBackgroundImageView;
}

- (UIScrollView *)mainPageView
{
    if (!_mainPageView) {
        _mainPageView = [[UIScrollView alloc] initWithSize:CGSizeMake(self.view.width, self.collectionView.y)];
        _mainPageView.bounces = NO;
        _mainPageView.pagingEnabled = YES;
        _mainPageView.scrollEnabled = self.mainScrollEnabled;
        _mainPageView.showsHorizontalScrollIndicator = NO;
        _mainPageView.showsVerticalScrollIndicator = NO;
        _mainPageView.delegate = self;
        [self.hsy_view addSubview:_mainPageView];
        NSArray *subviews = self.class.hsy_listOfSubviews;
        CGFloat x = 0.0f;
        for (UIViewController *viewController in [(HSYBaseTabBarViewModel *)self.viewModel viewControllers]) {
            viewController.hsy_runtimeDelegate = self;
            viewController.view.height = self.collectionView.y;
            viewController.view.x = x;
            for (NSString *propertyName in subviews) {
                if ([viewController respondsToSelector:NSSelectorFromString(propertyName)]) {
                    UIView *subview = [viewController valueForKey:propertyName];
                    subview.height = viewController.view.height;
                }
            }
            [_mainPageView addSubview:viewController.view];
            x = viewController.view.right;
        }
        _mainPageView.contentSize = CGSizeMake(x, 0.0f);
    }
    return _mainPageView;
}

#pragma mark - Setter

- (void)hsy_setTabbarBackgroundImage:(UIImage *)tabBarBackgroundImage
{
    _tabBarBackgroundImage = tabBarBackgroundImage;
    self.tabBarBackgroundImageView.image = tabBarBackgroundImage;
    self.tabBarBackgroundImageView.highlightedImage = tabBarBackgroundImage;
}

- (void)hsy_setTabbarSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [(HSYBaseTabBarViewModel *)self.viewModel hsy_setSelectedItemStatus:selectedIndex];
    [self.mainPageView hsy_setXPage:selectedIndex];
    [self.collectionView reloadData];
}

- (void)hsy_setMainScrollEnabledStatus:(BOOL)mainScrollEnabled
{
    _mainScrollEnabled = mainScrollEnabled;
    self.mainPageView.scrollEnabled = mainScrollEnabled;
}

#pragma mark - UIViewControllerRuntimeDelegate

- (void)hsy_runtimeDelegate:(UIViewControllerRuntimeObject *)object
{
    if (self.runtimeDelegateBlock) {
        HSYBaseTabBarViewModel *viewModel = (HSYBaseTabBarViewModel *)self.viewModel;
        self.runtimeDelegateBlock(object, [viewModel hsy_getTabBarItemConfig:@(self.selectedIndex)], viewModel, @(self.selectedIndex), [viewModel hsy_getTabBarSubViewController:@(self.selectedIndex)]);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.hsy_currentPage;
}

@end
