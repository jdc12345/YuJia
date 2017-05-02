//
//  YYPropertyItemModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYPropertyItemModel : NSObject
@property (nonatomic, copy) NSString* item;
@property (nonatomic, copy) NSString* event;
+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
