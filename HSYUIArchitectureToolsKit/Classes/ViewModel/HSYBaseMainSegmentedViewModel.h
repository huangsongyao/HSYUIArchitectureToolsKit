//
//  HSYBaseMainSegmentedViewModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseRefreshViewModel.h"
#import "HSYBaseCustomSegmentedPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseCustomMainSegmentedViewController : HSYBaseCustomSegmentedPageViewController

@end

//********************************************************************************************************************************************************************************************************************************************************

@interface HSYBaseMainSegmentedViewModel : HSYBaseRefreshViewModel

@property (nonatomic, strong, readonly) HSYBaseCustomSegmentedPageControllerModel *mainSegmentedPageControllerModel;
- (instancetype)initWithMainSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel;
- (HSYBaseCustomSegmentedPageViewController *)hsy_mainSegmentedPageViewController;
- (HSYBaseCustomSegmentedPageControl *)hsy_mainSegmentedPageControl;

@end

NS_ASSUME_NONNULL_END
