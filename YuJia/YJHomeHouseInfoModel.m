//
//  YJHomeHouseInfoModel.m
//  YuJia
//
//  Created by 万宇 on 2017/8/29.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomeHouseInfoModel.h"

@implementation YJHomeHouseInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id",@"defaults" : @"default"};
}
@end
