
//
//  HSYTabbarViewController.m
//  HSYUIToolsKit_Example
//
//  Created by anmin on 2019/12/24.
//  Copyright © 2019 317398895@qq.com. All rights reserved.
//

#import "HSYTabbarViewController.h"
#import <HSYMethodsToolsKit/UIButton+UIKit.h>

@interface HSYTabbarViewController ()

@end

@implementation HSYTabbarViewController

- (instancetype)init
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    UIColor *normalColor = UIColor.blackColor;
    UIColor *selectedColor = UIColor.greenColor;
    UIFont *font = [UIFont systemFontOfSize:12];
    NSArray *dictionarys = @[@{@"itemNormalTitle" : @"home", @"itemNormalIcon" : @"explore_icon_def", @"itemNormalTextColor" : normalColor, @"itemNormalFont" : font, @"itemSelectedTitle" : @"home", @"itemSelectedIcon" : @"explore_icon_sel", @"itemSelectedTextColor" : selectedColor, @"itemSelectedFont" : font, @"itemId" : @(0), @"redPointsFont" : [UIFont systemFontOfSize:9], @"viewControllerName" : @"AViewController", @"selected" : @(YES), @"redPoints" : @(kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally), },
  @{@"itemNormalIcon" : @"home_icon_def", @"itemNormalTextColor" : normalColor, @"itemNormalFont" : font, @"itemSelectedIcon" : @"home_icon_sel", @"itemSelectedTextColor" : selectedColor, @"itemSelectedFont" : font, @"itemId" : @(1), @"redPointsFont" : [UIFont systemFontOfSize:9], @"viewControllerName" : @"BViewController", @"selected" : @(YES), @"redPoints" : @(1000), @"itemNormalTitle" : @"pay", @"itemSelectedTitle" : @"pay", },//@"itemNormalTitle" : @"pay", @"itemSelectedTitle" : @"pay", 
  @{@"itemNormalTitle" : @"im", @"itemNormalIcon" : @"im_icon_def", @"itemNormalTextColor" : normalColor, @"itemNormalFont" : font, @"itemSelectedTitle" : @"im", @"itemSelectedIcon" : @"im_icon_sel", @"itemSelectedTextColor" : selectedColor, @"itemSelectedFont" : font, @"itemId" : @(2), @"redPointsFont" : [UIFont systemFontOfSize:9], @"viewControllerName" : @"CViewController", @"selected" : @(YES), @"redPoints" : @(23), }];
    for (NSDictionary *dictionary in dictionarys) {
        HSYBaseTabBarItemConfig *config = [[HSYBaseTabBarItemConfig alloc] init];
        for (NSString *forKey in dictionary.allKeys) {
            if ([config respondsToSelector:NSSelectorFromString(forKey)]) {
                [config setValue:dictionary[forKey] forKey:forKey];
            }
        }
        [array addObject:config];
    }
    if (self = [super initWithConfigs:array]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.mainScrollEnabled = YES;
    // Do any additional setup after loading the view.
}


@end

@interface AViewController : UIViewController

@end

@implementation AViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    UIButton *button = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull button) {
        NSLog(@"AViewController=>%@", @"控制器A");
    }];
    button.frame = self.view.bounds;
    [self.view addSubview:button];
}

@end

@interface BViewController : UIViewController

@end

@implementation BViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    UIButton *button = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull button) {
        NSLog(@"BViewController=>%@", @"控制器B");
    }];
    button.frame = self.view.bounds;
    [self.view addSubview:button];
}

@end

@interface CViewController : UIViewController

@end

@implementation CViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    UIButton *button = [UIButton hsy_buttonWithAction:^(UIButton * _Nonnull button) {
        NSLog(@"CViewController=>%@", @"控制器C");
    }];
    button.frame = self.view.bounds;
    [self.view addSubview:button];
}

@end
