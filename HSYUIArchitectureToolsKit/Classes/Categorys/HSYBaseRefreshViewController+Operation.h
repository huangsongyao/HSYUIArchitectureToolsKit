//
//  HSYBaseRefreshViewController+Operation.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/18.
//

#import "HSYBaseRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HSYBaseRefreshDeselectRowBlock)(NSIndexPath *indexPath, UIScrollView *scrollView, UIView *cell);
typedef void(^HSYBaseRefreshViewDidLoadCompleted)(HSYBaseRefreshViewModel * _Nullable viewModel, HSYBaseViewController * _Nullable viewController);
@interface HSYBaseRefreshViewController (Operation)

@property (nonatomic, copy) HSYBaseRefreshDeselectRowBlock hsy_deselectRowBlock;
@property (nonatomic, copy) HSYBaseRefreshViewDidLoadCompleted hsy_viewDidLoadCompletedBlock;
- (CGRect)hsy_toListCGRect;

@end

NS_ASSUME_NONNULL_END
