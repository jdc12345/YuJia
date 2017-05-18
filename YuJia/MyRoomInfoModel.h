//
//  MyRoomInfoModel.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRoomInfoModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *areaCode;



@property (nonatomic, strong) NSString *userType;

@property (nonatomic, strong) NSString *ownerTelephone;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *areaName;


@property (nonatomic, copy) NSArray *equipmentList;
@end
