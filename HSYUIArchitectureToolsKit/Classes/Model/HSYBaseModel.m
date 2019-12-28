//
//  HSYBaseModel.m
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/18.
//

#import "HSYBaseModel.h"
#import <HSYMethodsToolsKit/NSObject+Runtime.h>

@implementation HSYBaseModel

+ (HSYBaseModel *)hsy_runtimeModelWithJSON:(NSDictionary *)dictionary
{
    if (!dictionary.allKeys.count) {
        return nil;
    }
    HSYBaseModel *thisModel = [NSObject hsy_objectRuntimeValues:dictionary
                                                        classes:NSClassFromString(NSStringFromClass(self.class))];
    return thisModel;
}

+ (HSYBaseModel *)hsy_kvcModelWithJSON:(NSDictionary *)dictionary
{
    HSYBaseModel *thisModel = [[NSClassFromString(NSStringFromClass(self.class)) alloc] init];
    for (NSString *forKey in dictionary.allKeys) {
        if ([thisModel respondsToSelector:NSSelectorFromString(forKey)]) {
            [thisModel setValue:dictionary[forKey] forKey:forKey];
        }
    }
    return thisModel;
}

@end
