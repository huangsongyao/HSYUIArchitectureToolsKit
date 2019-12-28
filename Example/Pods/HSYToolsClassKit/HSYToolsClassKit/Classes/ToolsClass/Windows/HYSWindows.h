//
//  HYSWindows.h
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kHSYToolsWindowsAnchorPointType) {
    
    kHSYToolsWindowsAnchorPointTypeX00_Y00,     //(0.0, 0.0)
    kHSYToolsWindowsAnchorPointTypeX05_Y00,     //(0.5, 0.0)
    kHSYToolsWindowsAnchorPointTypeX10_Y00,     //(1.0, 0.0)
    
    kHSYToolsWindowsAnchorPointTypeX00_Y05,     //(0.0, 0.5)
    kHSYToolsWindowsAnchorPointTypeX05_Y05,     //(0.5, 0.5)
    kHSYToolsWindowsAnchorPointTypeX10_Y05,     //(1.0, 0.5)
    
    kHSYToolsWindowsAnchorPointTypeX00_Y10,     //(0.0, 1.0)
    kHSYToolsWindowsAnchorPointTypeX05_Y10,     //(0.5, 1.0)
    kHSYToolsWindowsAnchorPointTypeX10_Y10,     //(1.0, 1.0)
    
};

@interface HSYWindowsMainWicketView : UIView

//锚点位置类型
@property (nonatomic, assign, setter=hsy_setWindowsAnchorPointType:) kHSYToolsWindowsAnchorPointType anchorPointType;
//设置frame
- (void)hsy_setRect:(CGRect)rect;
//设置size
- (void)hsy_setSize:(CGSize)size;
//设置radius
- (void)hsy_setRadius:(CGFloat)radius;
//通过kHSYToolsWindowsAnchorPointType类型枚举返回对应的锚点坐标
+ (CGPoint)toAnchorPoint:(kHSYToolsWindowsAnchorPointType)anchorPointType;

@end

@class RACSignal;
typedef RACSignal *_Nonnull(^HSYToolsWindowsCompletedBlock)(BOOL finished, HSYWindowsMainWicketView *view, UIView *blackView);
@interface HYSWindows : UIView

//主视图窗口
@property (nonatomic, strong, readonly) HSYWindowsMainWicketView *mainWicketView;
//黑色背景的动画过度色
@property (nonatomic, assign, setter=hsy_setBlackMaskAlpha:) CGFloat blackMaskAlphas;
//show动画结束后的消息回调
@property (nonatomic, copy) HSYToolsWindowsCompletedBlock showCompletedBlock;
//remove动画结束后的消息回调
@property (nonatomic, copy) HSYToolsWindowsCompletedBlock removeCompletedBlock;

/**
 初始化构造函数---黑色背景层是否添加单击手势来执行remove

 @param addTap 是否添加单击手势来执行remove
 @return instancetype
 */
- (instancetype)initWithAddGesture:(BOOL)addTap;

/**
 原始出现动画，方法中的黑色背景的过度为渐入渐出，已在方法内部实现，子类调用本方法后，可以在show中处理主视图窗口的过度动画效果

 @param show 过度动画，可以在show中处理主视图窗口的过度动画效果
 @param completed 动画完成，可以在completed中处理是否增加陆续动画效果
 */
- (void)hsy_baseShowAlert:(void(^)(HSYWindowsMainWicketView *view))show
                completed:(HSYToolsWindowsCompletedBlock)completed;

/**
 原始隐藏动画，方法中的黑色背景的过度为渐入渐出，已在方法内部实现，remove中的渐出效果只执行3/1，余下的3/2检出效果需要在completed内的二次动画中由外部控制，子类调用本方法后，可以在remove中处理主视图窗口的过度动画效果

 @param remove 过度动画，可以在remove中处理主视图窗口的过度动画效果
 @param duration 初次动画过度时间
 @param completed 动画完成，可以在completed中处理是否增加陆续动画效果，并且需要在completed中返回一个RACSignal，这个RACSignal的completed信号回最终执行[self removeFromSuperview];移除window视图
 */
- (void)hsy_baseRemoveAlert:(void(^)(HSYWindowsMainWicketView *view))remove
               withDuration:(NSTimeInterval)duration
                  completed:(HSYToolsWindowsCompletedBlock)completed;

/**
 默认的弹窗动画----放大
 */
- (void)hsy_defaultShow;

/**
 默认的的弹窗动画----缩小
 */
- (void)hsy_defaultRemove;

/**
 动画时长，对于“- hsy_defaultShow”而言，表示初次动画时长，对于“- hsy_defaultRemove”而言表示二次动画时长

 @return 动画时长
 */
+ (NSTimeInterval)hsy_durations;

@end

typedef RACSignal *_Nonnull(^HSYWindowsCreatedReturnBlock)(HYSWindows *windows);
@interface HYSWindows (Tools)

/**
 快速方法，默认会在黑色背景层上添加单击手势执行remove动作，HSYWindowsCreatedReturnBlock这个类型的block需要外部返回一个RACSignal，这个RACSignal的泛型为RACTuple，其中，RACTuple.first 指向=> UIView类型

 @param returnBlock HSYWindowsCreatedReturnBlock类型，外部返回一个RACSignal，这个RACSignal的泛型为RACTuple，其中，RACTuple.first 指向=> UIView指针类型
 */
+ (void)hsy_defaultWindows:(HSYWindowsCreatedReturnBlock)returnBlock;

/**
 快速方法，HSYWindowsCreatedReturnBlock这个类型的block需要外部返回一个RACSignal，这个RACSignal的泛型为RACTuple，其中，RACTuple.first 指向=> UIView类型

 @param returnBlock HSYWindowsCreatedReturnBlock类型，外部返回一个RACSignal，这个RACSignal的泛型为RACTuple，其中，RACTuple.first 指向=> UIView指针类型
 @param addTap 是否在黑色背景层上添加单击手势执行remove动作
 */
+ (void)hsy_defaultWindows:(HSYWindowsCreatedReturnBlock)returnBlock addTapGesture:(BOOL)addTap;

@end

NS_ASSUME_NONNULL_END
