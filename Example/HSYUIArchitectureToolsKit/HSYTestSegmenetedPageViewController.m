//
//  HSYTestSegmenetedPageViewController.m
//  HSYUIToolsKit_Example
//
//  Created by anmin on 2019/12/27.
//  Copyright © 2019 317398895@qq.com. All rights reserved.
//

#import "HSYTestSegmenetedPageViewController.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>

@implementation HSYTestSegmenetedPageViewController

- (instancetype)init
{
    NSArray *jsons = @[@{@"image" : @"explore_icon_def", @"highImage" : @"explore_icon_sel", @"title" : @"one", @"selectedStatus" : @(YES), @"itemWidths" : @(55.0f), @"itemId" : @(0)},
                       @{@"image" : @"home_icon_def", @"highImage" : @"home_icon_sel", @"title" : @"two", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(1)},
                       @{@"image" : @"im_icon_def", @"highImage" : @"im_icon_sel", @"title" : @"third", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(2)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"four", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(3)},];
    HSYBaseCustomSegmentedPageModel *model = [[HSYBaseCustomSegmentedPageModel alloc] init];
    model.showControlBottomLine = @(NO);
    model.adaptiveFormat = @(YES);
    for (NSDictionary *json in jsons) {
        HSYBaseCustomSegmentedPageControlModel *controlModel = (HSYBaseCustomSegmentedPageControlModel *)[HSYBaseCustomSegmentedPageControlModel hsy_kvcModelWithJSON:json];
        [model.controlModels addObject:controlModel];
    }
    HSYBaseCustomSegmentedPageControllerModel *segmentedPageModel = [[HSYBaseCustomSegmentedPageControllerModel alloc] init];
    segmentedPageModel.segmentedPageControlModel = model;
    segmentedPageModel.viewControllers = @[@{@"ViewController_1" : @{}}, @{@"ViewController_2" : @{}}, @{@"ViewController_3" : @{}}, @{@"ViewController_4" : @{}}, ];
    if (self = [super initWithSegmentedPageModel:segmentedPageModel]) {
    }
    return self; 
}


@end


@interface ViewController_1 : UIViewController

@end

@implementation ViewController_1

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
}

@end

@interface ViewController_2 : UIViewController

@end

@implementation ViewController_2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
}

@end

@interface ViewController_3 : UIViewController

@end

@implementation ViewController_3

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    @weakify(self);
    [[self.hsy_layoutReset deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        self.view.height = 300;
    }];

}

@end

@interface ViewController_4 : UIViewController

@end

@implementation ViewController_4

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
}


@end

