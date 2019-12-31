//
//  HSYBaseMainSegmentedViewModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseMainSegmentedViewModel.h"

@interface HSYBaseMainSegmentedViewModel ()

@property (nonatomic, strong) HSYBaseCustomSegmentedPageViewController *mainSegmentedPageViewController;

@end

@implementation HSYBaseMainSegmentedViewModel

- (instancetype)initWithMainSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel
{
    if (self = [super init]) {
        self->_mainSegmentedPageControllerModel = segmentedPageModel;
    }
    return self;
}

- (HSYBaseCustomSegmentedPageViewController *)hsy_mainSegmentedPageViewController
{
    if (!self.mainSegmentedPageViewController) {
        self.mainSegmentedPageViewController = [[HSYBaseCustomSegmentedPageViewController alloc] initWithSegmentedPageModel:self.mainSegmentedPageControllerModel];
        self.mainSegmentedPageViewController.view.backgroundColor = UIColor.whiteColor;
        [self.mainSegmentedPageViewController hsy_resetScrollSubviewsLayout];
    }
    return self.mainSegmentedPageViewController;
}

- (HSYBaseCustomSegmentedPageControl *)hsy_mainSegmentedPageControl
{
    return self.hsy_mainSegmentedPageViewController.segmentedPageControl;
}

@end
