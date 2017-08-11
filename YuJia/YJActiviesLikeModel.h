//
//  YJActiviesLikeModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/25.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"personalId": 10,
//"avatar": "/static/image/2017517",
//"userName": "风雪"

//司机发起拼车时候参与乘客的model属性
//"createTimeString": "2017-08-10 09:14:27",
//"personalId": 29,
//"telephone": 18335277251,
//"avatar": "/static/image/201789/943c7dc516e647af843cc6867a6d9199.jpg",
//"userName": "",
//"carpoolingId": 81,
//"id": 108
#import <Foundation/Foundation.h>

@interface YJActiviesLikeModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) long personalId;
//司机发起拼车时候参与乘客的model属性
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, assign) long carpoolingId;
@property (nonatomic, assign) long info_id;
@end
