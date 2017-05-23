//
//  YJMonthDetailItemModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/20.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"itemNumber": "df123123",
//"paymentItemId": 2,
//"money": 70,
//"detailHomeId": 0,
#import <Foundation/Foundation.h>

@interface YJMonthDetailItemModel : NSObject
@property (nonatomic, copy) NSString *itemNumber;
@property (nonatomic, assign) long paymentItemId;
@property (nonatomic, assign) long money;
@property (nonatomic, assign) long detailHomeId;
@end
