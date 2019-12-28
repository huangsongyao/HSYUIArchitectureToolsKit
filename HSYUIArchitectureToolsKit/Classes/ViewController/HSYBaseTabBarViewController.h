//
//  HSYBaseTabBarViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/23.
//

#import "HSYBaseCollectionViewController.h"
#import "HSYBaseTabBarViewModel.h"

NS_ASSUME_NONNULL_BEGIN

//全局委托的回调事件
typedef void(^HSYBaseTabBarRuntimeDelegateBlock)(UIViewControllerRuntimeObject *object, HSYBaseTabBarItemConfig *config, HSYBaseTabBarViewModel *viewModel, NSNumber *itemId, UIViewController *viewController);
@interface HSYBaseTabBarViewController : HSYBaseCollectionViewController <UIViewControllerRuntimeDelegate>

//收到UIViewController.hsy_runtimeDelegate的委托回调事件后，HSYBaseTabBarViewController会通过self.runtimeDelegateBlock将事件进一步抛给子类
@property (nonatomic, copy) HSYBaseTabBarRuntimeDelegateBlock runtimeDelegateBlock;
//设置伪Tabbar的背景图
@property (nonatomic, strong, setter=hsy_setTabbarBackgroundImage:) UIImage *tabBarBackgroundImage;
//设置当前选中的子控制器项
@property (nonatomic, assign, setter=hsy_setTabbarSelectedIndex:) NSInteger selectedIndex;
//设置主滚动视图是否开始左右滚动翻页功能，默认为否
@property (nonatomic, assign, setter=hsy_setMainScrollEnabledStatus:) BOOL mainScrollEnabled;

/**
 初始化，传入一个数据源缓存数组作为参数

 @param configs 数据源集合
 @return HSYBaseTabBarViewController
 */
- (instancetype)initWithConfigs:(NSArray<HSYBaseTabBarItemConfig *> *)configs;

/**
 返回一层list子视图的属性名称集合

 @return list子视图的属性名称集合
 */
+ (NSArray<NSString *> *)hsy_listOfSubviews;

@end

NS_ASSUME_NONNULL_END
