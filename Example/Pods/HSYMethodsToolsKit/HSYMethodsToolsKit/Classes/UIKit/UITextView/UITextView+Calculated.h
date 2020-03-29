//
//  UITextView+Calculated.h
//  HSYMethodsToolsKit
//
//  Created by huangsongyao on 2020/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Calculated)

/// 计算UITextView真实的显示高度
/// @param displayWidths 真实的最大显示区域的宽度
- (CGSize)hsy_calculatedConstainsRealSize:(CGFloat)displayWidths;

/// 设置UITextView的高度为计算后的真实的显示高度
/// @param displayWidths 真实的最大显示区域的宽度
- (void)hsy_setConstainsReal:(CGFloat)displayWidths;

@end

NS_ASSUME_NONNULL_END
