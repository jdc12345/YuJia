//
//  YJPayItemModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJPayItemModel : NSObject
@property (nonatomic, copy) NSString* icon;
@property (nonatomic, copy) NSString* item;
@property (nonatomic, copy) NSString* number;
+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
