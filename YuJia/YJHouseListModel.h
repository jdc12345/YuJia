//
//  YJHouseListModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "2017-05-24 15:17:37",
//"personalId": 10,
//"updateTimeString": "",
//"residentialQuarters": "名流一品小区",
//"telephone": 18928293838,
//"houseAllocation": "电视；冰箱；洗衣机；",
//"floord": "6",
//"rent": 4800,
//"picture": "",
//"cyty": "涿州",
//"housingArea": 120,
//"rentalTyoe": 1,
//"paymentMethod": "月付",
//"apartmentLayout": "3室2厅1厨一卫",
//"id": 1,
//"floor": "2",
//"contacts": "刘先生",
//"direction": "坐西向东"


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

@end
