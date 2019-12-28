//
//  HSYBaseViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/18.
//

#import <UIKit/UIKit.h>
#import "HSYBaseRefreshViewModel.h"
#import "HSYCustomNavigationContentViewBar.h"
#import <HSYMethodsToolsKit/UIViewController+Load.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseViewController : UIViewController

//MVVM中的VM，默认为nil，声明为nullable是为了在dealloc中做一些方法交换的事情，父类中对此属性做了建言，不允许为nil，所以子类必须在[super viewDidLoad]执行前初始化这个对象
@property (nonatomic, strong, nonnull) HSYBaseRefreshViewModel *viewModel; 
//真实的NavigationBar
@property (nonatomic, strong, readonly) HSYCustomNavigationContentViewBar *customNavigationContentViewBar;
//默认为NO，表示点击背景后结束键盘编辑
@property (nonatomic, assign, setter=setTouchEndEditing:) BOOL touchEndEditing;
//默认为YES，表示设置是否在当前的self.view上显示系统的loading-ui
@property (nonatomic, assign, setter=loadingDefault:) BOOL loading;
//默认为YES，用于子类设置是否禁止系统侧滑返回
@property (nonatomic, assign) BOOL interactivePopGestureRecognizerEnable;
//模仿传统意义中的栈控制器[UINavigationController]的子控制器中的self.view，将这个xqc_view放置于self.view上层，预备用于处理其他逻辑
@property (nonatomic, strong, readonly) UIView *hsy_view;
//禁止self.tapGesture单击事件响应的类的类名集合
@property (nonatomic, strong, nullable) NSArray<NSString *> *shouldForbidReceiveClasses; 

/**
 返回导航栏的UINavigationItem

 @return 导航栏的UINavigationItem
 */
- (UINavigationItem *)hsy_realNavigationBarItem;

@end

NS_ASSUME_NONNULL_END
