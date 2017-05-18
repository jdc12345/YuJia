//
//  PersonalModel.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

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

@property (nonatomic, strong) NSString *weixin;
@end
