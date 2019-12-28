//
//  HSYBaseTabBarItemCell.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HSYBaseTabBarItemConfig;
@interface HSYBaseTabBarItemCell : UICollectionViewCell

//伪tabBar的item的数据源
@property (nonatomic, strong, setter=hsy_setTabbarItemConfig:) HSYBaseTabBarItemConfig *tabBarItemConfig;

/**
 item中的icon的size

 @return item中的icon的size
 */
+ (CGSize)hsy_iconCGSize;

/**
 item中的icon的上边距

 @return item中的icon的上边距
 */
+ (CGFloat)hsy_iconOffsetTops;

/**
 item中的icon的下边距

 @return item中的icon的下边距
 */
+ (CGFloat)hsy_iconOffsetBottoms;

/**
 item中的title的左右两侧的边距

 @return item中的title的左右两侧的边距
 */
+ (CGFloat)hsy_titleOffsetLefts;

@end

NS_ASSUME_NONNULL_END
