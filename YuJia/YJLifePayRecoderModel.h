//
//  YJLifePayRecoderModel.h
//  YuJia
//
//  Created by 万宇 on 2017/7/28.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"personalId": 10,
//"orderNumber": 2017072711116286,
//"paymentAmount": 200,
//"drNumber": "dianfei1111",
//"paymentInstruction": "您已缴费成功，如有任何问题，清与物业联系",
//"detailHomeId": 12,
//"paymentTimeString": "2017-07-27 17:14:19",
//"paymentMethod": 1,
//"drType": 1,
//"id": 6,
//"propertyId": 10,
//"refundTimeString": "",
//"paymentStatus": 1,
//"refundAmount": 0
//propertyName           String         缴费单位名称
//roomNumber            String        房间号

#import <Foundation/Foundation.h>

@interface YJLifePayRecoderModel : NSObject
@property (nonatomic, copy) NSString *orderNumber;//订单号
@property (nonatomic, assign) long paymentAmount;//缴费金额
@property (nonatomic, assign) long info_id;//当前记录ID
@property (nonatomic, assign) long personalId;//当前用户ID
@property (nonatomic, copy) NSString *drNumber;//表的编号，物业费的时候不显示
@property (nonatomic, copy) NSString *paymentInstruction;//缴费说明
@property (nonatomic, assign) long detailHomeId;//缴费地址ID
@property (nonatomic, assign) NSInteger paymentMethod;//支付方式1=微信支付2=支付宝支付
@property (nonatomic, assign) NSInteger drType;//缴费类型1=电费2=水费3=燃气费4=物业费
@property (nonatomic, copy) NSString *paymentTimeString;//缴费时间
@property (nonatomic, assign) long propertyId;//物业单位ID
@property (nonatomic, copy) NSString *refundTimeString;//退款时间
@property (nonatomic, assign) NSInteger paymentStatus;//状态：1=支付成功2=退款成功
@property (nonatomic, assign) long refundAmount;//退款金额
@property (nonatomic, copy) NSString *propertyName;//缴费单位名称
@property (nonatomic, copy) NSString *roomNumber;//房间号
//为了显示地址加的属性
@property (nonatomic, copy) NSString *detailAddress;//当前用户家庭地址
@end
