//
//  HSYBaseCustomSegmentedPageControlItem.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseCustomSegmentedPageControlItem.h"
#import <HSYMethodsToolsKit/UIButton+UIKit.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/NSBundle+PrivateFileResource.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "HSYBaseCustomSegmentedPageModel.h"

@interface HSYBaseCustomSegmentedPageControlItem ()

- (void)hsy_setSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel;

@end

@implementation HSYBaseCustomSegmentedPageControlItem

+ (instancetype)hsy_itemButtonWithAction:(void (^)(HSYBaseCustomSegmentedPageControlItem * _Nonnull button))action
{
    HSYBaseCustomSegmentedPageControlItem *button = [HSYBaseCustomSegmentedPageControlItem buttonWithType:UIButtonTypeCustom];
    [[[button rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:action];
    return button;
}

+ (instancetype)initWithControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel
                          withAction:(HSYBaseCustomSegmentedPageControlItemActionBlock)action
{
    HSYBaseCustomSegmentedPageControlItem *controlItem = [HSYBaseCustomSegmentedPageControlItem hsy_itemButtonWithAction:^(HSYBaseCustomSegmentedPageControlItem * _Nonnull button) {
        if (action) {
            [[action(button, button.controlModel) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
                HSYBaseCustomSegmentedPageControlModel *xForModel = x.first;
                xForModel.selectedStatus = @(YES);
                HSYBaseCustomSegmentedPageControlItem *xForControlItem = x.second;
                [xForControlItem hsy_setSegmentedPageControlModel:xForModel];
            }];
        }
    }];
    controlItem.width = controlModel.itemWidths.doubleValue;
    [controlItem hsy_setSegmentedPageControlModel:controlModel];
    return controlItem;
}

- (void)hsy_resetUnselectedSegmentedPageControlModel
{
    self.controlModel.selectedStatus = @(NO);
    [self hsy_setSegmentedPageControlModel:self.controlModel];
}

- (void)hsy_resetSelectedSegmentedPageControlModel
{
    self.controlModel.selectedStatus = @(YES);
    [self hsy_setSegmentedPageControlModel:self.controlModel];
}

- (void)hsy_setSegmentedPageControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel
{
    self->_controlModel = controlModel;
    NSString *urlString = controlModel.hsy_controlItemImage; 
    if ([urlString hasPrefix:@"http"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                        forState:UIControlStateNormal
                placeholderImage:[NSBundle hsy_imageForBundle:controlModel.placeholderImage]];
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                        forState:UIControlStateHighlighted
                placeholderImage:[NSBundle hsy_imageForBundle:urlString]];
    } else {
        if (urlString.length) {
            [self hsy_setImage:[NSBundle hsy_imageForBundle:urlString]];
        }
    }
    [self hsy_setTitle:controlModel.title];
    [self hsy_setTitleColor:controlModel.hsy_controlTextColor];
    self.titleLabel.font = controlModel.hsy_controlItemFont;
    if (controlModel.title.length && urlString.length) {
        [self hsy_setImagePosition:kHSYMethodsToolsButtonImagePositionTop forSpacing:self.class.hsy_defaultSpacing];
    }
}

+ (CGFloat)hsy_defaultSpacing
{
    return 2.5f;
}

@end
