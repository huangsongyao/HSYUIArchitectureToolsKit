//
//  HSYBaseCustomSegmentedPageViewModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseCustomSegmentedPageViewModel.h"

@interface HSYBaseCustomSegmentedPageViewModel () {
    @private NSArray<UIViewController *> *_viewControllers;
}

@end

@implementation HSYBaseCustomSegmentedPageViewModel

- (instancetype)initWithSegmentedPageModel:(HSYBaseCustomSegmentedPageControllerModel *)segmentedPageModel
{
    if (self = [super init]) {
        self->_segmentedPageControllerModel = segmentedPageModel;
    }
    return self;
}

- (HSYBaseCustomSegmentedPageModel *)hsy_toSegmentedPageControlModel
{
    self.segmentedPageControllerModel.segmentedPageControlModel.adaptiveFormat = @(YES);
    return self.segmentedPageControllerModel.segmentedPageControlModel;
}

- (NSArray<UIViewController *> *)viewControllers:(id<UIViewControllerRuntimeDelegate>)delegate
{
    if (!_viewControllers) {
        _viewControllers = [self.segmentedPageControllerModel hsy_toViewControllers:delegate];
    }
    return _viewControllers;
}

@end
