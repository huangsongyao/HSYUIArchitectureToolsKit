//
//  UIImage+MixColors.m
//  HSYMethodsToolsKit
//
//  Created by huangsongyao on 2020/3/9.
//

#import "UIImage+MixColors.h"
#import "UIView+GradientColor.h"

@implementation UIImage (MixColors)

+ (UIImage *)hsy_imageWithMixColors:(NSArray *)colors size:(CGSize)size
{
    CAGradientLayer *layer = [UIView hsy_gradientLocationLayer:colors
                                                         frame:CGRectMake(0.0f, 0.0f, size.width, size.height)
                                                     direction:HSYGradientColorDirectionBisection];
    
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
