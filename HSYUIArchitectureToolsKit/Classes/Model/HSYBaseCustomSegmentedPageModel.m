//
//  HSYBaseCustomSegmentedPageModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import "HSYBaseCustomSegmentedPageModel.h"
#import <HSYMethodsToolsKit/UIButton+UIKit.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>
#import <HSYMethodsToolsKit/NSBundle+PrivateFileResource.h>
#import <HSYMethodsToolsKit/UIImageView+UrlString.h>

@implementation HSYBaseCustomSegmentedPageControlModel

- (NSString *)hsy_controlItemImage
{
    if (self.selectedStatus.boolValue) {
        return self.highImage;
    }
    return self.image;
}

- (UIFont *)hsy_controlItemFont
{
    UIFont *font = self.normalFont;
    if (self.selectedStatus.boolValue) {
        font = self.selectedFont;
    }
    if (!font) {
        font = HSY_SYSTEM_FONT_SIZE(15.0);
    }
    return font;
}

- (UIColor *)hsy_controlTextColor
{
    UIColor *color = self.normalTextColor;
    if (self.selectedStatus.boolValue) {
        color = self.selectedTextColor;
    }
    if (!color) {
        color = HSY_RGB(51, 51, 51);
    }
    return color;
}

@end

//********************************************************************************************************************************************************************************************************************************************************

static CGFloat const kHSYBaseCustomSegmentedPageControlBottomLineHeights = 1.0f;
static CGFloat const kHSYBaseCustomSegmentedPageControlSelectedLineDefaultWidths = 35.0f;
static CGFloat const kHSYBaseCustomSegmentedPageControlSelectedLineDefaultHeights = 2.0f;

@interface HSYBaseCustomSegmentedPageModel () {
    @private NSArray<HSYBaseCustomSegmentedPageControlItem *> *_segmentedPageControlItems;
}

@end

@implementation HSYBaseCustomSegmentedPageModel

- (NSMutableArray<HSYBaseCustomSegmentedPageControlModel *> *)controlModels
{
    if (!_controlModels) {
        _controlModels = [[NSMutableArray alloc] init];
    }
    return _controlModels;
}

- (NSInteger)hsy_itemSelectedIndex
{
    for (HSYBaseCustomSegmentedPageControlModel *controlModel in self.controlModels) {
        if (controlModel.selectedStatus.boolValue) {
            return [self.controlModels indexOfObject:controlModel];
        }
    }
    return 0;
}

- (BOOL)hsy_showSelecteLine
{
    if (self.showControlLine) {
        return self.showControlLine.boolValue;
    }
    return YES;
}

- (BOOL)hsy_showControlBottomLine
{
    if (self.showControlBottomLine) {
        return self.showControlBottomLine.boolValue;
    }
    return YES;
}

- (RACSignal *)hsy_resetControlModelsUnselectedStatus:(NSInteger)index
{
    @weakify(self);
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        HSYBaseCustomSegmentedPageControlItem *thisControlItem = nil;
        for (HSYBaseCustomSegmentedPageControlItem *item in self->_segmentedPageControlItems) {
            [item hsy_resetUnselectedSegmentedPageControlModel];
            if (item.controlModel.itemId.integerValue == index) {
                thisControlItem = item;
            }
        }
        [RACSignal hsy_performSendSignal:subscriber forObject:thisControlItem];
    }];
}

- (CGSize)hsy_selectedLineCGSize:(CGFloat)contentWidths
{
    CGSize size = self.controlLineThickness.CGSizeValue;
    size = CGSizeMake(MIN((contentWidths / self.controlModels.count), size.width), size.height);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(kHSYBaseCustomSegmentedPageControlSelectedLineDefaultWidths, kHSYBaseCustomSegmentedPageControlSelectedLineDefaultHeights);
    }
    return size;
}

- (NSArray<HSYBaseCustomSegmentedPageControlItem *> *)hsy_toSegmentedPageControlItems:(HSYBaseCustomSegmentedPageControlItemActionBlock)action
{
    if (!_segmentedPageControlItems) {
        NSMutableArray<HSYBaseCustomSegmentedPageControlItem *> *segmentedPageControlItems = [[NSMutableArray alloc] init];
        for (HSYBaseCustomSegmentedPageControlModel *controlModel in self.controlModels) {
            HSYBaseCustomSegmentedPageControlItem *item = [HSYBaseCustomSegmentedPageControlItem initWithControlModel:controlModel withAction:action];
            [segmentedPageControlItems addObject:item];
        }
        _segmentedPageControlItems = segmentedPageControlItems.mutableCopy;
    }
    return _segmentedPageControlItems;
}

- (CGFloat)hsy_toBottomLineHeights
{
    if (self.controlBottomLineThickness.doubleValue > 0.0f) {
        return self.controlBottomLineThickness.doubleValue;
    }
    return kHSYBaseCustomSegmentedPageControlBottomLineHeights;
}

- (BOOL)hsy_scrollEnabled
{
    if (self.scrollEnabledStatus) {
        return self.scrollEnabledStatus.boolValue;
    }
    return YES;
}

- (void)hsy_setControlItemBackgroundImage:(UIImageView *)backgroundImageView
{
    if (![self.controlBackgroundImage hasPrefix:@"http"]) {
        if (self.controlBackgroundImage.length) {
            UIImage *image = [NSBundle hsy_imageForBundle:self.controlBackgroundImage];
            backgroundImageView.image = image;
            backgroundImageView.highlightedImage = image;
        }
    } else {
        [backgroundImageView hsy_setImageWithUrlString:self.controlBackgroundImage
                                      placeholderImage:[NSBundle hsy_imageForBundle:self.controlBackgroundPlaceholderImage]];
    }
}

- (UIColor *)hsy_toControlSelectedLineColor
{
    if (!self.controlLineColor) {
        return HSY_RGB(51, 51, 51);
    }
    return self.controlLineColor;
}

- (UIColor *)hsy_toControlBottomLineColor
{
    if (!self.controlBottomLineColor) {
        return HSY_HEX_COLOR(0x999999);
    }
    return self.controlBottomLineColor;
}

- (CGFloat)hsy_toControlWidths
{
    if (self.controlWidths) {
        return self.controlWidths.doubleValue;
    }
    return IPHONE_WIDTH;
}

- (CGFloat)hsy_toControlLineOffsetBottoms
{
    if (!self.controlLineOffsetBottoms) {
        return 0.0f;
    }
    return self.controlLineOffsetBottoms.doubleValue;
}

@end

//********************************************************************************************************************************************************************************************************************************************************

@implementation HSYBaseCustomSegmentedPageControllerModel

- (NSArray<UIViewController *> *)hsy_toViewControllers:(id<UIViewControllerRuntimeDelegate>)delegate
{
    NSMutableArray<UIViewController *> *viewControllers = [[NSMutableArray alloc] init];
    for (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *dictionary in self.viewControllers) {
        Class viewControllerClass = NSClassFromString(dictionary.allKeys.firstObject);
        UIViewController *viewController = [[viewControllerClass alloc] init];
        viewController.hsy_runtimeDelegate = delegate;
        NSDictionary *value = dictionary.allValues.firstObject;
        for (NSString *forKey in value.allKeys) {
            if ([viewController respondsToSelector:NSSelectorFromString(forKey)]) {
                [viewController setValue:value[forKey] forKey:forKey];
            }
        }
        [viewControllers addObject:viewController];
    }
    return viewControllers;
} 

@end
