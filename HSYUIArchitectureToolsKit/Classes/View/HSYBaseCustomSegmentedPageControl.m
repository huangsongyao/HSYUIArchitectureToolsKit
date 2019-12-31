//
//  HSYBaseCustomSegmentedPageControl.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseCustomSegmentedPageControl.h"
#import <HSYMethodsToolsKit/UIImage+Canvas.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMethodsToolsKit/UIScrollView+Pages.h>
#import <HSYMacroKit/HSYToolsMacro.h>

//********************************************************************************************************************************************************************************************************************************************************

@interface UIScrollView (PrivateForSegementedControl)

/**
 私有方法 => 用于获取选中下划线的偏移量位置x

 @param index 当前选中的index
 @param widths 下划线的宽度
 @return 选中下划线的便宜位置x
 */
- (CGFloat)hsy_segmentedControlSelectedLineOriginal:(NSInteger)index withLineWidths:(CGFloat)widths;

/**
 私有方法 => 用于获取选中状态下划线的初始位置的偏移量x

 @param lineWidths 下划线的宽度
 @return 选中状态下划线的初始位置的偏移量x
 */
- (CGFloat)hsy_selectedLineOffsets:(CGFloat)lineWidths;

/**
 私有方法 => 用于计算外部segmentedPage的子控制器中的UIScrollView滚动距离映射为对应的下划线移动偏移量x

 @param scales [0, 1]闭区间，为当前手势交互的滚动范围的映射
 @param widths 下划线的宽度
 @return 返回计算外部segmentedPage的子控制器中的UIScrollView滚动距离映射为对应的下划线移动偏移量x
 */
- (CGFloat)hsy_setContentOffsets:(CGFloat)scales withLineWidths:(CGFloat)widths;

@end

@implementation UIScrollView (PrivateForSegementedControl)

- (CGFloat)hsy_segmentedControlSelectedLineOriginal:(NSInteger)index withLineWidths:(CGFloat)widths
{
    UIView *subview = [self hsy_subview:index];
    CGFloat lineOffsetX = [self hsy_selectedLineOffsets:widths];
    CGFloat scrollOffsetX = (subview.x + lineOffsetX);
    return scrollOffsetX;
}

- (CGFloat)hsy_selectedLineOffsets:(CGFloat)lineWidths
{
    UIView *firstView = [self hsy_subview:0];
    CGFloat lineOffsetX = ((firstView.width - lineWidths) / 2.0f);
    return lineOffsetX;
}

- (CGFloat)hsy_setContentOffsets:(CGFloat)scales withLineWidths:(CGFloat)widths
{
    CGFloat realScales = MAX(0.0f, scales);
    realScales = MIN(1.0, realScales);
    CGFloat lineOffsetX = [self hsy_selectedLineOffsets:widths];
    CGFloat sumOffsets = (self.hsy_contentSizeWidth - lineOffsetX * 2.0f - widths);
    CGFloat x = (lineOffsetX + (sumOffsets * realScales));
    return x;
}

@end

//********************************************************************************************************************************************************************************************************************************************************

static CGFloat const kHSYBaseCustomSegmentedPageControlForHeights = 44.0f;
static CGFloat const kHSYBaseCustomSegmentedPageControlForAnimationDuration = 0.25f;
static CGFloat const kHSYBaseCustomSegmentedPageControlForDefaultScrollOffsets = 50.0f;

@interface HSYBaseCustomSegmentedPageControl ()

@property (nonatomic, copy, readonly) NSArray<HSYBaseCustomSegmentedPageControlItem *> *controlItems;
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HSYBaseCustomSegmentedPageControl

- (instancetype)initWithSegmentedPageModel:(HSYBaseCustomSegmentedPageModel *)segmentedPageModel
{
    if (self = [super initWithHeight:kHSYBaseCustomSegmentedPageControlForHeights]) {
        @weakify(self);
        //添加对数据和交互的监听
        self->_segmentedPageControlModel = segmentedPageModel;
        self->_controlItems = [segmentedPageModel hsy_toSegmentedPageControlItems:^RACSignal<RACTuple *> * _Nonnull(HSYBaseCustomSegmentedPageControlItem * _Nonnull button, HSYBaseCustomSegmentedPageControlModel * _Nonnull controlModel) {
            return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self hsy_setSelectedItemStatus:controlModel.itemId.integerValue withCompleted:^(BOOL finished, HSYBaseCustomSegmentedPageControlItem *controlItem) {
                    @strongify(self);
                    [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack(controlModel, button)];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_clickedSelectedIndex:withSegmentedPageControlModel:bySegmentedPageControl:)]) {
                        [self.delegate hsy_clickedSelectedIndex:controlItem.controlModel.itemId.integerValue withSegmentedPageControlModel:controlItem.controlModel bySegmentedPageControl:self];
                    }
                }];
            }];
        }];
        //初始化
        self.scrollView.scrollEnabled = self.segmentedPageControlModel.hsy_scrollEnabled;
        [segmentedPageModel hsy_setControlItemBackgroundImage:self.backgroundImageView];
        self.bottomLine.hidden = !segmentedPageModel.hsy_showControlBottomLine;
        self.selectedLine.hidden = !segmentedPageModel.hsy_showSelecteLine;
        self.selectedIndex = segmentedPageModel.hsy_itemSelectedIndex;
    }
    return self;
}

