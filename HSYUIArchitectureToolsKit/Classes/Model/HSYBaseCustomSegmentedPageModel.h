//
//  HSYBaseCustomSegmentedPageModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseModel.h"
#import "HSYBaseCustomSegmentedPageControlItem.h"
#import <HSYMethodsToolsKit/UIViewController+Load.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseCustomSegmentedPageControlModel : HSYBaseModel

//未选中时的image，url或者图标名称
@property (nonatomic, copy) NSString *image;
//选中时的image，url或者图标名称
@property (nonatomic, copy) NSString *highImage;
//默认占位图，如果image和highImage为url时，这个属性才有效
@property (nonatomic, copy) NSString *placeholderImage;
//按钮的title
@property (nonatomic, copy) NSString *title;
//未选中时的title的字体字号
@property (nonatomic, strong) UIFont *normalFont;
//选中时的title的字体字号
@property (nonatomic, strong) UIFont *selectedFont;
//未选中时的title的字体颜色
@property (nonatomic, strong) UIColor *normalTextColor;
//选中时的title的字体颜色
@property (nonatomic, strong) UIColor *selectedTextColor;
//按钮的选中状态
@property (nonatomic, strong) NSNumber *selectedStatus;
//按钮的width宽度
@property (nonatomic, strong) NSNumber *itemWidths;
//按钮的tag，即按钮位于UIScrollView的hsy_subviews或者subviews中的位置
@property (nonatomic, strong) NSNumber *itemId;

/**
 返回根据选中状态区分的当前图标或者远端地址

 @return 当前图标或者远端地址
 */
- (NSString *)hsy_controlItemImage;

/**
 返回根据选中状态区分的当前按钮title字体字号

 @return 当前按钮title字体字号
 */
- (UIFont *)hsy_controlItemFont;

/**
 返回根据选中状态区分的当前按钮title字体颜色

 @return 当前按钮title字体颜色
 */
- (UIColor *)hsy_controlTextColor;

@end

//********************************************************************************************************************************************************************************************************************************************************

@class RACSignal;
@interface HSYBaseCustomSegmentedPageModel : HSYBaseModel 

//按钮item项的参数模型对应的集合
@property (nonatomic, strong) NSMutableArray<HSYBaseCustomSegmentedPageControlModel *> *controlModels;
//HSYBaseCustomSegmentedPageControl的背景图片或者背景图片的远端url
@property (nonatomic, copy) NSString *controlBackgroundImage;
//当self.controlBackgroundImage为远端url时有效，表示默认的占位背景图
@property (nonatomic, copy) NSString *controlBackgroundPlaceholderImage;
//是否显示选中状态的下划线
@property (nonatomic, strong) NSNumber *showControlLine;
//选中状态的下划线的颜色
@property (nonatomic, strong) UIColor *controlLineColor;
//选中状态的下划线的粗细=>NSValue=>CGSize
@property (nonatomic, strong) NSValue *controlLineThickness;
//选中状态的下划线的圆角角度
@property (nonatomic, strong) NSNumber *controlLineCirculars;
//选中状态的下划线距离底部的便宜量
@property (nonatomic, strong) NSNumber *controlLineOffsetBottoms;
//HSYBaseCustomSegmentedPageControl的底部横线的颜色
@property (nonatomic, strong) UIColor *controlBottomLineColor;
//HSYBaseCustomSegmentedPageControl的底部横线的粗细
@property (nonatomic, strong) NSNumber *controlBottomLineThickness;
//是否显示HSYBaseCustomSegmentedPageControl的底部横线
@property (nonatomic, strong) NSNumber *showControlBottomLine;
//HSYBaseCustomSegmentedPageControl的UIScrollView是否可滚动
@property (nonatomic, strong) NSNumber *scrollEnabledStatus;
//是否使用自适应格式，使用自适应格式，HSYBaseCustomSegmentedPageControl的长度会根据UIScrollView的contentSize.width进行适应，最大为屏幕宽度
@property (nonatomic, strong) NSNumber *adaptiveFormat;
//外部设置HSYBaseCustomSegmentedPageControl的显示宽度，如果self.adaptiveFormat = YES，则这个属性不生效
@property (nonatomic, strong) NSNumber *controlWidths;
//是否将HSYBaseCustomSegmentedPageControl添加在titleView头部
@property (nonatomic, strong) NSNumber *titleViewFormat;

/**
 根据self.controlModels中的参数模型的selectedStatus属性的选中状态，返回HSYBaseCustomSegmentedPageControl当前选中的位置，如果self.controlModels中的参数模型的selectedStatus属性都为NO，则默认返回0

 @return 选中的位置
 */
- (NSInteger)hsy_itemSelectedIndex;

/**
 是否显示选中状态的下划线

 @return 是否显示选中状态的下划线
 */
- (BOOL)hsy_showSelecteLine;

/**
 是否显示HSYBaseCustomSegmentedPageControl的下底部横线
 
 @return 是否显示HSYBaseCustomSegmentedPageControl的下底部横线
 */
