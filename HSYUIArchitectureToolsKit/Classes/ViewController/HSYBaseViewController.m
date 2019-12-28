//
//  HSYBaseViewController.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/18.
//

#import "HSYBaseViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UIView+Frame.h>

@interface HSYBaseViewController () <UIGestureRecognizerDelegate> {
    @private UIView *_hsy_view;
    @private HSYCustomNavigationContentViewBar *_customNavigationContentViewBar;
}

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation HSYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSParameterAssert(self.viewModel);
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.hidden = YES;
    self.shouldForbidReceiveClasses = @[];
    self.touchEndEditing = NO;
    self.interactivePopGestureRecognizerEnable = YES;
    self.loading = YES;
    // Do any additional setup after loading the view.
}

#pragma mark - Methods

- (UINavigationItem *)hsy_realNavigationBarItem
{
    return self.customNavigationContentViewBar.navigationBar.customNavigationItem;
}

#pragma mark - Load

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.interactivePopGestureRecognizerEnable && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.interactivePopGestureRecognizerEnable && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - Lazy

- (UIView *)hsy_view
{
    if (!_hsy_view) {
        _hsy_view = [[UIView alloc] init];
        _hsy_view.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_hsy_view];
        [self.view sendSubviewToBack:_hsy_view];
        @weakify(self);
        [_hsy_view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self.view);
        }];
    }
    return _hsy_view;
}

- (UIActivityIndicatorView *)loadingIndicatorView
{
    if (!_loadingIndicatorView) {
        _loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicatorView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_loadingIndicatorView];
        [self.view bringSubviewToFront:_loadingIndicatorView];
        @weakify(self); 
        [_loadingIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.customNavigationContentViewBar.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    return _loadingIndicatorView;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [[[_tapGesture rac_gestureSignal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self.hsy_view endEditing:self.touchEndEditing];
        }];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

- (HSYCustomNavigationContentViewBar *)customNavigationContentViewBar
{
    if (!_customNavigationContentViewBar) {
        _customNavigationContentViewBar = [[HSYCustomNavigationContentViewBar alloc] initWithDefault];
        if (self.navigationController.viewControllers.count > 1) {
            @weakify(self);
            _customNavigationContentViewBar.navigationBar.customNavigationItem.leftBarButtonItems = @[[HSYCustomNavigationBar hsy_defaultBackBarButtonItem:^(UIButton * _Nonnull button, NSInteger tag) {
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            }]];
        }
        [self.view addSubview:_customNavigationContentViewBar];
    }
    return _customNavigationContentViewBar;
}

#pragma mark - Setter

- (void)setTouchEndEditing:(BOOL)touchEndEditing
{
    _touchEndEditing = touchEndEditing;
    HSYCOCOAKIT_IGNORED_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self.hsy_view performSelector:NSSelectorFromString(@{@(YES) : NSStringFromSelector(@selector(addGestureRecognizer:)), @(NO) : NSStringFromSelector(@selector(removeGestureRecognizer:))}[@(touchEndEditing)]) withObject:self.tapGesture];);
}

- (void)loadingDefault:(BOOL)loading
{
    _loading = loading;
    @weakify(self);
    [[RACScheduler mainThreadScheduler] schedule:^{
        @strongify(self);
        [self.loadingIndicatorView.superview bringSubviewToFront:self.loadingIndicatorView];
        HSYCOCOAKIT_IGNORED_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self.loadingIndicatorView performSelector:NSSelectorFromString(@{@(YES) : NSStringFromSelector(@selector(startAnimating)), @(NO) : NSStringFromSelector(@selector(stopAnimating))}[@(loading)])];);
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //UICollectionViewCell和UITableViewCell类族收货到点击事件时，返回NO
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        BOOL iskindOfCollectionReusableClass = [touch.view.superview isKindOfClass:[UICollectionReusableView class]];
        BOOL iskindOfTableViewCellClass = ([touch.view.superview isKindOfClass:[UITableViewCell class]] || [touch.view.superview isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]);
        if (iskindOfCollectionReusableClass || iskindOfTableViewCellClass) {
            return NO;
        }
    }
    //根据self.shouldForbidReceiveClasses的集合中是否包含了需要过滤单击事件的类，如果包含则不触发单击事件
    BOOL contains = [self.shouldForbidReceiveClasses containsObject:NSStringFromClass(touch.view.class)];
    return !contains;
}

@end
