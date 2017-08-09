//
//  YJSearchHouseDetailResultModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"address": "涿州市范阳中路314号",
//"rname": "名流一品小区",
//"city": "涿州市",
//"codeUpperLevel": "130681",
//"areaCode": "130681",
//"codeUpperTwo": "130600",
//"id": 1,
//"propertyId": 1
#import <Foundation/Foundation.h>

@interface YJSearchHouseDetailResultModel : NSObject
@property (nonatomic, assign) long info_id;
@property (nonatomic, copy) NSString *rname;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) long propertyId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *codeUpperLevel;
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *codeUpperTwo;
@end
