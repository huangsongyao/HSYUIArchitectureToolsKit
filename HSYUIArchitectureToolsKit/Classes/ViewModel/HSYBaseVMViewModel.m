//
//  HSYBaseVMViewModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/25.
//

#import "HSYBaseVMViewModel.h"
#import <HSYMethodsToolsKit/RACSignal+Timer.h>
#import <HSYMethodsToolsKit/RACSignal+Convenients.h>
#import <HSYMethodsToolsKit/NSObject+JSONModel.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/NSDate+Timestamp.h>

static NSTimeInterval count = 0;

@interface HSYBaseVMViewModel () {
    @private RACSubject *_combineSubject;
}

@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation HSYBaseVMViewModel

#pragma mark - Methods

+ (RACSignal *)hsy_requsetNetwork:(HSYNetworkSignalBlock)network toMapClass:(HSYNetworkMapClassBlock)map
{
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        RACSignal *signal = network();
        [[signal map:^id _Nullable(id  _Nullable value) {
            id mapModel = [NSObject hsy_toJSONModel:value forModelClasses:NSClassFromString(map(value))];
            return mapModel;
        }] subscribeNext:^(id  _Nullable x) {
            [RACSignal hsy_performSendSignal:subscriber forObject:x];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
    }];
}

- (RACSignal *)hsy_requsetNetwork:(HSYNetworkSignalBlock)network toMapClass:(HSYNetworkMapClassBlock)map
{
    return [HSYBaseVMViewModel hsy_requsetNetwork:network toMapClass:map];
}

+ (RACSignal *)hsy_requsetNetwork:(HSYNetworkSignalBlock)network toMap:(HSYNetworkMapBlock)map
{
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        RACSignal *signal = network();
        [[signal map:map] subscribeNext:^(id  _Nullable x) {
            [RACSignal hsy_performSendSignal:subscriber forObject:x];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        }];
    }];
}

- (RACSignal *)hsy_requsetNetwork:(HSYNetworkSignalBlock)network toMap:(HSYNetworkMapBlock)map
{
    return [HSYBaseVMViewModel hsy_requsetNetwork:network toMap:map];
}

- (RACSignal<RACTuple *> *)hsy_zipSignals:(NSArray<NSDictionary<RACSignal *, NSString *> *> *)signals
{
    if (!signals.count) {
        return [RACSignal hsy_sendTupleSignal:nil];
    }
    return [RACSignal hsy_signalSubscriber:^(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableArray *requestSignals = [NSMutableArray arrayWithCapacity:signals.count];
        NSMutableArray *mapModels = [NSMutableArray arrayWithCapacity:signals.count];
        for (NSDictionary<RACSignal *, NSString *> *signal in signals) {
            [requestSignals addObject:signal.allKeys.firstObject];
            [mapModels addObject:signal.allValues.firstObject];
        }
        [[[RACSignal zip:requestSignals] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(RACTuple * _Nullable x) {
            NSArray *results = x.allObjects;
            NSMutableArray *mapResults = [NSMutableArray arrayWithCapacity:results.count];
            for (id object in results) {
                id mapModel = ((![object isKindOfClass:[RACTupleNil class]]) ? [NSObject hsy_toJSONModel:object forModelClasses:mapModels[[results indexOfObject:object]]] : object);
                [mapResults addObject:mapModel];
            }
            [RACSignal hsy_performSendSignal:subscriber forObject:RACTuplePack(x, mapResults)];
        }];
    }];
}

#pragma mark - Timer

- (void)hsy_intervalTimer:(NSTimeInterval)interval intervalBlock:(BOOL (^)(NSDate *date, NSTimeInterval currenctCount))block
{
    @weakify(self);
    _disposable = [RACSignal hsy_timerSignal:interval timerMaxIntervals:D_YEAR subscribeNext:^BOOL(NSDate * _Nonnull date, NSTimeInterval interval) {
        @strongify(self);
        if (!block) {
            NSLog(@"warning -> “- (void)hsy_intervalTimer:(NSTimeInterval)interval intervalBlock:(BOOL (^)(NSDate *date, NSTimeInterval currenctCount))block”for block is nil -- !");
            [self.disposable dispose];
            return YES;
        }
        return block(date, interval);
    }];
}

#pragma mark - Lazy

- (RACSubject *)combineSubject
{
    if (!_combineSubject) {
        _combineSubject = [RACSubject subject];
    }
    return _combineSubject;
}

- (NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

#pragma mark - Dealloc

- (void)dealloc
{
    [_combineSubject sendCompleted];
    _combineSubject = nil;
    if (_disposable) {
        [_disposable dispose];
        _disposable = nil;
        count = 0;
    }
    NSLog(@"%@->ViewModel class execute dealloc completed !", self.class);
}


@end