#pragma mark - Methods

- (void)hsy_setContentOffsets:(CGFloat)scales
{
    CGFloat offsetsX = [self.scrollView hsy_setContentOffsets:scales withLineWidths:self.selectedLine.width];
    self.selectedLine.x = offsetsX;
}

- (void)hsy_resetControlWidths
{
    CGFloat widths = self.segmentedPageControlModel.hsy_toControlWidths;
    if (self.segmentedPageControlModel.adaptiveFormat.boolValue) {
        widths = MIN(_scrollView.hsy_contentSizeWidth, IPHONE_WIDTH);
    }
    self.width = widths;
    _scrollView.width = self.width;
}

- (void)hsy_scrollToLocation:(HSYBaseCustomSegmentedPageControlItem *)button
{
    CGFloat x = 0;
    if ((button.x - self.scrollView.contentOffset.x) < self.width/2) {
        if (self.selectedIndex > 0) {
            UIButton *preButton = self.controlItems[self.selectedIndex - 1];
            x = preButton.x;
            if (x > self.scrollView.contentOffset.x) {
                return;
            }
        } else {
            x = -kHSYBaseCustomSegmentedPageControlForDefaultScrollOffsets;
        }
    } else {
        if ((self.selectedIndex + 1) < self.controlItems.count) {
            UIButton *nextButton = self.controlItems[(self.selectedIndex + 1)];
            x = nextButton.right - self.width;
            if (x < self.scrollView.contentOffset.x) {
                return;
            }
        } else {
            x = button.right;
        }
    }
    [self.scrollView scrollRectToVisible:CGRectMake(x, 0, self.scrollView.width, self.height) animated:YES];
}

#pragma mark - Lazy

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *image = [UIImage hsy_imageWithFillColor:UIColor.clearColor];
        _backgroundImageView.image = image;
        _backgroundImageView.highlightedImage = image;
        [self addSubview:_backgroundImageView];
        [self sendSubviewToBack:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (UIView *)selectedLine
{
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] initWithSize:[self.segmentedPageControlModel hsy_selectedLineCGSize:self.scrollView.hsy_contentSizeWidth]];
        _selectedLine.y = (self.height - _selectedLine.height - self.segmentedPageControlModel.hsy_toControlLineOffsetBottoms);
        _selectedLine.x = [self.scrollView hsy_segmentedControlSelectedLineOriginal:self.selectedIndex withLineWidths:_selectedLine.width];
        _selectedLine.backgroundColor = self.segmentedPageControlModel.hsy_toControlSelectedLineColor;
        _selectedLine.layer.cornerRadius = self.segmentedPageControlModel.controlLineCirculars.doubleValue;
        [self.scrollView addSubview:_selectedLine];
        [self.scrollView bringSubviewToFront:_selectedLine];
    }
    return _selectedLine;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        CGFloat x = 0.0f;
        for (HSYBaseCustomSegmentedPageControlItem *controlItem in self.controlItems) {
            controlItem.x = x;
            controlItem.height = _scrollView.height;
            [_scrollView hsy_addSubview:controlItem];
            x = controlItem.right;
        }
        _scrollView.contentSize = CGSizeMake(x, _scrollView.height);
        [self hsy_resetControlWidths];
    }
    return _scrollView;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithSize:CGSizeMake(self.width, self.segmentedPageControlModel.hsy_toBottomLineHeights)];
        _bottomLine.y = (self.height - _bottomLine.height);
        _bottomLine.backgroundColor = self.segmentedPageControlModel.hsy_toControlBottomLineColor;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

#pragma mark - Setter

- (void)hsy_setBackgroundImage:(NSString *)controlBackgroundImage
{
    _controlBackgroundImage = controlBackgroundImage;
    self.segmentedPageControlModel.controlBackgroundImage = controlBackgroundImage;
    [self.segmentedPageControlModel hsy_setControlItemBackgroundImage:self.backgroundImageView];
}

