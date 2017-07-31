//
//  YJEquipmentListModel.m
//  YuJia
//
//  Created by 万宇 on 2017/7/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJEquipmentListModel.h"

@implementation YJEquipmentListModel
+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    YJEquipmentListModel *model = [[YJEquipmentListModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
