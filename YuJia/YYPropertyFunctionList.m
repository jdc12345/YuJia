//
//  YYPropertyFunctionList.m
//  YuJia
//
//  Created by 万宇 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPropertyFunctionList.h"

@implementation YYPropertyFunctionList
+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    YYPropertyFunctionList *model = [[YYPropertyFunctionList alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
