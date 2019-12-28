//
//  HYSWindows.m
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/9.
//

#import "HYSWindows.h"
#import <ReactiveObjC/ReactiveObjC.h> 
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMethodsToolsKit/UIApplication+AppDelegates.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import "HSYGestureTools.h"

//layer层锚点
#define HSYTOOLSKIT_ANCHOR_POINT_X00_Y00                CGPointMake(0.0f, 0.0f)
#define HSYTOOLSKIT_ANCHOR_POINT_X05_Y00                CGPointMake(0.5f, 0.0f)
#define HSYTOOLSKIT_ANCHOR_POINT_X10_Y00                CGPointMake(1.0f, 0.0f)

#define HSYTOOLSKIT_ANCHOR_POINT_X00_Y05                CGPointMake(0.0f, 0.5f)
#define HSYTOOLSKIT_ANCHOR_POINT_X05_Y05                CGPointMake(0.5f, 0.5f)
#define HSYTOOLSKIT_ANCHOR_POINT_X10_Y05                CGPointMake(1.0f, 0.5f)

#define HSYTOOLSKIT_ANCHOR_POINT_X00_Y10                CGPointMake(0.0f, 1.0f)
#define HSYTOOLSKIT_ANCHOR_POINT_X05_Y10                CGPointMake(0.5f, 1.0f)
#define HSYTOOLSKIT_ANCHOR_POINT_X10_Y10                CGPointMake(1.0f, 1.0f)

static CGFloat const kHSYToolsTransformMaxScales        = 1.0;
static CGFloat const kHSYToolsTransformMinScales        = 0.0;

@implementation HSYWindowsMainWicketView

- (instancetype)init
{
    CGFloat widths  = (IPHONE_WIDTH / 5.0f * 3.0f);
    CGFloat heights = (IPHONE_HEIGHT / 3.0f);
    if (self = [super initWithSize:CGSizeMake(widths, heights)]) {
        self.origin = CGPointMake(((IPHONE_WIDTH - self.width) / 2.0f), ((IPHONE_HEIGHT - self.height) / 2.0f));
        self.backgroundColor = UIColor.whiteColor;
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - Setter

- (void)hsy_setRect:(CGRect)rect
{
    if (CGSizeEqualToSize(self.size, CGSizeZero)) {
        self.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE(kHSYToolsTransformMaxScales);
        self.frame = rect;
        self.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE(kHSYToolsTransformMinScales);
        return;
    }
    self.frame = rect;
}

- (void)hsy_setSize:(CGSize)size
{
    [self hsy_setRect:(CGRect){self.origin, size}];
}

- (void)hsy_setRadius:(CGFloat)radius
{
    if (CGSizeEqualToSize(self.size, CGSizeZero)) {
        self.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE(kHSYToolsTransformMaxScales);
        self.layer.cornerRadius = radius;
        self.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE(kHSYToolsTransformMinScales);
        return;
    }
    self.layer.cornerRadius = radius;
}

- (void)hsy_setWindowsAnchorPointType:(kHSYToolsWindowsAnchorPointType)anchorPointType
{
    _anchorPointType = anchorPointType;
    self.layer.anchorPoint = [self.class toAnchorPoint:self.anchorPointType];
}

#pragma mark - Maps

+ (CGPoint)toAnchorPoint:(kHSYToolsWindowsAnchorPointType)anchorPointType
{
    NSValue *valueCGPoint = @{@(kHSYToolsWindowsAnchorPointTypeX00_Y00) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X00_Y00],
                              @(kHSYToolsWindowsAnchorPointTypeX05_Y00) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X05_Y00],
                              @(kHSYToolsWindowsAnchorPointTypeX10_Y00) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X10_Y00],
                              
                              @(kHSYToolsWindowsAnchorPointTypeX00_Y05) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X00_Y05],
                              @(kHSYToolsWindowsAnchorPointTypeX05_Y05) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X05_Y05],
                              @(kHSYToolsWindowsAnchorPointTypeX10_Y05) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X10_Y05],
                              
                              @(kHSYToolsWindowsAnchorPointTypeX00_Y10) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X00_Y10],
                              @(kHSYToolsWindowsAnchorPointTypeX05_Y10) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X05_Y10],
                              @(kHSYToolsWindowsAnchorPointTypeX10_Y10) : [NSValue valueWithCGPoint:HSYTOOLSKIT_ANCHOR_POINT_X10_Y10], }[@(anchorPointType)];
    return valueCGPoint.CGPointValue;
}

@end

//**********************************************************************************************************************************************************************************************************************************************************************************************

@interface HYSWindows () {
    @private HSYWindowsMainWicketView *_mainWicketView;
}

@property (nonatomic, strong) UIView *blackMaskView;

@end 

@implementation HYSWindows

- (instancetype)init
{
    return [self initWithAddGesture:YES];
}

