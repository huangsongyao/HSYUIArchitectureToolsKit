//
//  HSYBaseCollectionViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/12/17.
//

#import "HSYBaseCollectionViewController.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>

@interface HSYBaseCollectionViewController () {
    @private UICollectionView *_collectionView;
    @private UICollectionViewFlowLayout *_flowLayout;
}

@end

@implementation HSYBaseCollectionViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.collectionDirection = UICollectionViewScrollDirectionVertical;
        self.interitemSpacing = 0.0f;
        self.lineSpacing = 0.0f;
        self.collectionEdgeInsets = UIEdgeInsetsZero;
        self.itemSize = CGSizeMake(IPHONE_WIDTH, 44.0f);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSParameterAssert(self.registerClasses);
    
    // Do any additional setup after loading the view.
}

#pragma mark - Lazy

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = self.collectionDirection;
        _flowLayout.sectionInset = self.collectionEdgeInsets;
        _flowLayout.itemSize = self.itemSize;
        _flowLayout.minimumLineSpacing = self.lineSpacing;
        _flowLayout.minimumInteritemSpacing = self.interitemSpacing;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.hsy_toListCGRect collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = UIColor.clearColor;
        [self.view addSubview:_collectionView];
        for (NSDictionary *registerClass in self.registerClasses) {
            Class class = NSClassFromString(registerClass.allValues.firstObject);
            NSString *forKey = registerClass.allKeys.firstObject; 
            [_collectionView registerClass:class forCellWithReuseIdentifier:forKey];
        }
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hsy_deselectRowBlock) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        self.hsy_deselectRowBlock(indexPath, collectionView, cell);
    }
}

@end
