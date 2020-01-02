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
#import <HSYMethodsToolsKit/UIScrollView+Pages.h>
#import "HSYBaseCustomSegmentedPageControlItem.h"

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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"touch.class=> %@", NSStringFromClass(touch.view.class));
    NSArray<NSString *> *receiveClasses = @[NSStringFromClass(HSYBaseCustomSegmentedPageControlItem.class), NSStringFromClass(UIImageView.class)]; 
    if ([receiveClasses containsObject:NSStringFromClass(touch.view.class)]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBasePageTableCell : UITableViewCell

@property (nonatomic, strong, setter=hsy_setPageContentView:) UIView *pageContentView;

@end

@implementation HSYBasePageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = self.backgroundColor;
    }
    return self;
}

- (void)hsy_setPageContentView:(UIView *)pageContentView
{
    if (!pageContentView) {
        return;
    }
    _pageContentView = pageContentView;
    [self.contentView addSubview:pageContentView];
}

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBasePageScrollView () <UITableViewDelegate, UITableViewDataSource> {
    @private HSYBasePageTableView *_mainTableView;
}

@property (nonatomic, assign) BOOL listViewScrollState;
@property (nonatomic, assign, setter=hsy_setMainScrollEnable:) BOOL mainViewScrollState;
@property (nonatomic, strong) NSArray<UIViewController<HSYBasePageTableDelegate> *> *listViewPages;

@end

@implementation HSYBasePageScrollView

- (instancetype)initWithDelegate:(id<HSYBasePageScrollDelegate>)delegate
{
    if (self = [super initWithSize:CGSizeMake(IPHONE_WIDTH, IPHONE_HEIGHT)]) {
        //默认的变量标记状态
        self.mainViewScrollState = YES;
        //设置委托
        self.delegate = delegate;
        //由委托获取外部返回的添加过HSYBasePageTableDelegate协议的UIViewController控制器集合，并且设置子控制器中的UIScrollView类族的bounces为NO
        self.listViewPages = [self.delegate hsy_listViewsInPageScrollView:self];
        [self.listViewPages enumerateObjectsUsingBlock:^(UIViewController<HSYBasePageTableDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hsy_listScrollView.bounces = NO;
        }];
    }
    return self;
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

- (void)hsy_setMainScrollEnable:(BOOL)mainViewScrollState
{
    _mainViewScrollState = mainViewScrollState;
    self.listViewScrollState = !mainViewScrollState;
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
    HSYBasePageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kHSYBasePageMainScrollCellIdentifier];
    if (!cell) {
        cell = [[HSYBasePageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHSYBasePageMainScrollCellIdentifier];
    }
    cell.pageContentView = [self.delegate hsy_pageViewInPageScrollView:self];
    return cell; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate hsy_listViewHeightInPageScrollView:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hsy_mainScrollViewDidScroll:scrollView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_mainTableViewDidScroll:)]) {
        [self.delegate hsy_mainTableViewDidScroll:scrollView];
    }
}

- (void)hsy_mainScrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取mainScrollView偏移量
    CGFloat offsetY = self.mainTableView.contentOffset.y;
    CGFloat criticalPoint = [self.mainTableView rectForSection:0].origin.y - self.criticalScrollValue;
    // 根据偏移量判断是否上滑到临界点
    @weakify(self);
    BOOL scrollDidCriticalValue = (offsetY >= criticalPoint);
    if (scrollDidCriticalValue) {
        //到达滚动临界点后，需要把mainTablView固定在临界点的位置
        self.mainViewScrollState = NO;
        self.mainTableView.contentOffset = CGPointMake(0.0f, criticalPoint);
    } else {
        //未达到临界点，mainScrollview可滑动，需要重置所有listScrollView的位置
        [self.listViewPages enumerateObjectsUsingBlock:^(UIViewController<HSYBasePageTableDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            UIScrollView *listScrollView = obj.hsy_listScrollView;
            BOOL thisSelectedPages = (self.selectedPage == idx);
            if (!self.mainViewScrollState && thisSelectedPages) {
                self.mainViewScrollState = (listScrollView.contentOffset.y <= 0.0f);
            }
            if (!self.listViewScrollState && thisSelectedPages) {
                listScrollView.contentOffset = CGPointZero;
            }
            NSLog(@"listScrollEnable=> %@, mainScrollEnable=> %@", @(self.listViewScrollState), @(self.mainViewScrollState));
            self.mainTableView.showsVerticalScrollIndicator = scrollDidCriticalValue;
            listScrollView.showsVerticalScrollIndicator = !self.mainTableView.showsVerticalScrollIndicator;
        }];
        if (!self.mainViewScrollState) {
            //未到达临界点，mainScrollview不可滑动，固定其位置
            self.mainTableView.contentOffset = CGPointMake(0.0f, criticalPoint);
        }
    }
}

@end