- (instancetype)initWithAddGesture:(BOOL)addTap
{
    UIWindow *window = UIApplication.hsy_keyWindows;
    if (self = [super initWithSize:window.size]) {
        self.backgroundColor = UIColor.clearColor;
        self.blackMaskAlphas = 0.6f;
        
        self.blackMaskView = [[UIView alloc] initWithFrame:self.bounds];
        self.blackMaskView.backgroundColor = UIColor.blackColor;
        self.blackMaskView.alpha = kHSYToolsTransformMinScales;
        if (addTap) {
            @weakify(self);
            [HSYGestureTools hsy_tapGesture:self.blackMaskView touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
                @strongify(self);
                NSLog(@"touchView => %@", touchView);
                [self hsy_defaultRemove];
            }];
        }
        [self addSubview:self.blackMaskView];
        
        self->_mainWicketView = [[HSYWindowsMainWicketView alloc] init];
        self.mainWicketView.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE(kHSYToolsTransformMinScales);
        [self.mainWicketView hsy_setRadius:10.0f];
        [self addSubview:self.mainWicketView];
        
        [window addSubview:self];
    }
    return self;
}

#pragma mark - Setter

- (void)hsy_setBlackMaskAlpha:(CGFloat)blackMaskAlphas
{
    _blackMaskAlphas = blackMaskAlphas;
}

#pragma mark - Animation

+ (NSTimeInterval)hsy_durations
{
    return 0.35f;
}

- (void)hsy_baseShowAlert:(void(^)(HSYWindowsMainWicketView *view))show
                completed:(HSYToolsWindowsCompletedBlock)completed
{
    @weakify(self);
    [UIView animateWithDuration:self.class.hsy_durations animations:^{
        @strongify(self);
        self.blackMaskView.alpha = self.blackMaskAlphas;
        if (show) {
            show(self.mainWicketView);
        }
    } completion:^(BOOL finished) {
        @strongify(self);
        if (completed) {
            [[completed(finished, self.mainWicketView, self.blackMaskView) deliverOn:[RACScheduler mainThreadScheduler]] subscribeCompleted:^{
                @strongify(self);
                if (self.showCompletedBlock) {
                    self.showCompletedBlock(finished, self.mainWicketView, self.blackMaskView);
                }
            }];
        }
    }];
}

- (void)hsy_defaultShow
{
    [self hsy_baseShowAlert:^(HSYWindowsMainWicketView * _Nonnull view) {
        view.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE((kHSYToolsTransformMaxScales + 0.2f));
    } completed:^RACSignal * _Nonnull(BOOL finished, HSYWindowsMainWicketView * _Nonnull view, UIView * _Nonnull blackView) {
        return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
            if (finished) {
                [UIView animateWithDuration:(self.class.hsy_durations/2.0f) animations:^{
                    view.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE(kHSYToolsTransformMaxScales);
                } completion:^(BOOL finished) {
                    [subscriber sendCompleted];
                }];
            }
        }];
    }];
}

- (void)hsy_baseRemoveAlert:(void(^)(HSYWindowsMainWicketView *view))remove
               withDuration:(NSTimeInterval)duration
                  completed:(HSYToolsWindowsCompletedBlock)completed
{
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        self.blackMaskView.alpha = (self.blackMaskAlphas / 3.0f * 2.0f);
        if (remove) {
            remove(self.mainWicketView);
        }
    } completion:^(BOOL finished) {
        @strongify(self);
        if (completed) {
            RACSignal *signal = completed(finished, self.mainWicketView, self.blackMaskView);
            [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeCompleted:^{
                @strongify(self);
                if (self.removeCompletedBlock) {
                    self.removeCompletedBlock(finished, self.mainWicketView, self.blackMaskView);
                }
                [self removeFromSuperview];
            }];
        }
    }];
}

- (void)hsy_defaultRemove
{
    [self hsy_baseRemoveAlert:^(HSYWindowsMainWicketView * _Nonnull view) {
        view.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE((kHSYToolsTransformMaxScales + 0.2f));
    } withDuration:(self.class.hsy_durations/2.0f) completed:^RACSignal * _Nonnull(BOOL finished, HSYWindowsMainWicketView * _Nonnull view, UIView * _Nonnull blackView) {
        return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
            if (finished) {
                [UIView animateWithDuration:self.class.hsy_durations animations:^{
                    blackView.alpha = kHSYToolsTransformMinScales;
                    view.transform = HSYCOCOAKIT_GGA_TRANSFORM_SCALE((kHSYToolsTransformMinScales + 0.2f));
                } completion:^(BOOL finished) {
                    [subscriber sendCompleted];
                }];
            }
        }];
    }];
}

@end

@implementation HYSWindows (Tools)

+ (void)hsy_defaultWindows:(HSYWindowsCreatedReturnBlock)returnBlock
{
    [HYSWindows hsy_defaultWindows:returnBlock addTapGesture:YES];
}

+ (void)hsy_defaultWindows:(HSYWindowsCreatedReturnBlock)returnBlock addTapGesture:(BOOL)addTap
{
    HYSWindows *window = [[HYSWindows alloc] initWithAddGesture:addTap];
    [[returnBlock(window) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple *  _Nullable x) {
        if (x.first && [x.first isKindOfClass:[UIView class]]) {
            UIView *subview = (UIView *)x.first;
            [window.mainWicketView hsy_setRect:(CGRect){CGPointMake(((IPHONE_WIDTH - subview.width) / 2.0f), ((IPHONE_HEIGHT - subview.height) / 2.0f)), subview.size}];
            [window.mainWicketView addSubview:subview];
        }
        [window hsy_defaultShow];
    }];
}


@end
