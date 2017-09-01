//
//  YJHomeHouseInfoModel.h
//  YuJia
//
//  Created by 万宇 on 2017/8/29.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

//"default": true,是否为常用地址
//|参数名          |类型      |必需  |描述
//|-----          |----     |---- |----
//|token          |String   |Y    |令牌
//|id             |Long     |N    |编号
//|familyName     |String   |N    |家名称
//|createTime     |java.sql.Timestamp|N    |家创建时间
//|address        |String   |N    |家的地址所属省市区县，街道，小区；楼号，几单元，几层，几室；
//|familyState    |Integer  |N    |审核状态"0=家与地址不符合，不能用1=地址符合，正常使用"
//|residentialQuartersId|Long     |N    |小区编号--外键--小区表
//|areaCode       |Long     |N    |地区编码省市区县三级
//|areaName       |String   |N    |地区名称
//|buildingNumber |String   |N    |楼号
//|unitNumber     |String   |N    |单元号
//|roomNumber     |String   |N    |房间号
//|lng            |Double   |N    |经度值
//|lat            |Double   |N    |纬度值
//|ownerName      |String   |N    |业主姓名
//|ownerTelephone |Long     |N    |业主电话
//|city           |String   |N    |城市
//|floor          |String   |N    |楼层
//|residentialQuartersName|String   |N    |小区名称
//|userType       |Integer  |N    |业主身份；0=业主，1=租客，2=访客
#import <Foundation/Foundation.h>

@interface YJHomeHouseInfoModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *createTimeString;
@property (nonatomic, strong) NSString *personalId;
@property (nonatomic, strong) NSString *roomNumber;

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *residentialQuartersId;
@property (nonatomic, strong) NSString *unitNumber;
@property (nonatomic, strong) NSString *residentialQuartersName;

@property (nonatomic, assign) Boolean defaults;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *familyName;

@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *updateTimeString;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *ownerTelephone;

@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSArray *items;
@end
