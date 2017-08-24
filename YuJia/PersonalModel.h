//
//  PersonalModel.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//|id             |Long      |Y    |编号
//|userMame       |String    |N    |用户名、昵称
//|trueName       |String    |N    |用户姓名
//|gender         |Integer   |N    |性别1=男，2=女
//|telephone      |Long      |Y    |手机号码
//|avatar         |String    |N    |头像引用路径
//|password       |String    |Y    |密码
//|idCard         |String    |N    |身份证号
//|weixin         |String    |N    |微信号
//|qq             |String    |N    |QQ号可能使用邮箱
//|email          |String    |N    |电子邮箱
//|createTime     |java.sql.Timestamp|Y    |注册时间
//|authentication |Integer   |Y    |认证状态0=待认证，1=认证通过
//|familyId       |Long      |N    |家庭编号一个人只有一个家的情况，多个的话代表当前选中的或所处的家。
//|userType       |Integer   |Y    |成员类型0=家庭成员1=租客2=访客
#import <Foundation/Foundation.h>

@interface PersonalModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *authentication;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *qq;

@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *trueName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *comment;

@property (nonatomic, strong) NSString *weixin;
@property (nonatomic, strong) NSString *myFamilyId;

// 权限
@property (nonatomic, strong) NSString *pmsnCtrlAdd;
@property (nonatomic, strong) NSString *pmsnCtrlDel;
@property (nonatomic, strong) NSString *pmsnCtrlDevice;
@property (nonatomic, strong) NSString *pmsnCtrlDoor;



@end
