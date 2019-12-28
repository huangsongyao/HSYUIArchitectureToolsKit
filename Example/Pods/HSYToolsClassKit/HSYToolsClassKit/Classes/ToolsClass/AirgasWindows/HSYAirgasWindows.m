//
//  HSYAirgasWindows.m
//  HSYToolsClassKit
//
//  Created by anmin on 2019/12/9.
//

#import "HSYAirgasWindows.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>

@implementation HSYAirgasWindowsArgument

- (CGPoint)hsy_toAnchorPoint
{
    return [@{@(kHSYAirgasWindowsStateToBottom) : [NSValue valueWithCGPoint:[HSYWindowsMainWicketView toAnchorPoint:kHSYToolsWindowsAnchorPointTypeX05_Y00]],
              @(kHSYAirgasWindowsStateToTop) : [NSValue valueWithCGPoint:[HSYWindowsMainWicketView toAnchorPoint:kHSYToolsWindowsAnchorPointTypeX05_Y10]],
              @(kHSYAirgasWindowsStateToRight) : [NSValue valueWithCGPoint:[HSYWindowsMainWicketView toAnchorPoint:kHSYToolsWindowsAnchorPointTypeX00_Y00]],
              @(kHSYAirgasWindowsStateToLeft) : [NSValue valueWithCGPoint:[HSYWindowsMainWicketView toAnchorPoint:kHSYToolsWindowsAnchorPointTypeX10_Y00]], }[@(self.state)] CGPointValue];
}

@end

@implementation HSYAirgasWindows

- (instancetype)initWithArgument:(HSYAirgasWindowsArgument *)argument 
{
    if (self = [super init]) {
        self->_airgasArgument = argument;
        if (!CGSizeEqualToSize(argument.size, CGSizeZero)) {
            [self.mainWicketView hsy_setSize:argument.size];
        }
        self.mainWicketView.layer.anchorPoint = self.airgasArgument.hsy_toAnchorPoint;
        self.mainWicketView.layer.position = argument.position;
    }
    return self;
}

#pragma mark - Animation

- (void)hsy_showAirgas
{
    [self hsy_defaultShow];
}

- (void)hsy_removeAirgas
{
    [self hsy_defaultRemove];
}

@end

@implementation HSYAirgasWindows (Tools)

+ (HSYAirgasWindows *)hsy_airgasWindows:(HSYAirgasWindowsArgument *)argument completed:(HSYToolsWindowsCompletedBlock)completed
{
    HSYAirgasWindows *airgasWindow = [[HSYAirgasWindows alloc] initWithArgument:argument];
    [airgasWindow hsy_showAirgas];
    airgasWindow.removeCompletedBlock = completed;
    return airgasWindow;
}

@end
