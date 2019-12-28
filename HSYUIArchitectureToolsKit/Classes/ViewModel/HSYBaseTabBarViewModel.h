//
//  HSYBaseTabBarViewModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/23.
//

#import "HSYBaseRefreshViewModel.h"
#import "HSYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSInteger const kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally;

@interface HSYBaseTabBarItemConfig : HSYBaseModel

//item的normal状态的title内容
@property (nonatomic, copy) NSString *itemNormalTitle;
//item的normal状态的icon名称
@property (nonatomic, copy) NSString *itemNormalIcon;
//item的normal状态的title的字体颜色
@property (nonatomic, strong) UIColor *itemNormalTextColor;
//item的normal状态的title的字体字号
@property (nonatomic, strong) UIFont *itemNormalFont;

//item的selected状态的title内容
@property (nonatomic, copy) NSString *itemSelectedTitle;
//item的selected状态的icon名称
@property (nonatomic, copy) NSString *itemSelectedIcon;
//item的selected状态的title的字体颜色
@property (nonatomic, strong) UIColor *itemSelectedTextColor;
//item的selected状态的title的字体字号
@property (nonatomic, strong) UIFont *itemSelectedFont;

//item的index位置，从0开始
@property (nonatomic, strong) NSNumber *itemId;
//item的红点标签的红点个数
@property (nonatomic, strong) NSNumber *redPoints;
//item的红点标签的红点字体字号
@property (nonatomic, strong) UIFont *redPointsFont;
//item的红点的size，只有当self.redPoints == kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally时，这个属性才会生效
@property (nonatomic, strong) NSNumber *redPointsSize;
//item的对应子控制器的类名
@property (nonatomic, copy) NSString *viewControllerName;
//item的对应子控制器的可供kvc设置的参数
@property (nonatomic, strong) NSDictionary *viewControllerKVC;
//item项的选中状态
@property (nonatomic, strong) NSNumber *selected;
//item的icon是否使用其本身的原始size
@property (nonatomic, strong) NSNumber *userIconOriginalSize;

/**
 item的图标icon

 @return UIImage
 */
- (UIImage *)hsy_itemIconImage;

/**
 item的title的字号

 @return UIFont
 */
- (UIFont *)hsy_itemTitleFont;

/**
 item的字体颜色

 @return UIColor
 */
- (UIColor *)hsy_itemTextColor;

/**
 item的title文本

 @return NSString
 */
- (NSString *)hsy_itemTitleString;

/**
 item的红点的数目文本，如果self.redPoints == kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally，则显示size为5.0的小红点，否则如果self.redPoints > 99，则显示+99，否则显示self.redPoints本身

 @return NSString
 */
- (NSString *)hsy_redPointsString;

/**
 红点的size，通过计算后返回一个结果

 @return CGSize
 */
- (CGSize)hsy_redPointsCGSize;

/**
 是否显示红点

 @return BOOL
 */
- (BOOL)hsy_showRedPoints;

@end

@interface HSYBaseTabBarViewModel : HSYBaseRefreshViewModel

//item的size
@property (nonatomic, assign, readonly) CGSize itemSize;
//子控制器缓存数组
@property (nonatomic, copy, readonly) NSArray<UIViewController *> *viewControllers;
//数据源缓存数组
@property (nonatomic, copy, readonly) NSArray<HSYBaseTabBarItemConfig *> *tabBarConfigs;

/**
 初始化，传入一个数据源缓存数组作为参数

 @param configs 数据源集合
 @return HSYBaseTabBarViewModel
 */
- (instancetype)initWithConfigs:(NSArray<HSYBaseTabBarItemConfig *> *)configs;

/**
 通过itemId返回数据源中对应的数据模型

 @param itemId 数据模型在集合中的itemId
 @return HSYBaseTabBarItemConfig
 */
- (HSYBaseTabBarItemConfig *)hsy_getTabBarItemConfig:(NSNumber *)itemId;

/**
 通过itemId返回子控制器集合中对应的控制器对象

 @param itemId 数据模型在集合中的itemId
 @return UIViewController
 */
- (UIViewController *)hsy_getTabBarSubViewController:(NSNumber *)itemId;

/**
 返回当前的itemId

 @return 当前的itemId
 */
- (NSInteger)hsy_currentSelectedIndex;

/**
 通过itemId获取并设置集合中选中的数据模型的选中状态

 @param itemId 数据模型在集合中的itemId
 */
- (void)hsy_setSelectedItemStatus:(NSInteger)itemId;

@end 

NS_ASSUME_NONNULL_END
