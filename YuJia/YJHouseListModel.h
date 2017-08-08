//
//  YJHouseListModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

//"createTimeString": "2017-08-07 17:14:13",
//"personalId": 10,
//"codeUpperLevel": "130681",
//"rent": 1258,
//"number": 0,
//"cyty": "保定市涿州市百尺竿镇",
//"housingArea": 25,
//"apartmentLayout": "主卧",
//"startTime": null,
//"id": 36,
//"floor": "4",
//"direction": "南",
//"updateTimeString": "",
//"residentialQuarters": "风景洋房小区",
//"telephone": 13526575287,
//"houseAllocation": "；电视；洗衣机",
//"floord": "5",
//"picture": "/static/image/201787/5eba8090df104a40a51fa756bdff3b08.png;/static/image/201787/56bdde90529f43a2bea01314485b1a84.png;",
//"areaCode": "130681",
//"rentalTyoe": 2,
//"paymentMethod": "押一付三",
//"codeUpperTwo": "(null)",
//"endTime": null,
//"contacts": "楞子"

#import <Foundation/Foundation.h>

@interface YJHouseListModel : NSObject
@property (nonatomic, assign) long personalId;
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString * residentialQuarters;
@property (nonatomic, assign) long telephone;
@property (nonatomic, copy) NSString *houseAllocation;
@property (nonatomic, copy) NSString *floord;
@property (nonatomic, copy) NSString * picture;
@property (nonatomic, assign) long rent;
@property (nonatomic, assign) long housingArea;
@property (nonatomic, assign) long rentalTyoe;
@property (nonatomic, assign) long info_id;
@property (nonatomic, copy) NSString *cyty;
@property (nonatomic, copy) NSString *paymentMethod;
@property (nonatomic, copy) NSString * apartmentLayout;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString * direction;
@property (nonatomic, copy) NSString *codeUpperTwo;//城市编码
@property (nonatomic, copy) NSString *areaCode;//街道乡镇编码
@property (nonatomic, copy) NSString * codeUpperLevel;//区县编码

@end
