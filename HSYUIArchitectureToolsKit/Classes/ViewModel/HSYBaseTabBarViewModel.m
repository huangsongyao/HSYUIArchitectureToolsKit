//
//  HSYBaseTabBarViewModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/23.
//

#import "HSYBaseTabBarViewModel.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/NSBundle+PrivateFileResource.h>
#import <HSYMethodsToolsKit/NSObject+Property.h>
#import <HSYMethodsToolsKit/NSString+StringSize.h>

//*********************************************************************************************************************************************************************************************************************************************************************************************************

static NSString *kHSYBaseTabBarPrivatedItemIdForKey = @"HSYBaseTabBarPrivatedItemIdForKey";

@interface UIViewController (PrivatedItemId)

@property (nonatomic, strong) NSNumber *thisItemId;
+ (UIViewController *)hsy_tabBarItemViewController:(NSString *)className withItemId:(NSNumber *)itemId;

@end

@implementation UIViewController (PrivatedItemId)

- (NSNumber *)thisItemId
{
    return [self hsy_getPropertyForKey:kHSYBaseTabBarPrivatedItemIdForKey];
}

- (void)setThisItemId:(NSNumber *)thisItemId
{
    [self hsy_setProperty:thisItemId
                   forKey:kHSYBaseTabBarPrivatedItemIdForKey
    objcAssociationPolicy:kHSYMethodsToolsKitObjcAssociationPolicyNonatomicStrong];
}

+ (UIViewController *)hsy_tabBarItemViewController:(NSString *)className withItemId:(NSNumber *)itemId
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    viewController.thisItemId = itemId;
    return viewController;
}

@end

//*********************************************************************************************************************************************************************************************************************************************************************************************************

NSInteger const kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally = -20181212;
NSInteger const kHSYBaseTabBarItemConfigDefaultRedPointsStatusSizes = 5.0f;

@implementation HSYBaseTabBarItemConfig

- (UIImage *)hsy_itemIconImage
{
    if (self.selected.boolValue) {
        return self.hsy_selectedIconImage;
    }
    return self.hsy_normalIconImage;
}

- (UIImage *)hsy_normalIconImage
{
    return [NSBundle hsy_imageForBundle:self.itemNormalIcon];
}

- (UIImage *)hsy_selectedIconImage
{
    return [NSBundle hsy_imageForBundle:self.itemSelectedIcon];
}

- (UIFont *)hsy_itemTitleFont
{
    if (self.selected.boolValue) {
        return self.itemSelectedFont;
    }
    return self.itemNormalFont;
}

- (UIColor *)hsy_itemTextColor
{
    if (self.selected.boolValue) {
        return self.itemSelectedTextColor;
    }
    return self.itemNormalTextColor;
}

- (NSString *)hsy_itemTitleString
{
    if (self.selected.boolValue) {
        return self.itemSelectedTitle;
    }
    return self.itemNormalTitle;
}

- (NSString *)hsy_redPointsString
{
    NSString *redPointsString = [NSString stringWithFormat:@"%@", self.redPoints];
    if (self.redPoints.integerValue > 99) {
        redPointsString = @"+99";
    } else if (self.redPoints.integerValue == kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally) {
        redPointsString = @"";
    }
    return redPointsString;
}

- (CGSize)hsy_redPointsCGSize
{
    if (self.redPoints.integerValue == kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally) {
        CGFloat redPointsSize = kHSYBaseTabBarItemConfigDefaultRedPointsStatusSizes;
        if (self.redPointsSize.doubleValue > 0.0f) {
            redPointsSize = ceil(self.redPointsSize.doubleValue);
        }
        return CGSizeMake(redPointsSize, redPointsSize);
    }
    CGSize size = [self.hsy_redPointsString hsy_boundingRectWithHeights:self.redPointsFont.lineHeight
                                                                   font:self.redPointsFont];
    return CGSizeMake(ceil(size.width + 4.0f), ceil(self.redPointsFont.lineHeight));
}

- (BOOL)hsy_showRedPoints
{
    if (self.redPoints.integerValue == kHSYBaseTabBarItemConfigDefaultRedPointsStatusTally || self.redPoints.integerValue > 0) {
        return YES;
    }
    return NO;
}

@end

//*********************************************************************************************************************************************************************************************************************************************************************************************************

@interface HSYBaseTabBarViewModel () {
    @private NSArray<UIViewController *> *_viewControllers;
}
@end

@implementation HSYBaseTabBarViewModel

- (instancetype)initWithConfigs:(NSArray<HSYBaseTabBarItemConfig *> *)configs
{
    if (self = [super init]) {
        self->_tabBarConfigs = configs;
    }
    return self;
}

#pragma mark - Getter

- (CGSize)itemSize
{
    CGSize size = CGSizeMake(IPHONE_WIDTH/self.tabBarConfigs.count, self.class.hsy_tabBarHeights); 
    return size;
}

- (NSArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        NSMutableArray<UIViewController *> *viewControllers = [[NSMutableArray alloc] init];
        for (HSYBaseTabBarItemConfig *config in self.tabBarConfigs) {
            UIViewController *viewController = [UIViewController hsy_tabBarItemViewController:config.viewControllerName withItemId:config.itemId];
            if (config.viewControllerKVC.allKeys.count) {
                for (NSString *forKey in config.viewControllerKVC.allKeys) {
                    if ([viewController respondsToSelector:NSSelectorFromString(forKey)]) {
                        [viewController setValue:config.viewControllerKVC[forKey] forKey:forKey];
                    }
                }
            }
            [viewControllers addObject:viewController];
        }
        _viewControllers = viewControllers.mutableCopy;
    }
    return _viewControllers;
}

- (NSInteger)hsy_currentSelectedIndex
{
    for (HSYBaseTabBarItemConfig *config in self.tabBarConfigs) {
        if (config.selected.boolValue) {
            return [self.tabBarConfigs indexOfObject:config];
        }
    }
    return 0;
}

#pragma mark - Methods

+ (CGFloat)hsy_tabBarHeights
{
    return (HSY_IS_iPhoneX ? 83.0f : 49.0f);
}

- (HSYBaseTabBarItemConfig *)hsy_getTabBarItemConfig:(NSNumber *)itemId
{
    for (HSYBaseTabBarItemConfig *config in self.tabBarConfigs) {
        if (config.itemId.integerValue == itemId.integerValue) {
            return config;
        }
    }
    return nil;
}

- (UIViewController *)hsy_getTabBarSubViewController:(NSNumber *)itemId
{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController.thisItemId isEqualToNumber:itemId]) {
            return viewController;
        }
    }
    return nil;
}

- (void)hsy_setSelectedItemStatus:(NSInteger)itemId
{
    for (HSYBaseTabBarItemConfig *config in self.tabBarConfigs) {
        config.selected = @((config.itemId.integerValue == itemId));
    }
}

@end
