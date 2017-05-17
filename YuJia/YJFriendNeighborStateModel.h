//
//  YJFriendNeighborStateModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//createTimeString   String    发布的时间
//rname     String      小区名字
//cname    String      分类名称
//avatar    String      头像
//username  String      用户名
//content  String      状态详情
//picture    String      状态图片
//LikeNum  Integer      点赞总数
//commentNum  Integer    评论总数
//ID    Long      状态ID
#import <Foundation/Foundation.h>

@interface YJFriendNeighborStateModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *rname;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) NSInteger LikeNum;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) long ID;
@end
