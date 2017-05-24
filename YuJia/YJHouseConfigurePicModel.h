//
//  YJHouseConfigurePicModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJHouseConfigurePicModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_n;
@property (nonatomic, copy) NSString *icon_sed;
+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
