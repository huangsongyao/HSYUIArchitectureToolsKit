//
//  HSYTestSegmenetedPageViewController.m
//  HSYUIToolsKit_Example
//
//  Created by anmin on 2019/12/27.
//  Copyright © 2019 317398895@qq.com. All rights reserved.
//

#import "HSYTestSegmenetedPageViewController.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import "HSYViewController.h"

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




@implementation HSYTestMainSegmenetedPageViewController

- (instancetype)init
{
    NSArray *jsons = @[@{@"image" : @"explore_icon_def", @"highImage" : @"explore_icon_sel", @"title" : @"one", @"selectedStatus" : @(YES), @"itemWidths" : @(55.0f), @"itemId" : @(0)},
                       @{@"image" : @"home_icon_def", @"highImage" : @"home_icon_sel", @"title" : @"two", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(1)},
                       @{@"image" : @"im_icon_def", @"highImage" : @"im_icon_sel", @"title" : @"third", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(2)},
                       @{@"image" : @"mine_icon_def", @"highImage" : @"mine_icon_sel", @"title" : @"four", @"selectedStatus" : @(NO), @"itemWidths" : @(55.0f), @"itemId" : @(3)},];
    HSYBaseCustomSegmentedPageModel *model = [[HSYBaseCustomSegmentedPageModel alloc] init];
    model.showControlBottomLine = @(NO);
    model.titleViewFormat = @(NO);
    model.adaptiveFormat = @(YES);
    for (NSDictionary *json in jsons) {
        HSYBaseCustomSegmentedPageControlModel *controlModel = (HSYBaseCustomSegmentedPageControlModel *)[HSYBaseCustomSegmentedPageControlModel hsy_kvcModelWithJSON:json];
        [model.controlModels addObject:controlModel];
    }
    HSYBaseCustomSegmentedPageControllerModel *segmentedPageModel = [[HSYBaseCustomSegmentedPageControllerModel alloc] init];
    segmentedPageModel.segmentedPageControlModel = model;
    segmentedPageModel.viewControllers = @[@{@"ViewController_1" : @{}}, @{@"ViewController_2" : @{}}, @{@"ViewController_3" : @{}}, @{@"ViewController_4" : @{}}, ];
    if (self = [super initWithMainSegmentedPageModel:segmentedPageModel]) {
    }
    return self;
}

- (void)viewDidLoad
{
    @weakify(self);
    self.returnMainTableHeaderBlock = ^UIView * _Nonnull(HSYBasePageScrollView * _Nonnull pageScrollView, HSYBaseMainSegmentedViewController * _Nonnull mainSegmentedViewController) {
        @strongify(self);
        UIView *view = [[UIView alloc] initWithSize:CGSizeMake(self.view.width, 300.0)];
        view.backgroundColor = UIColor.blackColor;
        return view;
    };
    [super viewDidLoad];
}

@end












@interface ViewController_1 : ListTestViewController <HSYBasePageTableDelegate>

@end

@implementation ViewController_1

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customNavigationContentViewBar.hidden = YES;
    self.tableView.frame = self.hsy_toListCGRect;
    self.hsy_view.hidden = YES;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = UIColor.redColor;
    self.lineHidden = NO;
}

- (UIScrollView *)hsy_listScrollView
{
    return self.tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kReuseIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"++++++++++++++");
}

@end

@interface ViewController_2 : ListTestViewController <HSYBasePageTableDelegate>

@end

@implementation ViewController_2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customNavigationContentViewBar.hidden = YES;
    self.tableView.frame = self.hsy_toListCGRect;
    self.hsy_view.hidden = YES;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = UIColor.grayColor;
}

- (UIScrollView *)hsy_listScrollView
{
    return self.tableView;
}

@end

@interface ViewController_3 : ListTestViewController <HSYBasePageTableDelegate>

@end

@implementation ViewController_3

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customNavigationContentViewBar.hidden = YES;
    self.tableView.frame = self.hsy_toListCGRect;
    self.hsy_view.hidden = YES;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = UIColor.greenColor;
    @weakify(self);
    [[self.hsy_layoutReset deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        self.view.height = 300;
    }];

}

- (UIScrollView *)hsy_listScrollView
{
    return self.tableView;
}

@end

@interface ViewController_4 : ListTestViewController <HSYBasePageTableDelegate>

@end

@implementation ViewController_4

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customNavigationContentViewBar.hidden = YES;
    self.tableView.frame = self.hsy_toListCGRect;
    self.hsy_view.hidden = YES;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = UIColor.blueColor;
}

- (UIScrollView *)hsy_listScrollView
{
    return self.tableView;
}


@end

