//
//  UIImage+MixColors.h
//  HSYMethodsToolsKit
//
//  Created by huangsongyao on 2020/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MixColors)

/// 绘制多重混合颜色的图片，方向为45度角
/// @param colors 颜色集合
/// @param size 图片的size
+ (UIImage *)hsy_imageWithMixColors:(NSArray *)colors size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
