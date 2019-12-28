//
//  HSYBaseTabBarItemCell.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/24.
//

#import "HSYBaseTabBarItemCell.h"
#import "HSYBaseTabBarViewModel.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <Masonry/Masonry.h>

static CGFloat const kHSYBaseTabBarItemIconImageSize             = 22.0f;
static CGFloat const kHSYBaseTabBarItemIconImageOffsetTops        = 6.0f;
static CGFloat const kHSYBaseTabBarItemIconImageOffsetBottoms        = 1.0f;
static CGFloat const kHSYBaseTabBarItemTitleOffsetLefts     = 2.0f;
static CGFloat const kHSYBaseTabBarItemTitleOffsetBottomsByiPhone_6_plus       = 4.0;
static CGFloat const kHSYBaseTabBarItemTitleOffsetBottomsByiPhoneX          = 35.0;

@interface HSYBaseTabBarItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *redPointsLabel;

@end

@implementation HSYBaseTabBarItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //title
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.x = self.class.hsy_titleOffsetLefts;
        self.titleLabel.width = (self.width - (self.class.hsy_titleOffsetLefts * 2.0f));
        [self.contentView addSubview:self.titleLabel];
        //icon
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        //红点
        self.redPointsLabel = [[UILabel alloc] init];
        self.redPointsLabel.hidden = YES;
        self.redPointsLabel.textColor = UIColor.whiteColor;
        self.redPointsLabel.clipsToBounds = YES;
        self.redPointsLabel.textAlignment = NSTextAlignmentCenter;
        self.redPointsLabel.layer.masksToBounds = YES;
        self.redPointsLabel.backgroundColor = UIColor.redColor;
        [self.contentView addSubview:self.redPointsLabel];
    }
    return self;
}

#pragma mark - Static Methods

+ (CGSize)hsy_iconCGSize
{
    return CGSizeMake(kHSYBaseTabBarItemIconImageSize, kHSYBaseTabBarItemIconImageSize);
}

+ (CGFloat)hsy_iconOffsetTops
{
    return kHSYBaseTabBarItemIconImageOffsetTops;
}

+ (CGFloat)hsy_iconOffsetBottoms
{
    return kHSYBaseTabBarItemIconImageOffsetBottoms;
}

+ (CGFloat)hsy_titleOffsetLefts
{
    return kHSYBaseTabBarItemTitleOffsetLefts;
}

+ (CGFloat)hsy_titleOffsetBottoms
{
    return (HSY_IS_iPhoneX ? kHSYBaseTabBarItemTitleOffsetBottomsByiPhoneX : kHSYBaseTabBarItemTitleOffsetBottomsByiPhone_6_plus);
}

#pragma mark - Setter

- (void)hsy_setTabbarItemConfig:(HSYBaseTabBarItemConfig *)tabBarItemConfig
{
    _tabBarItemConfig = tabBarItemConfig;
    
    self.titleLabel.text = tabBarItemConfig.hsy_itemTitleString;
    self.titleLabel.font = tabBarItemConfig.hsy_itemTitleFont;
    self.titleLabel.textColor = tabBarItemConfig.hsy_itemTextColor;
    self.titleLabel.height = self.titleLabel.font.lineHeight;
    self.titleLabel.y = (self.height - self.titleLabel.height - self.class.hsy_titleOffsetBottoms); 
    self.titleLabel.hidden = !(self.titleLabel.text.length > 0);
    
    self.iconImageView.image = tabBarItemConfig.hsy_itemIconImage;
    self.iconImageView.highlightedImage = tabBarItemConfig.hsy_itemIconImage;
    self.iconImageView.size = (tabBarItemConfig.userIconOriginalSize.boolValue ? self.iconImageView.image.size : self.class.hsy_iconCGSize);
    self.iconImageView.origin = CGPointMake((self.width - self.iconImageView.width)/2.0f, (self.titleLabel.y - self.class.hsy_iconOffsetBottoms - self.iconImageView.height));
    
    self.redPointsLabel.hidden = !tabBarItemConfig.hsy_showRedPoints;
    if (!self.redPointsLabel.hidden) {
        self.redPointsLabel.size = tabBarItemConfig.hsy_redPointsCGSize;
        self.redPointsLabel.origin = CGPointMake((self.iconImageView.right - self.redPointsLabel.width / 2.0f), self.iconImageView.y);
        self.redPointsLabel.layer.cornerRadius = self.redPointsLabel.height / 2.0f;
        self.redPointsLabel.text = tabBarItemConfig.hsy_redPointsString;
        self.redPointsLabel.font = tabBarItemConfig.redPointsFont;
    }
}

@end
