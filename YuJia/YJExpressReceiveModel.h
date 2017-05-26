//
//  YJExpressReceiveModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//"personalId": 10,
//"signTimeString": "2017-05-23 16:51:55",
//"personalType": 1,
//"ename": "顺丰快递",
//"expressNumber": "sf1243242",
//"propertyType": 1,
//"id": 4,
//"cabinet": "名流一品东门",
//"deliveryCode": "123123",
//"expressId": 1

#import <Foundation/Foundation.h>

@interface YJExpressReceiveModel : NSObject
@property (nonatomic, assign) long personalId;
@property (nonatomic, copy) NSString *signTimeString;
@property (nonatomic, assign) int personalType;
@property (nonatomic, copy) NSString *ename;
@property (nonatomic, copy) NSString *expressNumber;
@property (nonatomic, assign) int propertyType;
@property (nonatomic, assign) long info_id;
@property (nonatomic, copy) NSString *cabinet;
@property (nonatomic, copy) NSString *deliveryCode;
@property (nonatomic, assign) long expressId;
@end
