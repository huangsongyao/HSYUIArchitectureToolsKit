//
//  HSYGestureTools.h
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HSYGestureToolsTouchBlock)(UIGestureRecognizer *gesture, UIView *touchView, CGPoint location);
@interface HSYGestureTools : NSObject

//交互手势禁止触发的类的集合，即，shouldReceives中所存放的类名，在UIGestureRecognizerDelegate中将不会被触发
@property (nonatomic, copy) NSArray<NSString *> *shouldReceives;

/**
 单击手势

 @param inView UITapGestureRecognizer所在的view
 @param tap 单击手势响应事件
 @return UITapGestureRecognizer
 */
+ (UITapGestureRecognizer *)hsy_tapGesture:(UIView *)inView touchTapGestureBlock:(HSYGestureToolsTouchBlock)tap;

/**
 双击手势

 @param inView UITapGestureRecognizer所在的view
 @param tap 双击手势响应事件
 @return UITapGestureRecognizer
 */
+ (UITapGestureRecognizer *)hsy_doubleTapGesture:(UIView *)inView touchTapGestureBlock:(HSYGestureToolsTouchBlock)tap;

/**
 放缩手势

 @param inView UIPinchGestureRecognizer所在的view
 @param pinch 放缩手势响应事件
 @return UIPinchGestureRecognizer
 */
+ (UIPinchGestureRecognizer *)hsy_pinchGesture:(UIView *)inView touchPinchGestureBlock:(HSYGestureToolsTouchBlock)pinch;

@end

NS_ASSUME_NONNULL_END
