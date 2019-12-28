//
//  HSYBaseModel.h
//  HSYUIToolsKit
//
//  Created by anmin on 2019/10/18.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSYBaseModel : JSONModel

/**
 利用runtime将json映射为不带Optional协议的数据模型，支持嵌套格式的json数据

 @param dictionary json数据
 @return HSYBaseModel
 */
+ (HSYBaseModel *)hsy_runtimeModelWithJSON:(NSDictionary *)dictionary;

/**
 利用kvc将json映射为不带Optional协议的数据模型，只支持简单格式的json数据

 @param dictionary json数据
 @return HSYBaseModel
 */
+ (HSYBaseModel *)hsy_kvcModelWithJSON:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
