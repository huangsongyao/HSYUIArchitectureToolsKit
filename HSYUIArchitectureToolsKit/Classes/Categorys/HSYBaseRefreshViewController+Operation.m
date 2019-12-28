//
//  HSYBaseRefreshViewController+Operation.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/18.
//

#import "HSYBaseRefreshViewController+Operation.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMethodsToolsKit/NSObject+Property.h>
#import <HSYMethodsToolsKit/UIViewController+Load.h>
#import "NSObject+Runtime.h"

static NSString *kHSYUIToolsRefreshBlockPropertyForDeselectKey = @"HSYUIToolsRefreshBlockPropertyForDeselectKey";
static NSString *kHSYUIToolsRefreshBlockPropertyForViewDidLoadKey = @"HSYUIToolsRefreshBlockPropertyForViewDidLoadKey";

@implementation HSYBaseRefreshViewController (Operation)

#pragma mark - Runtime

- (HSYBaseRefreshDeselectRowBlock)hsy_deselectRowBlock
{
    return [self hsy_getPropertyForKey:kHSYUIToolsRefreshBlockPropertyForDeselectKey];
}

- (void)setHsy_deselectRowBlock:(HSYBaseRefreshDeselectRowBlock)hsy_deselectRowBlock
{
    [self hsy_setProperty:hsy_deselectRowBlock forKey:kHSYUIToolsRefreshBlockPropertyForDeselectKey objcAssociationPolicy:kHSYMethodsToolsKitObjcAssociationPolicyNonatomicCopy];
}

- (HSYBaseRefreshViewDidLoadCompleted)hsy_viewDidLoadCompletedBlock
{
    HSYBaseRefreshViewDidLoadCompleted completed = [self hsy_getPropertyForKey:kHSYUIToolsRefreshBlockPropertyForViewDidLoadKey];
    return completed;
}

- (void)setHsy_viewDidLoadCompletedBlock:(HSYBaseRefreshViewDidLoadCompleted)hsy_viewDidLoadCompletedBlock
{
    [self hsy_setProperty:hsy_viewDidLoadCompletedBlock forKey:kHSYUIToolsRefreshBlockPropertyForViewDidLoadKey objcAssociationPolicy:kHSYMethodsToolsKitObjcAssociationPolicyNonatomicCopy];
}

#pragma mark - Load

+ (void)load
{
    [super load];
    hsy_methodsMonitorInstance(self.class, @selector(viewDidLoad), @selector(hsy_viewDidLoad));
}

- (void)hsy_viewDidLoad
{
    [self hsy_viewDidLoad];
    if (self.hsy_viewDidLoadCompletedBlock) {
        @weakify(self);
        [[RACScheduler mainThreadScheduler] schedule:^{
            @strongify(self);
            self.hsy_viewDidLoadCompletedBlock(self.viewModel, self);
        }];
    }
}

#pragma mark - Methods

- (CGRect)hsy_toListCGRect
{
    CGRect rect = CGRectMake(0.0f, self.customNavigationContentViewBar.bottom, self.view.width, (IPHONE_HEIGHT - self.customNavigationContentViewBar.bottom));
    //如果默认的导航栏不隐藏，则不显示定制的导航栏
    if (self.navigationController.navigationBar) {
        self.customNavigationContentViewBar.hidden = YES;
    }
    //如果定制的导航栏隐藏，则表示list列表的frame应该从self.view的bounds
    if (self.customNavigationContentViewBar.hidden) {
        rect = self.view.bounds;
    }
    return rect;
}

@end
