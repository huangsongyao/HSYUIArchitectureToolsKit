//
//  HSYBaseCustomSegmentedPageControlItem.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/25.
//

#import <HSYMethodsToolsKit/RACSignal+Convenients.h>

NS_ASSUME_NONNULL_BEGIN

@class HSYBaseCustomSegmentedPageControlItem, HSYBaseCustomSegmentedPageControlModel;
typedef RACSignal<RACTuple *> *_Nonnull(^HSYBaseCustomSegmentedPageControlItemActionBlock)(HSYBaseCustomSegmentedPageControlItem *button, HSYBaseCustomSegmentedPageControlModel *controlModel); 
@interface HSYBaseCustomSegmentedPageControlItem : UIButton

//page control item的参数模型
@property (nonatomic, strong, readonly) HSYBaseCustomSegmentedPageControlModel *controlModel;

/**
 快速创建方法，返回定制的按钮item

 @param controlModel 参数模型
 @param action 回调事件，该事件需要返回一个RACSignal<RACTuple *> *信号类型，其中，firstObject=>HSYBaseCustomSegmentedPageControlModel, secondObject=>HSYBaseCustomSegmentedPageControlItem
 @return HSYBaseCustomSegmentedPageControlItem
 */
+ (instancetype)initWithControlModel:(HSYBaseCustomSegmentedPageControlModel *)controlModel
                          withAction:(HSYBaseCustomSegmentedPageControlItemActionBlock)action;

/**
 重置选中状态为NO
 */
- (void)hsy_resetUnselectedSegmentedPageControlModel;

/**
 重置选中状态为YES
 */
- (void)hsy_resetSelectedSegmentedPageControlModel;

@end

NS_ASSUME_NONNULL_END
