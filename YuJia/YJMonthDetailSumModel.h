//
//  YJMonthDetailSumModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/20.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"itemNumber": "",
//"paymentItemId": 0,
//"money": 0,
//"detailHomeId": 0,
//"moneySum": 110,
//"time": "2017-2",
//"items": []
#import <Foundation/Foundation.h>
#import "YJMonthDetailItemModel.h"

@interface YJMonthDetailSumModel : NSObject
@property (nonatomic, copy) NSString *itemNumber;
@property (nonatomic, assign) long paymentItemId;
@property (nonatomic, assign) long money;
@property (nonatomic, assign) long detailHomeId;
@property (nonatomic, assign) long moneySum;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray<YJMonthDetailItemModel*> *items;
@end
