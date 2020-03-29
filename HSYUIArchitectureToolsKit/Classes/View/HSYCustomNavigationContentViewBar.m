//
//  HSYCustomNavigationContentViewBar.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/21.
//

#import "HSYCustomNavigationContentViewBar.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIApplication+AppDelegates.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMethodsToolsKit/UINavigationBar+NavigationItem.h>
#import <HSYMethodsToolsKit/UIImage+Canvas.h>
#import <HSYMethodsToolsKit/UINavigationBar+Background.h>

NSInteger const kHSYDefaultCustomBarButtonItemForKeyA   = 8888888;
NSInteger const kHSYDefaultCustomBarButtonItemForKeyB   = 9999999;

@implementation HSYCustomNavigationBar 

- (instancetype)init
{
    if (self = [super initWithSize:CGSizeMake(IPHONE_WIDTH, self.class.hsy_barHeights)]) {
        self.backItem.hidesBackButton = YES;
        _customNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        [self pushNavigationItem:self.customNavigationItem animated:YES];
    }
    return self;
}

+ (CGFloat)hsy_barHeights
{
    return ([UIApplication hsy_navigationBarHeights] - [UIApplication hsy_statusBarHeight]);
}

#pragma mark - NavigationBarButton

+ (UIBarButtonItem *)hsy_defaultBackBarButtonItem:(void (^)(UIButton *button, NSInteger tag))next
{
    return [self.class hsy_defaultImageBarButtonItem:@{@"nav_icon_back" : @"nav_icon_back"} clickedOnAction:next];
}
 
+ (UIBarButtonItem *)hsy_defaultImageBarButtonItem:(NSDictionary *)paramter clickedOnAction:(void (^)(UIButton *button, NSInteger tag))action
{
    return [UINavigationBar hsy_imageNavigationItems:@[@{@(kHSYDefaultCustomBarButtonItemForKeyA) : paramter}] leftEdgeInsets:WIDTHS_OF_SCALE(-UINavigationBar.hsy_defaultCustomNavigationBarButtonSizes/4*3) subscribeNext:action].firstObject;
}

+ (UIBarButtonItem *)hsy_defaultTitleBarButtonItem:(NSString *)title clickedOnAction:(void (^)(UIButton *button, NSInteger tag))action
{
    return [UINavigationBar hsy_titleNavigationItems:@[@{@{@(kHSYDefaultCustomBarButtonItemForKeyB) : HSY_SYSTEM_FONT_SIZE(15.0)} : @{title : HSY_HEX_COLOR(0x515151)}}] leftEdgeInsets:0.0f subscribeNext:action].firstObject;
}

+ (NSArray *)hsy_defaultWebLeftCustomButtonItem:(void (^)(UIButton *button, NSInteger tag))next
{
    return [self.class hsy_defaultImageLeftBarButtonItem:@[@{@"nav_icon_back" : @"nav_icon_back"},@{@"web_close_icon" : @"web_close_icon"}] clickedOnAction:next];
}

+ (NSArray *)hsy_defaultImageLeftBarButtonItem:(NSArray<NSDictionary *> *)paramterArr clickedOnAction:(void (^)(UIButton *button, NSInteger tag))action
{
    return [UINavigationBar hsy_imageNavigationItems:@[@{@(kHSYDefaultCustomBarButtonItemForKeyA) : paramterArr.firstObject},@{@(kHSYDefaultCustomBarButtonItemForKeyB) : paramterArr.lastObject}] leftEdgeInsets:WIDTHS_OF_SCALE(-UINavigationBar.hsy_defaultCustomNavigationBarButtonSizes/4*3) subscribeNext:action];
}

#pragma mark - Load

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([[UIDevice currentDevice].systemVersion intValue] >= 13) {
        return;
    }
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
            CGFloat margins = 15.0f;
            subview.layoutMargins = UIEdgeInsetsMake(0, margins, 0, margins);
            break;
        }
    }
}

@end

//***********************************************************************************************************************************************************************************************************************************************************************************************************************************

@interface HSYCustomNavigationContentViewBar ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation HSYCustomNavigationContentViewBar

- (instancetype)initWithDefault
{
    if (self = [super initWithSize:CGSizeMake(IPHONE_WIDTH, [UIApplication hsy_navigationBarHeights])]) {
        self.backgroundColor = UIColor.clearColor;
        self.backgroundImageView = [[UIImageView alloc] initWithSize:self.size];
        [self addSubview:self.backgroundImageView];
        
        _navigationBar = [[HSYCustomNavigationBar alloc] init];
        self.navigationBar.y = [UIApplication hsy_statusBarHeight];
        if (@available(iOS 11.0, *)) {
            self.navigationBar.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        [self addSubview:self.navigationBar];
        [self hsy_setCustomNavigationBarBackgroundImage:[UIImage hsy_imageWithFillColor:UIColor.whiteColor]];
        [self hsy_customBarBottomLineOfColor:HSY_RGB(51, 51, 51)];
    }
    return self;
}

#pragma mark - Style

- (void)hsy_setCustomNavigationBarBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.highlightedImage = backgroundImage;
    [self.navigationBar hsy_setNavigationBarBackgroundImage:[UIImage hsy_imageWithFillColor:UIColor.clearColor]];
}

- (void)hsy_clearNavigationBarBottomLine
{
    [self.navigationBar hsy_clearNavigationBarBottomline];
}

- (void)hsy_customBarBottomLineOfColor:(UIColor *)color
{
    [self.navigationBar hsy_setNavigationBarBottomlineColor:color];
}


@end
