//
//  YJNoticeListModel.h
//  YuJia
//
//  Created by 万宇 on 2017/6/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"createTimeString": "2017-06-01 18:34:40",
//"msgType": 11,
//"targetId": 10,
//"isRead": false,
//"avatar": "/static/image/201761/b044f4b2804f4cbbbe78bc3f4eccab4a.jpg",
//"title": "有人赞了您发布的状态",
//"fromId": 28,
//"content": "亲，海中一条龙赞了你发布的状态哦",
//"familyId": 0,
//"referId": 54,
//"id": 72,
//"operation": 0
#import <Foundation/Foundation.h>

@interface YJNoticeListModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long msgType;
@property (nonatomic, assign) long targetId;
@property (nonatomic, assign) long info_id;//和id重名
@property (nonatomic, assign) Boolean isRead;
@property (nonatomic, assign) long fromId;
@property (nonatomic, assign) long familyId;
@property (nonatomic, assign) long referId;
@property (nonatomic, assign) long operation;

@end
