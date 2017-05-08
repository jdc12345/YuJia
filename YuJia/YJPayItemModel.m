//
//  YJPayItemModel.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPayItemModel.h"

@implementation YJPayItemModel
+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    YJPayItemModel *model = [[YJPayItemModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
