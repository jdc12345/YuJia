//
//  YJBussinessDetailModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

//average    Double      人均消费
//address    String      商家地址
//star      int      星级
//businessName  String      商家名称
//telephone    String      商家电话
//picture    String      商家图片
//businessType  int      商家类型
//contacts    String      商家联系人


#import <Foundation/Foundation.h>

@interface YJBussinessDetailModel : NSObject
@property (nonatomic, assign) double average;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) int star;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) int businessType;
@property (nonatomic, copy) NSString *contacts;

@end