- (BOOL)hsy_showControlBottomLine;

/**
 将self.controlModels的所有参数模型的selectedStatus属性全部重置为NO

 @param index 选中位置的itemiId
 @return 返回一个包含了选中项的HSYBaseCustomSegmentedPageControlModel的参数模型的RACSignal结果信号
 */
- (RACSignal *)hsy_resetControlModelsUnselectedStatus:(NSInteger)index;

/**
 选中状态的下划线的size

 @param contentWidths HSYBaseCustomSegmentedPageControl的内部UIScrollView滚动条的contentSize.width
 @return 选中状态的下划线的size
 */
- (CGSize)hsy_selectedLineCGSize:(CGFloat)contentWidths;

/**
 返回HSYBaseCustomSegmentedPageControl的item视图集合

 @return HSYBaseCustomSegmentedPageControl的item视图集合
 */
- (NSArray<HSYBaseCustomSegmentedPageControlItem *> *)hsy_toSegmentedPageControlItems:(HSYBaseCustomSegmentedPageControlItemActionBlock)action;

/**
 返回HSYBaseCustomSegmentedPageControl的底部横线的高度

 @return HSYBaseCustomSegmentedPageControl的底部横线的高度
 */
- (CGFloat)hsy_toBottomLineHeights;

/**
 HSYBaseCustomSegmentedPageControl的UIScrollView是否可滚动，如果self.scrollEnabledStatus != nil，则以self.scrollEnabledStatus为准，否则返回默认的YES

 @return HSYBaseCustomSegmentedPageControl的UIScrollView是否可滚动
 */
- (BOOL)hsy_scrollEnabled;

/**
 设置HSYBaseCustomSegmentedPageControl的背景图

 @param backgroundImageView HSYBaseCustomSegmentedPageControl的背景图的UIImageView对象
 */
- (void)hsy_setControlItemBackgroundImage:(UIImageView *)backgroundImageView;

/**
 HSYBaseCustomSegmentedPageControl的选中的下划线颜色，如果self.controlLineColor == nil，则默认返回(51, 51, 51)

 @return UIColor
 */
- (UIColor *)hsy_toControlSelectedLineColor;

/**
 HSYBaseCustomSegmentedPageControl的底部横线颜色，如果self.controlBottomLineColor == nil，则返回默认的(0x999999)

 @return UIColor
 */
- (UIColor *)hsy_toControlBottomLineColor;

/**
 外部设置HSYBaseCustomSegmentedPageControl的显示宽度，如果self.adaptiveFormat = YES，则这个属性不生效，否则如果self.adaptiveFormat = NO & self.controlWidths = nil，默认返回设备屏幕宽度

 @return CGFloat
 */
- (CGFloat)hsy_toControlWidths;

/**
 返回选中状态下划线距离底部的偏移量

 @return 选中状态下划线距离底部的偏移量
 */
- (CGFloat)hsy_toControlLineOffsetBottoms;

/**
 HSYBaseCustomSegmentedPageControl的存在形式，返回self.titleViewFormat.boolValue，如果为NO，则HSYBaseCustomSegmentedPageControl在(0, 0)位置，如果为YES，则HSYBaseCustomSegmentedPageControl在titleView位置，默认返回YES
 
 @return HSYBaseCustomSegmentedPageControl的存在形式
 */
- (BOOL)hsy_segmentedPageControlTitleViewFormat;

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBaseCustomSegmentedPageControllerModel : HSYBaseModel

//子控制器的参数集合，格式为:@[@{@"UIViewController-A类名" : @{@"UIViewController-A.property-a" : @"UIViewController-A.property-a=>value", @"UIViewController-A.property-b" : @"UIViewController-A.property-b=>value'", ... }}, @{@"UIViewController-B类名" : @{@"UIViewController-B.property-a" : @"UIViewController-B.property-a=>value", @"UIViewController-B.property-b" : @"UIViewController-B.property-b=>value'", ... }}, ... ]
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSDictionary<NSString *, id> *> *> *viewControllers;
//HSYBaseCustomSegmentedPageControl的参数模型
@property (nonatomic, strong) HSYBaseCustomSegmentedPageModel *segmentedPageControlModel;

/**
 返回分页控制器的子控制器对象的集合

 @param delegate UIViewControllerRuntimeDelegate委托
 @return NSArray<UIViewController *> * => 子控制器对象的集合
 */
- (NSArray<UIViewController *> *)hsy_toViewControllers:(id<UIViewControllerRuntimeDelegate>)delegate;

/**
 返回根据self.segmentedPageControlModel.hsy_toControlWidths的值均等分后的HSYBaseCustomSegmentedPageControlItem的宽度

 @return HSYBaseCustomSegmentedPageControlItem的均等分宽度
 */
- (CGFloat)hsy_toAreEqualControlItemWidths;

@end

NS_ASSUME_NONNULL_END
