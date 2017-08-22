//
//  YJPersonalModel.h
//  YuJia
//
//  Created by 万宇 on 2017/8/21.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJPersonalModel : NSObject
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
