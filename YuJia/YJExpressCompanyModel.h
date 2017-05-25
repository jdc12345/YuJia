//
//  YJExpressCompanyModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"telephone": 95338,
//"expressName": "顺丰快递",
//"logo": "",
//"id": 0
#import <Foundation/Foundation.h>

@interface YJExpressCompanyModel : NSObject
@property (nonatomic, copy) NSString *expressName;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) long telephone;
@property (nonatomic, assign) long info_id;
@end
