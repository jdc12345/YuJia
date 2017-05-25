//
//  YJBussinessServeDetailModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//menulist          菜单集合
//businessId    Long      商家ID
//picture    String      菜单图片
//productName  String      商品名称
//price    Double      商品价格
#import <Foundation/Foundation.h>

@interface YJBussinessServeDetailModel : NSObject
@property (nonatomic, assign) long businessId;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) double price;

@end
