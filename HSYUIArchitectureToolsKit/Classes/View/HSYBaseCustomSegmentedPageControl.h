//
//  HSYBaseCustomSegmentedPageControl.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseView.h"
#import "HSYBaseCustomSegmentedPageModel.h" 
#import "HSYBaseCustomSegmentedPageControlItem.h"

NS_ASSUME_NONNULL_BEGIN

@class HSYBaseCustomSegmentedPageControl;
@protocol HSYBaseCustomSegmentedPageControlDelegate <NSObject>

@optional

/**
 切换委托，当HSYBaseCustomSegmentedPageControl的selectedIndex属性被setter触发切换或者通过交互手势触发切换时，这个委托会被触发

 @param index 当前选中的index
 @param controlModel 选中index对应的item的数据模型
 @param segmentedPageControl HSYBaseCustomSegmentedPageControl对象
 */
- (void)hsy_selectedSegmentedPageControl:(NSInteger)index withSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel bySegmentedPageControl:(HSYBaseCustomSegmentedPageControl *)segmentedPageControl;

/**
 外部通过HSYBaseCustomSegmentedPageControl的selectedIndex属性来触发切换时，这个委托会被调用=>[这个委托方法会在@selector(hsy_selectedSegmentedPageControl:withSegmentedPageControlModel:bySegmentedPageControl:)这个委托方法触发后触发]

 @param index 当前选中的index
 @param controlModel 选中index对应的item的数据模型
 @param segmentedPageControl HSYBaseCustomSegmentedPageControl对象
 */
- (void)hsy_setSelectedIndex:(NSInteger)index withSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel bySegmentedPageControl:(HSYBaseCustomSegmentedPageControl *)segmentedPageControl;

/**
 内部通过按钮的touch事件触发切换时，这个委托会被调用=>[这个委托方法会在@selector(hsy_selectedSegmentedPageControl:withSegmentedPageControlModel:bySegmentedPageControl:)这个委托方法触发后触发]

 @param index 当前选中的index
 @param controlModel 选中index对应的item的数据模型
 @param segmentedPageControl HSYBaseCustomSegmentedPageControl对象
 */
- (void)hsy_clickedSelectedIndex:(NSInteger)index withSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel bySegmentedPageControl:(HSYBaseCustomSegmentedPageControl *)segmentedPageControl;

@end

@interface HSYBaseCustomSegmentedPageControl : HSYBaseView

//数据模型
@property (nonatomic, strong, readonly) HSYBaseCustomSegmentedPageModel *segmentedPageControlModel;
//外部设置HSYBaseCustomSegmentedPageControl的背景图片，可以设置为完整的图标名称或者远端url
@property (nonatomic, copy, setter=hsy_setBackgroundImage:) NSString *controlBackgroundImage;
//外部设置HSYBaseCustomSegmentedPageControl选中状态下划线的CGSize，返回一个NSValue<CGSize>类型
@property (nonatomic, strong, setter=hsy_setControlLineThickness:) NSValue *selectedLineThickness;
//外部设置HSYBaseCustomSegmentedPageControl选中状态下划线的两端的圆角
@property (nonatomic, strong, setter=hsy_setControlLineCirculars:) NSNumber *selectedLineCirculars;
//外部设置HSYBaseCustomSegmentedPageControl选中状态下划线的颜色
@property (nonatomic, strong, setter=hsy_setControlLineColor:) UIColor *selectedLineColor;
//外部设置HSYBaseCustomSegmentedPageControl选中状态下划线距离底部的偏移量
@property (nonatomic, assign, setter=hsy_setControlLineOffsetBottoms:) NSNumber *selectedLineOffsetBottoms;
//外部设置HSYBaseCustomSegmentedPageControl底部横线的粗细
@property (nonatomic, strong, setter=hsy_setControlBottomLineThickness:) NSNumber *bottomLineThickness;
//外部设置HSYBaseCustomSegmentedPageControl底部横线的颜色
@property (nonatomic, strong, setter=hsy_setControlBottomLineColor:) UIColor *bottomLineColor;
//外部设置HSYBaseCustomSegmentedPageControl的选中位置
@property (nonatomic, assign, setter=hsy_setSelectedIndex:) NSInteger selectedIndex;
//外部设置HSYBaseCustomSegmentedPageControl的自适应模式，如果为YES，则根据每个item的宽度计算出整体的显示宽度，最大为设备宽度；如果为NO，则使用self.segmentedPageControlModel的参数设置
@property (nonatomic, assign, setter=hsy_setControlAdaptiveFormat:) BOOL adaptiveFormat;
//外部设置HSYBaseCustomSegmentedPageControl的HSYBaseCustomSegmentedPageControlItem的宽度
@property (nonatomic, assign, setter=hsy_setControlItemWidths:) CGFloat controlItemWidths;
//委托
@property (nonatomic, weak) id<HSYBaseCustomSegmentedPageControlDelegate>delegate;

/**
 快速创建方法

 @param segmentedPageModel HSYBaseCustomSegmentedPageControl的参数模型
 @return HSYBaseCustomSegmentedPageControl
 */
- (instancetype)initWithSegmentedPageModel:(HSYBaseCustomSegmentedPageModel *)segmentedPageModel;

/**
 外部设置滚动下划线的滚动比例

 @param scales [0, 1]闭区间，为当前UIScrollView滚动的百分比
 */
- (void)hsy_setContentOffsets:(CGFloat)scales;

/**
 返回HSYBaseCustomSegmentedPageControl的HSYBaseCustomSegmentedPageControlItem项的缓存集合

 @return NSArray<HSYBaseCustomSegmentedPageControlItem *> *
 */
- (NSArray<HSYBaseCustomSegmentedPageControlItem *> *)hsy_toSegmentedPageControlItems;

@end

NS_ASSUME_NONNULL_END
