//
//  YJActiviesAddPersonModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/25.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"coverPersonalavatar": "",
//"personalId": 10,
//"avatar": "",
//"coverPersonalName": "风雪",
//"userName": "刘海",
//"content": "再来一个",
//"coverPersonalId": 10,
//"commentType": 1
#import <Foundation/Foundation.h>

@interface YJActiviesAddPersonModel : NSObject
@property (nonatomic, copy) NSString *coverPersonalavatar;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *coverPersonalName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long personalId;
@property (nonatomic, assign) long coverPersonalId;
@property (nonatomic, assign) long commentType;
@end
