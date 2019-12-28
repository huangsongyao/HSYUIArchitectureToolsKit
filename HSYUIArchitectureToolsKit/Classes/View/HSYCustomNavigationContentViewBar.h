//
//  HSYCustomNavigationContentViewBar.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HSYCustomNavigationBarForNextBlock)(UIButton *button, NSInteger tag);

@interface HSYCustomNavigationBar : UINavigationBar

//创建一个导航栏专用的item项，使用规则和正常使用UIViewController的navigationItem相同
@property (nonatomic, strong, readonly) UINavigationItem *customNavigationItem;

#pragma mark - Back Button

/**
 添加默认的导航栏返回按钮
 
 @param next 点击触发事件
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)hsy_defaultBackBarButtonItem:(HSYCustomNavigationBarForNextBlock)next;
/**
 添加默认的导航双按钮
 
 @param next 点击触发事件
 @return customView
 */
+ (NSArray *)hsy_defaultWebLeftCustomButtonItem:(void (^)(UIButton *button, NSInteger tag))next;
/**
 默认格式的image导航栏按钮，tag的为kXQCDefaultCustomBarButtonItemForKeyA
 
 @param paramter 入参，格式为：@{@"barButton.image.name" : @"barButton.hightlightImage.name"}
 @param action 点击触发事件
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)hsy_defaultImageBarButtonItem:(NSDictionary *)paramter clickedOnAction:(HSYCustomNavigationBarForNextBlock)action;

/**
 默认格式的双image导航栏按钮，tag的为kXQCDefaultCustomBarButtonItemForKeyA
 
 
 @param paramterArr 入参，格式为：@{@"barButton.image.name" : @"barButton.hightlightImage.name"}
 @param action 点击触发事件
 @return UIBarButtonItems
 */
+ (NSArray *)hsy_defaultImageLeftBarButtonItem:(NSArray<NSDictionary *> *)paramterArr clickedOnAction:(HSYCustomNavigationBarForNextBlock)action;

/**
 默认格式的title导航栏按钮，tag的为kXQCDefaultCustomBarButtonItemForKeyB，font为15字号，字体颜色为515151
 
 @param title title
 @param action 点击触发事件
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)hsy_defaultTitleBarButtonItem:(NSString *)title clickedOnAction:(HSYCustomNavigationBarForNextBlock)action;

@end

@interface HSYCustomNavigationContentViewBar : UIView

//定制的导航栏
@property (nonatomic, strong, readonly) HSYCustomNavigationBar *navigationBar;

//默认的构造函数
- (instancetype)initWithDefault;

/**
 设置bar的背景图片，如果backgroundImage为nil，则默认为白色
 
 @param backgroundImage 背景图片
 */
- (void)hsy_setCustomNavigationBarBackgroundImage:(UIImage *)backgroundImage;

#pragma mark - Line

/**
 清除底部横线
 */
- (void)hsy_clearNavigationBarBottomLine;

/**
 设置底部横线的色值
 
 @param color 横线的颜色
 */
- (void)hsy_customBarBottomLineOfColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
