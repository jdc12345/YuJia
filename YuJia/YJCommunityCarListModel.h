//
//  YJCommunityCarListModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/26.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//"createTimeString": "05-26 10:00",
//"personalId": 10,
//"user_name": "风雪",
//"cnumber": 2,
//"trueName": "",
//"end": "一品",
//"id": 26,
//"isOrders": false,
//"telephone": 12345678907,
//"avatar": "",
//"departureTimeString": "05-26 10:00",
//"cstate": 0,
//"ctype": 2,
//"participateNumber": 0,
//"islike": false,
//"comment": 0,
//"departurePlace": "名流"

#import <Foundation/Foundation.h>

@interface YJCommunityCarListModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *departureTimeString;
@property (nonatomic, copy) NSString *departurePlace;
@property (nonatomic, assign) long personalId;
@property (nonatomic, assign) long cnumber;
@property (nonatomic, assign) long info_id;//和id重名
@property (nonatomic, assign) Boolean isOrders;
@property (nonatomic, assign) long telephone;
@property (nonatomic, assign) long cstate;
@property (nonatomic, assign) Boolean islike;
@property (nonatomic, assign) long ctype;
@property (nonatomic, assign) long participateNumber;
@property (nonatomic, assign) long comment;
@property (nonatomic, assign) long over;
@end
