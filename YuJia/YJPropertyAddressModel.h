//
//  YJPropertyAddressModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"city": "涿州市",
//"residentialQuartersId": 3,
//"residentialQuartersName": "名流一品小区",
//"id": 4,
//"address": "名流一品小区1号楼一单元1楼305号"
#import <Foundation/Foundation.h>

@interface YJPropertyAddressModel : NSObject
@property (nonatomic, copy) NSString *address;//当前用户家庭地址
@property (nonatomic, copy) NSString *city;//城市名称
@property (nonatomic, assign) long info_id;//该条家庭地址记录ID
@property (nonatomic, assign) long residentialQuartersId;//小区ID
@property (nonatomic, copy) NSString *residentialQuartersName;//小区名字

@end
