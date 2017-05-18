//
//  YJFriendStateLikeModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "2017-05-18 17:07:55",
//"personalId": 10,当前用户Id
//"updateTimeString": "",
//"stateId": 37,
//"avatar": "",
//"userName": "风雪",
//"id": 65,点赞记录的id
//"upVoteType": 2  2是状态1是社区活动

#import <Foundation/Foundation.h>

@interface YJFriendStateLikeModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *updateTimeString;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) long personalId;
@property (nonatomic, assign) long stateId;
@property (nonatomic, assign) long info_id;//和id重名
@property (nonatomic, assign) long upVoteType;
@end
