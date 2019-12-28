//
//  HSYBasePageScrollView.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBasePageScrollView.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>

//********************************************************************************************************************************************************************************************************************************************************

@implementation HSYBasePageTableView

- (instancetype)initWithTableHeaderView:(UIView *)tableHeaderView
{
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.tableHeaderView = tableHeaderView;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBasePageScrollView () <UITableViewDelegate, UITableViewDataSource> {
    @private HSYBasePageTableView *_mainTableView;
}

@property (nonatomic, assign) BOOL scrollDidCriticalValue;
@property (nonatomic, assign) BOOL mainViewScrollState;
@property (nonatomic, assign) BOOL listViewScrollState;
@property (nonatomic, strong) NSArray<UIViewController<HSYBasePageTableDelegate> *> *listViewPages;

@end

@implementation HSYBasePageScrollView

- (instancetype)initWithDelegate:(id<HSYBasePageScrollDelegate>)delegate
{
    if (self = [super initWithSize:CGSizeMake(IPHONE_WIDTH, IPHONE_HEIGHT)]) {
        //默认的变量标记状态
        [self hsy_defaultTabStatus];
        //设置委托
        self.delegate = delegate;
        //由委托获取外部返回的添加过HSYBasePageTableDelegate协议的UIViewController控制器集合
        self.listViewPages = [self.delegate hsy_listViewsInPageScrollView:self];
        @weakify(self);
        [self.listViewPages enumerateObjectsUsingBlock:^(UIViewController<HSYBasePageTableDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj hsy_listScrollViewDidScroll:^(UIScrollView * _Nonnull scrollView) {
                @strongify(self);
                [self hsy_listScrollViewDidScroll:scrollView]; 
            }];
        }];
    }
    return self;
}

- (void)hsy_defaultTabStatus
{
    self.scrollDidCriticalValue = NO;
    self.mainViewScrollState = YES;
    self.listViewScrollState = NO;
}

#pragma mark - Lazy

- (HSYBasePageTableView *)mainTableView
{
    if (!_mainTableView) {
        UIView *tableHeaderView = [self.delegate hsy_tableHeaderViewInPageScrollView:self];
        _mainTableView = [[HSYBasePageTableView alloc] initWithTableHeaderView:tableHeaderView];
        _mainTableView.frame = self.bounds;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [self addSubview:_mainTableView];
    }
    return _mainTableView;
}

#pragma mark - Setter

- (void)hsy_startHorizonScroll:(BOOL)userHorizonScroll
{
    _userHorizonScroll = userHorizonScroll;
    self.mainTableView.scrollEnabled = userHorizonScroll;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfSectionsInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kHSYBasePageMainScrollCellIdentifier = @"HSYBasePageMainScrollCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHSYBasePageMainScrollCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHSYBasePageMainScrollCellIdentifier];
    }
    UIView *contentView = [self.delegate hsy_pageViewInPageScrollView:self];
    [cell.contentView addSubview:contentView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate hsy_listViewHeightInPageScrollView:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self mainScrollViewDidScroll:scrollView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_mainTableViewDidScroll:)]) {
        [self.delegate hsy_mainTableViewDidScroll:scrollView];
    }
}

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取mainScrollview偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.criticalScrollValue;
    
    // 根据偏移量判断是否上滑到临界点
    self.scrollDidCriticalValue = (offsetY >= criticalPoint);
    if (self.scrollDidCriticalValue) {
        //上滑到临界点后，固定其位置
        scrollView.contentOffset = CGPointMake(0.0f, criticalPoint);
        self.mainViewScrollState = NO;
        self.listViewScrollState = YES;
    } else {
        if (self.mainViewScrollState) {
            //未达到临界点，mainScrollview可滑动，需要重置所有listScrollView的位置
            [self.listViewPages enumerateObjectsUsingBlock:^(UIViewController<HSYBasePageTableDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIScrollView *listScrollView = [obj hsy_listScrollView];
                listScrollView.contentOffset = CGPointZero;
                listScrollView.showsVerticalScrollIndicator = NO;
            }];
        } else {
            //未到达临界点，mainScrollview不可滑动，固定其位置
            scrollView.contentOffset = CGPointMake(0.0f, criticalPoint);
        }
    }
}

- (void)hsy_listScrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果禁止listScrollview滑动，则固定其位置
    if (!self.listViewScrollState) {
        scrollView.contentOffset = CGPointZero;
    }
    //获取listScrollview偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    //listScrollView下滑至offsetY小于0，禁止其滑动，让mainTableView可下滑
    if (offsetY < 0.0f) {
        self.mainViewScrollState = YES;
        self.listViewScrollState = NO;
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        if (self.listViewScrollState) {
            scrollView.showsVerticalScrollIndicator = YES;
        }
    }
}

@end
