//
//  YJLifePayAddressModel.h
//  YuJia
//
//  Created by 万宇 on 2017/7/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"roomNumber": "502",
//"city": "涿州市",
//"residentialQuartersId": 0,
//"unitNumber": "5",
//"pid": "",
//"buildingNumber": "2",
//"id": 59,
//"floor": "4",
//"areaCode": "130681",
//"propertyName": "",
//"detailAddress": "名流一品小区2号楼5单元4楼502号"
#import <Foundation/Foundation.h>

@interface YJLifePayAddressModel : NSObject
@property (nonatomic, copy) NSString *detailAddress;//当前用户家庭地址
@property (nonatomic, copy) NSString *city;//城市名称
@property (nonatomic, assign) long info_id;//该条家庭地址记录ID
@property (nonatomic, assign) long residentialQuartersId;//小区ID
@property (nonatomic, copy) NSString *unitNumber;//单元号
@property (nonatomic, copy) NSString *pid;//
@property (nonatomic, copy) NSString *buildingNumber;//楼号
@property (nonatomic, copy) NSString *floor;//层号
@property (nonatomic, copy) NSString *areaCode;//城市编号
@property (nonatomic, copy) NSString *propertyName;//物业名称
@property (nonatomic, copy) NSString *roomNumber;//房间号
@end
