//
//  YJLifePayInfiModel.h
//  YuJia
//
//  Created by 万宇 on 2017/7/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "",
//"personalId": 0,
//"roomNumber": "",
//"city": "",
//"residentialQuartersId": 0,
//"unitNumber": "",
//"pid": "1",
//"cretetimeString": "",
//"ownerName": "Erf",
//"rqtelephone": 0,
//"buildingNumber": "",
//"id": 0,
//"floor": "",
//"cretetime": null,
//"updateTimeString": "",
//"residentialQuarters": "",
//"areaCode": "",
//"propertyName": "涿州市盛气凌人物业管理有限公司",
//"detailAddress": "风景洋房小区3号楼2单元3楼302号"
#import <Foundation/Foundation.h>

@interface YJLifePayInfiModel : NSObject
@property (nonatomic, copy) NSString *ownerName;//户名
@property (nonatomic, copy) NSString *propertyName;//缴费单位名称
@property (nonatomic, assign) long info_id;//
@property (nonatomic, assign) long pid;//
@property (nonatomic, copy) NSString *detailAddress;//缴费地址
//下一级页面添加的属性
@property (nonatomic, copy) NSString *customerNum;//客户编号
@property (nonatomic, copy) NSString *payType;//缴费类型

@end
