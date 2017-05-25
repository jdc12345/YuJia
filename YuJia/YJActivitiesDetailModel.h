//
//  YJActivitiesDetailModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//createTimeString   String      活动发布时间
//personalId      Long      活动发布人的ID
//user_name              String      活动发布人的昵称
//avatar      String      活动发布人头像
//activityTheme    String      活动主题
//activityTheme     String    活动内容
//activityAddress     String    活动地点
//starttimeString      String     活动开始时间
//endtimeString      String    活动结束时间
//joined       boolean              判断当前用户是否加入过
//islike                boolean    判断用户是否点击过感兴趣
//activityNumber    Integer    活动人数
//participateNumber     Integer    实时参与人数
//activitypictureId    Long       活动图片的ID
//activityTelephone.      Long      l联系人电话
//id         Long     该条记录的ID
//likeNum      Integer     感兴趣总数
//comment          Integer     评论总数
//userid        Long       当前用户的ID

#import <Foundation/Foundation.h>

@interface YJActivitiesDetailModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *activityTheme;
@property (nonatomic, copy) NSString *activityContent;
@property (nonatomic, copy) NSString *activityAddress;
@property (nonatomic, copy) NSString *starttimeString;
@property (nonatomic, copy) NSString *endtimeString;
@property (nonatomic, assign) long personalId;
@property (nonatomic, assign) long activitypictureId;
@property (nonatomic, assign) long activityTelephone;
@property (nonatomic, assign) long info_id;//和id重名
@property (nonatomic, assign) long userid;
@property (nonatomic, assign) Boolean joined;
@property (nonatomic, assign) Boolean islike;
@property (nonatomic, assign) NSInteger activityNumber;
@property (nonatomic, assign) NSInteger participateNumber;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger comment;
@property (nonatomic, assign) NSInteger over;
@end
