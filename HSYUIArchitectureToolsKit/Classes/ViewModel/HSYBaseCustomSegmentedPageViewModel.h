//
//  HSYBaseCustomSegmentedPageViewModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseRefreshViewModel.h"
#import "HSYBaseCustomSegmentedPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseCustomSegmentedPageViewModel : HSYBaseRefreshViewModel

//缓存参数对象的强引用
@property (nonatomic, strong, readonly) HSYBaseCustomSegmentedPageControllerModel *segmentedPageControllerModel;

/**
 快速创建方法

 @param segmentedPageModel HSYBaseCustomSegmentedPageControllerModel参数模型
 @return HSYBaseCustomSegmentedPageViewModel
 */
- (instancetype)initWithSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel;

/**
 返回分页控制器的分页control的参数模型HSYBaseCustomSegmentedPageControl

 @return HSYBaseCustomSegmentedPageModel
 */
- (HSYBaseCustomSegmentedPageModel *)hsy_toSegmentedPageControlModel;

/**
 返回分页控制器的子控制器的对象集合

 @param delegate 全局的runtime委托
 @return 分页控制器的子控制器的对象集合
 */
- (NSArray<UIViewController *> *)hsy_viewControllers:(id<UIViewControllerRuntimeDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
