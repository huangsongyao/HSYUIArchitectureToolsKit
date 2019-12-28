//
//  HSYBaseMainSegmentedViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseViewController.h"
#import "HSYBasePageScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseMainSegmentedViewController : HSYBaseViewController

//主界面的ScorllView
@property (nonatomic, strong, readonly) HSYBasePageScrollView *pageScrollView;

@end

NS_ASSUME_NONNULL_END
