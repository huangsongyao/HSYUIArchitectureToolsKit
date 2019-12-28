//
//  HSYBaseRefreshViewModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/25.
//

#import "HSYBaseRefreshViewModel.h"

@implementation HSYBaseRefreshViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _firstPage = @(1);
        _paging = @(self.firstPage.integerValue);
        _branches = @(100);
    }
    return self;
}

#pragma mark - Request Methods

- (RACSignal *)refreshOperation:(kHSYNetworkRefreshState)operation requsetNetwork:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        [[self hsy_requsetNetwork:network toMap:map] subscribeNext:^(NSArray *list) {
            @strongify(self);
            if (operation == kHSYNetworkRefreshStateDown) {
                self.dataSources = [list mutableCopy];
                self->_paging = @(self.firstPage.integerValue);
                [subscriber sendNext:RACTuplePack(self.dataSources, list)];
                [subscriber sendCompleted];
                return;
            }
            for (id x in list) {
                [self.dataSources addObject:x];
            }
            self->_paging = @(self->_paging.integerValue + 1);
            [subscriber sendNext:RACTuplePack(self.dataSources, list)];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"release cool signal method in ”%@“ class", self.class);
        }];
    }];
}

- (RACSignal *)hsy_refreshForDown
{
    return [self hsy_refreshForDown:^RACSignal * _Nonnull{
        return [RACSignal empty];
    } toMap:^NSArray * _Nonnull(id  _Nonnull result) {
        return @[result];
    }];
}

- (RACSignal *)hsy_refreshForDown:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map
{
    return [self refreshOperation:kHSYNetworkRefreshStateDown requsetNetwork:network toMap:map];
}

- (RACSignal *)hsy_refreshForUp
{
    return [self hsy_refreshForUp:^RACSignal * _Nonnull{
        return [RACSignal empty];
    } toMap:^NSArray * _Nonnull(id  _Nonnull result) {
        return @[result];
    }];
}

- (RACSignal *)hsy_refreshForUp:(HSYNetworkSignalBlock)network toMap:(HSYNetworkRefreshMapBlock)map
{
    return [self refreshOperation:kHSYNetworkRefreshStateUp requsetNetwork:network toMap:map];
}


@end
