//
//  UIView+GradientColor.h
//  HSYMethodsToolsKit
//
//  Created by huangsongyao on 2020/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HSYGradientColorDirection) {
    
    HSYGradientColorDirectionHorizontal     = 10001,             //水平(0, 0)->(1, 0)
    HSYGradientColorDirectionVertical       = 10010,             //垂直(0, 0)->(0, 1)
    HSYGradientColorDirectionBisection      = 10011,             //45度角(0, 0)->(1, 1)
    
};

@interface UIView (GradientColor)

/**
 均等分开的给layer层添加混合色背景色，方向为水平方向从左向右

 @param colors 混合颜色集合
 */
- (void)hsy_setHorizontalDirectionMixtureColors:(NSArray<UIColor *> *)colors;
- (void)hsy_setLocationBisectionDirectionMixtureColors:(NSArray<UIColor *> *)colors;

/**
 均等分开的给layer层添加混合色背景色，方向为垂直方向从上向下

 @param colors 混合颜色集合
 */
- (void)hsy_setVerticalDirectionMixtureColors:(NSArray<UIColor *> *)colors;
- (void)hsy_setLocationHorizontalDirectionMixtureColors:(NSArray<UIColor *> *)colors;

/**
 均等分开的给layer层添加混合色背景色，方向为45度角从左上向右下

 @param colors 混合颜色集合
 */
- (void)hsy_setBisectionDirectionMixtureColors:(NSArray<UIColor *> *)colors;
- (void)hsy_setLocationVerticalDirectionMixtureColors:(NSArray<UIColor *> *)colors;

/**
 生产默认的混合色layer，色值组的区间是均等分的

 @param colors 色值组
 @param frame layer层的frame
 @param direction 方向
 @return CAGradientLayer
 */
+ (CAGradientLayer *)hsy_gradientLayer:(NSArray<UIColor *> *)colors
                                 frame:(CGRect)frame
                             direction:(HSYGradientColorDirection)direction;
+ (CAGradientLayer *)hsy_gradientLocationLayer:(NSArray<UIColor *> *)colors
                                         frame:(CGRect)frame
                                     direction:(HSYGradientColorDirection)direction;


@end

NS_ASSUME_NONNULL_END
