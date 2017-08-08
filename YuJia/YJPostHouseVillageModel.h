//
//  YJPostHouseVillageModel.h
//  YuJia
//
//  Created by 万宇 on 2017/8/7.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "",
//"address": "涿州市范阳中路314号",
//"updateTimeString": "",
//"rname": "名流一品小区",
//"city": "涿州市",
//"areaCode": "130681",
//"id": 1,
//"propertyId": 1
#import <Foundation/Foundation.h>

@interface YJPostHouseVillageModel : NSObject
@property (nonatomic, copy) NSString *address;//小区地址
@property (nonatomic, copy) NSString *city;//城市名称
@property (nonatomic, assign) long info_id;//该条小区记录ID
@property (nonatomic, assign) long propertyId;//物业单位ID
@property (nonatomic, copy) NSString *createTimeString;//
@property (nonatomic, copy) NSString *updateTimeString;//
@property (nonatomic, copy) NSString *rname;//小区名称
@property (nonatomic, copy) NSString *areaCode;//城市编号

@end
