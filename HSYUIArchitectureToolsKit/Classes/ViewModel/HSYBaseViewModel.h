//
//  HSYBaseViewModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/18.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseViewModel : NSObject

// Whether the view model is currently "active."
//
// This generally implies that the associated view is visible. When set to NO,
// the view model should throttle or cancel low-priority or UI-related work.
//
// This property defaults to NO.
@property (nonatomic, assign, getter = isActive) BOOL active;

// Observes the receiver's `active` property, and sends the receiver whenever it
// changes from NO to YES.
//
// If the receiver is currently active, this signal will send once immediately
// upon subscription.
@property (nonatomic, strong, readonly) RACSignal *didBecomeActiveSignal;

// Observes the receiver's `active` property, and sends the receiver whenever it
// changes from YES to NO.
//
// If the receiver is currently inactive, this signal will send once immediately
// upon subscription.
@property (nonatomic, strong, readonly) RACSignal *didBecomeInactiveSignal;

// Subscribes (or resubscribes) to the given signal whenever
// `didBecomeActiveSignal` fires.
//
// When `didBecomeInactiveSignal` fires, any active subscription to `signal` is
// disposed.
//
// Returns a signal which forwards `next`s from the latest subscription to
// `signal`, and completes when the receiver is deallocated. If `signal` sends
// an error at any point, the returned signal will error out as well.
- (RACSignal *)forwardSignalWhileActive:(RACSignal *)signal;

// Throttles events on the given signal while the receiver is inactive.
//
// Unlike -forwardSignalWhileActive:, this method will stay subscribed to
// `signal` the entire time, except that its events will be throttled when the
// receiver becomes inactive.
//
// Returns a signal which forwards events from `signal` (throttled while the
// receiver is inactive), and completes when `signal` completes or the receiver
// is deallocated.
- (RACSignal *)throttleSignalWhileInactive:(RACSignal *)signal;


@end

NS_ASSUME_NONNULL_END
