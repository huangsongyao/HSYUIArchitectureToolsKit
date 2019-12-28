//
//  HSYViewController.m
//  HSYUIArchitectureToolsKit
//
//  Created by 317398895@qq.com on 12/28/2019.
//  Copyright (c) 2019 317398895@qq.com. All rights reserved.
//

#import "HSYViewController.h"
#import "HSYBaseViewModel.h" 
#import <HSYMethodsToolsKit/UIButton+UIKit.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import "HSYBaseTableViewController.h"
#import "HSYBaseCollectionViewController.h"
#import "HSYTabbarViewController.h" 
#import "HSYBaseCustomSegmentedPageControl.h"
#import "HSYTestSegmenetedPageViewController.h"

@interface ListTestViewController : HSYBaseTableViewController

@end

@implementation ListTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"000000000000000000");
}

@end

@interface CollectTestViewController : HSYBaseCollectionViewController
@end

@implementation CollectTestViewController
@end


@interface HSYViewController ()

@end

@implementation HSYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    HSYBaseViewModel *vm = [[HSYBaseViewModel alloc] init];
    vm.active = YES;
    [vm.didBecomeActiveSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"didBecomeActiveSignal -> : %@", x);
    }];
    [vm.didBecomeInactiveSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"didBecomeInactiveSignal -> : %@", x);
    }];
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:3.0 schedule:^{
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    [[vm forwardSignalWhileActive:signal1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"forwardSignalWhileActive: -> : %@", x);
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:6.0 schedule:^{
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    [[vm throttleSignalWhileInactive:signal2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"throttleSignalWhileInactive: -> : %@", x);
    }];
    
    @weakify(self);
    UIButton *button = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull button) {
        @strongify(self);
        //        CollectTestViewController *vc = [[CollectTestViewController alloc] init];
        //        vc.viewModel = [[HSYBaseRefreshViewModel alloc] init];
        //        vc.hsy_viewDidLoadCompletedBlock = ^(HSYBaseRefreshViewModel * _Nullable viewModel, HSYBaseViewController * _Nullable viewController) {
        //           viewController.loading = NO;
        //        };
        //        vc.hsy_realNavigationBarItem.title = @"test";
        //        vc.addAllRefresh = YES;
        //        [self.navigationController pushViewController:vc animated:YES];
        
        //        HSYTabbarViewController *vc = [[HSYTabbarViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
        
//        HSYTestSegmenetedPageViewController *vc = [[HSYTestSegmenetedPageViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }];
    button.frame = self.view.bounds;
    [self.view addSubview:button];
    
    //    HSYBaseCustomSegmentedPageControlModel
    NSArray *jsons = @[@{@"image" : @"explore_icon_def", @"highImage" : @"explore_icon_sel", @"title" : @"one", @"selectedStatus" : @(YES), @"itemWidths" : @(55.0f), @"itemId" : @(0)},
                       @{@"image" : @"home_icon_def", @"highImage" : @"home_icon_sel", @"title" : @"two", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(1)},
                       @{@"image" : @"im_icon_def", @"highImage" : @"im_icon_sel", @"title" : @"third", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(2)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"four", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(3)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"five", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(4)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"six", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(5)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"seven", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(6)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"eight", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(7)}, ];
    HSYBaseCustomSegmentedPageModel *model = [[HSYBaseCustomSegmentedPageModel alloc] init];
    model.adaptiveFormat = @(YES);
    for (NSDictionary *json in jsons) {
        HSYBaseCustomSegmentedPageControlModel *controlModel = (HSYBaseCustomSegmentedPageControlModel *)[HSYBaseCustomSegmentedPageControlModel hsy_kvcModelWithJSON:json];
        [model.controlModels addObject:controlModel];
    }
    HSYBaseCustomSegmentedPageControl *control = [[HSYBaseCustomSegmentedPageControl alloc] initWithSegmentedPageModel:model];
    control.origin = CGPointMake(100, 300);
    [self.view addSubview:control];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
