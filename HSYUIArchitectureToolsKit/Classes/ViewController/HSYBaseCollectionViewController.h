//
//  HSYBaseCollectionViewController.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/17.
//

#import "HSYBaseRefreshViewController+Operation.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseCollectionViewController : HSYBaseRefreshViewController <UICollectionViewDelegate, UICollectionViewDataSource>

//collectionView上下左右四个边距
@property (nonatomic, assign) UIEdgeInsets collectionEdgeInsets;
//item的size
@property (nonatomic, assign) CGSize itemSize;
//行间距
@property (nonatomic, assign) CGFloat lineSpacing;
//块间距
@property (nonatomic, assign) CGFloat interitemSpacing;
//滚动方向
@property (nonatomic, assign) UICollectionViewScrollDirection collectionDirection;
//注册的类,格式:@[@{@"注册的key" : @"注册的类名"}, ...]
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *registerClasses;
//瀑布流list
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
//瀑布流布局
@property (nonatomic, strong, readonly) UICollectionViewFlowLayout *flowLayout;

@end

NS_ASSUME_NONNULL_END
