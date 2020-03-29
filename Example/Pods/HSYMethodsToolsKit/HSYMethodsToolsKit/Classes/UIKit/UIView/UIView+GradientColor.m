//
//  UIView+GradientColor.m
//  HSYMethodsToolsKit
//
//  Created by huangsongyao on 2020/3/9.
//

#import "UIView+GradientColor.h"

@implementation UIView (GradientColor) 

+ (NSArray<NSNumber *> *)hsy_locationsByMixtureColors:(NSArray<UIColor *> *)colors
{
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", @(1.0f)]];
    NSDecimalNumber *byDividing = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@", @(colors.count)]];
    NSDecimalNumber *result = [decimalNumber decimalNumberByDividingBy:byDividing];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:colors.count];
    for (NSInteger i = 0; i < colors.count; i ++) {
        if (i > 0) {
            result = [result decimalNumberByAdding:result];
        }
        [results addObject:result];
    }
    return results.mutableCopy;
}

- (void)hsy_setLocationBisectionDirectionMixtureColors:(NSArray<UIColor *> *)colors
{
    [self hsy_setMixtureColors:colors locations:@[@(0.0f), @(1.0f)] direction:HSYGradientColorDirectionBisection];
}

- (void)hsy_setBisectionDirectionMixtureColors:(NSArray<UIColor *> *)colors
{
    NSArray *results = [self.class hsy_locationsByMixtureColors:colors];
    [self hsy_setMixtureColors:colors locations:results.mutableCopy direction:HSYGradientColorDirectionBisection];
}

- (void)hsy_setLocationHorizontalDirectionMixtureColors:(NSArray<UIColor *> *)colors
{
    [self hsy_setMixtureColors:colors locations:@[@(0.0f), @(1.0f)] direction:HSYGradientColorDirectionHorizontal];
}

- (void)hsy_setHorizontalDirectionMixtureColors:(NSArray<UIColor *> *)colors
{
    NSArray *results = [self.class hsy_locationsByMixtureColors:colors];
    [self hsy_setMixtureColors:colors locations:results.mutableCopy direction:HSYGradientColorDirectionHorizontal];
}

- (void)hsy_setLocationVerticalDirectionMixtureColors:(NSArray<UIColor *> *)colors
{
    [self hsy_setMixtureColors:colors locations:@[@(0.0f), @(1.0f)] direction:HSYGradientColorDirectionVertical];
}

- (void)hsy_setVerticalDirectionMixtureColors:(NSArray<UIColor *> *)colors
{
    NSArray *results = [self.class hsy_locationsByMixtureColors:colors];
    [self hsy_setMixtureColors:colors locations:results.mutableCopy direction:HSYGradientColorDirectionVertical];
}

- (void)hsy_setMixtureColors:(NSArray<NSDictionary<UIColor *, NSNumber *> *> *)colors direction:(HSYGradientColorDirection)direction
{
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:colors.count];
    for (NSDictionary *color in colors) {
        [cgColors addObject:color.allKeys.firstObject];
        [locations addObject:color.allValues.firstObject];
    }
    [self hsy_setMixtureColors:cgColors locations:locations direction:direction];
}

- (void)hsy_setMixtureColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations direction:(HSYGradientColorDirection)direction
{
    CAGradientLayer *layer = [self.class hsy_gradientLayer:colors locations:locations frame:self.frame direction:direction];
    [self.layer addSublayer:layer];
}

+ (CAGradientLayer *)hsy_gradientLayer:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations frame:(CGRect)frame direction:(HSYGradientColorDirection)direction
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSParameterAssert(!CGRectEqualToRect(frame, CGRectZero));
    layer.frame = frame;
    NSDictionary<NSValue *, NSValue *> *directionDictionary = [self.class hsy_mixtrueColorDrawCGPoint:direction];
    layer.startPoint = directionDictionary.allKeys.firstObject.CGPointValue;
    layer.endPoint = directionDictionary.allValues.firstObject.CGPointValue;
    
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [cgColors addObject:((__bridge id)color.CGColor)];
    }
    
    layer.colors = cgColors.mutableCopy;
    layer.locations = locations;
    return layer;
}

+ (CAGradientLayer *)hsy_gradientLayer:(NSArray<UIColor *> *)colors
                                 frame:(CGRect)frame
                             direction:(HSYGradientColorDirection)direction
{
    return [self.class hsy_gradientLayer:colors
                               locations:[self.class hsy_locationsByMixtureColors:colors]
                                   frame:frame
                               direction:direction];
}

+ (CAGradientLayer *)hsy_gradientLocationLayer:(NSArray<UIColor *> *)colors
                                         frame:(CGRect)frame
                                     direction:(HSYGradientColorDirection)direction
{
    return [self.class hsy_gradientLayer:colors
                               locations:@[@(0.0f), @(1.0f)]
                                   frame:frame
                               direction:direction];
}

+ (NSDictionary<NSValue *, NSValue *> *)hsy_mixtrueColorDrawCGPoint:(HSYGradientColorDirection)direction
{
    NSDictionary<NSValue *, NSValue *> *valueDictionary = @{
                                                            @(HSYGradientColorDirectionHorizontal) : @{[NSValue valueWithCGPoint:CGPointZero] : [NSValue valueWithCGPoint:CGPointMake(1, 0)]},
                                                            @(HSYGradientColorDirectionVertical) : @{[NSValue valueWithCGPoint:CGPointZero] : [NSValue valueWithCGPoint:CGPointMake(0, 1)]},
                                                            @(HSYGradientColorDirectionBisection) : @{[NSValue valueWithCGPoint:CGPointZero] : [NSValue valueWithCGPoint:CGPointMake(1, 1)]}, }[@(direction)];
    return valueDictionary;
                                               
}


@end
