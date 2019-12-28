//
//  HSYAirgasWindows.h
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/9.
//

#import "HYSWindows.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kHSYAirgasWindowsState) {
    
    kHSYAirgasWindowsStateToTop,//从底部中间弹出
    kHSYAirgasWindowsStateToBottom,//从顶部中间弹出
    kHSYAirgasWindowsStateToLeft,//从左上角弹出
    kHSYAirgasWindowsStateToRight,//从右上角弹出
    
};

@interface HSYAirgasWindowsArgument : NSObject

//动画类型
@property (nonatomic, assign) kHSYAirgasWindowsState state;
//和锚点对应的方位坐标，position表示锚点对应的位置在视图中的坐标，例如kHSYAirgasWindowsStateToTop类型的锚点为(0.5, 0.0)，则position的坐标在就是主窗口在UIWindow上的(IPHONE_WIDTH - IPHONE_WIDTH/2.0, y)，其中y为高度坐标
@property (nonatomic, assign) CGPoint position;
//气囊的size
@property (nonatomic, assign) CGSize size;

/**
 将self.state对应的kHSYAirgasWindowsState气囊枚举转化为对应的锚点坐标

 @return 气囊枚举对应的锚点坐标
 */
- (CGPoint)hsy_toAnchorPoint;

@end

@interface HSYAirgasWindows : HYSWindows

//气囊动画的参数模型
@property (nonatomic, strong, readonly) HSYAirgasWindowsArgument *airgasArgument;

/**
 初始化构造函数方法

 @param argument 气囊动画的参数模型
 @return HSYAirgasWindows
 */
- (instancetype)initWithArgument:(HSYAirgasWindowsArgument *)argument;

/**
 显示气囊动画
 */
- (void)hsy_showAirgas;

/**
 隐藏气囊动画
 */
- (void)hsy_removeAirgas;

@end

@interface HSYAirgasWindows (Tools)

/**
 快速创建方法

 @param argument 气囊动画的参数模型
 @param completed remove动画结束回调
 @return HSYAirgasWindows
 */
+ (HSYAirgasWindows *)hsy_airgasWindows:(HSYAirgasWindowsArgument *)argument completed:(HSYToolsWindowsCompletedBlock)completed;

@end

NS_ASSUME_NONNULL_END
