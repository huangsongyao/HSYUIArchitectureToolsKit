//
//  UITextView+Calculated.m
//  HSYMethodsToolsKit
//
//  Created by huangsongyao on 2020/3/9.
//

#import "UITextView+Calculated.h"
#import "NSString+StringSize.h"
#import "UIView+Frame.h"

@implementation UITextView (Calculated)

- (CGSize)hsy_calculatedConstainsRealSize:(CGFloat)displayWidths
{
    self.textContainerInset = UIEdgeInsetsZero;
    CGSize realSize = [self.text hsy_boundingRectWithWidths:(displayWidths - (self.textContainer.lineFragmentPadding * 2.0f)) font:self.font];
    return realSize;
}

- (void)hsy_setConstainsReal:(CGFloat)displayWidths
{
    CGSize size = [self hsy_calculatedConstainsRealSize:displayWidths];
    self.height = size.height;
}

@end
