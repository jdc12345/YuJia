//
//  YJFriendStateCommentModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.

//"coverPersonalavatar": "",  被回复人的头像
//"createTimeString": "2017-05-15 14:29:36",
//"personalId": 1,
//"updateTimeString": "",
//"stateId": 1,
//"avatar": "1",
//"coverPersonalName": "",
//"userMame": "10",
//"content": "111",
//"coverPersonalId": 0,被回复人的id
//"commentType": 2,
//"id": 1  当前评论记录的id

#import <Foundation/Foundation.h>

@interface YJFriendStateCommentModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *coverPersonalName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *coverPersonalavatar;
@property (nonatomic, assign) long personalId;
@property (nonatomic, assign) long stateId;
@property (nonatomic, assign) long coverPersonalId;
@property (nonatomic, assign) long info_id;//和id重名
@property (nonatomic, assign) long commentType;

@end
