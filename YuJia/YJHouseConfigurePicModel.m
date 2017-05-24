//
//  YJHouseConfigurePicModel.m
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHouseConfigurePicModel.h"

@implementation YJHouseConfigurePicModel
+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    YJHouseConfigurePicModel *model = [[YJHouseConfigurePicModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
