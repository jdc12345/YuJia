//
//  YYPropertyFunctionList.h
//  YuJia
//
//  Created by 万宇 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYPropertyFunctionList : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* icon;
+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
