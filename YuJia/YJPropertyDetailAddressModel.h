//
//  YJPropertyDetailAddressModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/26.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//personalId    Long      用户ID
//roomNumber  String      房间号
//city      String      城市
//residentialQuarters  String      小区名称
//unitNumber    String       单元号
//cretetimeString   String      添加时间
//ownerName      String      业主姓名
//rqtelephone      Long      业主电话
//buildingNumber    String      小区楼号
//detailAddress   String      地址
//id        Long      当前地址的ID
//floor      String      楼层
#import <Foundation/Foundation.h>

@interface YJPropertyDetailAddressModel : NSObject
@property (nonatomic, copy) NSString *roomNumber;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *residentialQuarters;
@property (nonatomic, copy) NSString *unitNumber;
@property (nonatomic, copy) NSString *cretetimeString;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *buildingNumber;
@property (nonatomic, copy) NSString *detailAddress;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, assign) long personalId;
@property (nonatomic, assign) long rqtelephone;
@property (nonatomic, assign) long info_id;
@property (nonatomic, copy) NSString *areaCode;//城市id
@end