- (void)hsy_setControlLineThickness:(NSValue *)selectedLineThickness
{
    _selectedLineThickness = selectedLineThickness;
    self.segmentedPageControlModel.controlLineThickness = selectedLineThickness;
    self.selectedLine.size = [self.segmentedPageControlModel hsy_selectedLineCGSize:self.scrollView.hsy_contentSizeWidth];
}

- (void)hsy_setControlLineOffsetBottoms:(NSNumber *)selectedLineOffsetBottoms
{
    _selectedLineOffsetBottoms = selectedLineOffsetBottoms;
    self.segmentedPageControlModel.controlLineOffsetBottoms = selectedLineOffsetBottoms;
    self.selectedLine.y = (self.height - _selectedLine.height - self.segmentedPageControlModel.hsy_toControlLineOffsetBottoms);;
}

- (void)hsy_setControlLineCirculars:(NSNumber *)selectedLineCirculars
{
    _selectedLineCirculars = selectedLineCirculars;
    self.segmentedPageControlModel.controlLineCirculars = selectedLineCirculars;
    self.selectedLine.layer.cornerRadius = self.segmentedPageControlModel.controlLineCirculars.doubleValue;
}

- (void)hsy_setControlLineColor:(UIColor *)selectedLineColor
{
    _selectedLineColor = selectedLineColor;
    self.segmentedPageControlModel.controlLineColor = selectedLineColor;
    self.selectedLine.backgroundColor = self.segmentedPageControlModel.hsy_toControlSelectedLineColor;
}

- (void)hsy_setControlBottomLineThickness:(NSNumber *)bottomLineThickness
{
    _bottomLineThickness = bottomLineThickness;
    self.segmentedPageControlModel.controlBottomLineThickness = bottomLineThickness;
    self.bottomLine.height = self.segmentedPageControlModel.hsy_toBottomLineHeights;
}

- (void)hsy_setControlBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    self.segmentedPageControlModel.controlBottomLineColor = bottomLineColor;
    self.bottomLine.backgroundColor = self.segmentedPageControlModel.hsy_toControlBottomLineColor;
}

- (void)hsy_setControlAdaptiveFormat:(BOOL)adaptiveFormat
{
    _adaptiveFormat = adaptiveFormat;
    [self hsy_resetControlWidths];
}

- (void)hsy_setSelectedIndex:(NSInteger)selectedIndex
{
    @weakify(self);
    [self hsy_setSelectedItemStatus:selectedIndex withCompleted:^(BOOL finished,  HSYBaseCustomSegmentedPageControlItem *controlItem) {
        @strongify(self);
        [self hsy_scrollSelectedLine:selectedIndex completed:^(BOOL finished) {
            @strongify(self);
            [controlItem hsy_resetSelectedSegmentedPageControlModel];
            if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_setSelectedIndex:withSegmentedPageControlModel:bySegmentedPageControl:)]) {
                [self.delegate hsy_setSelectedIndex:selectedIndex withSegmentedPageControlModel:controlItem.controlModel bySegmentedPageControl:self];
            }
        }];
    }];
}

- (void)hsy_setSelectedItemStatus:(NSInteger)forSelectedIndex withCompleted:(void(^)(BOOL finished, HSYBaseCustomSegmentedPageControlItem *controlItem))completed
{
    _selectedIndex = forSelectedIndex;
    @weakify(self);
    [[[self.segmentedPageControlModel hsy_resetControlModelsUnselectedStatus:forSelectedIndex] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(HSYBaseCustomSegmentedPageControlItem * _Nullable thisControlItem) {
        @strongify(self);
        HSYBaseCustomSegmentedPageControlModel *controlModel = thisControlItem.controlModel;
        [self hsy_scrollToLocation:thisControlItem];
        [self hsy_scrollSelectedLine:controlModel.itemId.integerValue completed:^(BOOL finished) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(hsy_selectedSegmentedPageControl:withSegmentedPageControlModel:bySegmentedPageControl:)]) {
                [self.delegate hsy_selectedSegmentedPageControl:controlModel.itemId.integerValue withSegmentedPageControlModel:controlModel bySegmentedPageControl:self];
            }
            if (completed) {
                completed(YES, thisControlItem);
            }
        }];
    }];
}

#pragma mark - Animation

- (void)hsy_scrollSelectedLine:(NSInteger)index completed:(void(^)(BOOL finished))completed
{
    CGFloat x = [self.scrollView hsy_segmentedControlSelectedLineOriginal:index withLineWidths:self.selectedLine.width];
    if (x == self.selectedLine.x) {
        if (completed) {
            completed(YES);
        }
        return;
    }
    @weakify(self);
    [UIView animateWithDuration:kHSYBaseCustomSegmentedPageControlForAnimationDuration animations:^{
        @strongify(self);
        self.selectedLine.x = x;
    } completion:completed];
}


@end
