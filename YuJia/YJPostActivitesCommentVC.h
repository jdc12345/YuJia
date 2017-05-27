//
//  YJPostActivitesCommentVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/13.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJActivitiesDetailModel.h"
#import "YJCommunityCarListModel.h"

@interface YJPostActivitesCommentVC : UIViewController
@property(nonatomic,strong)NSString *replyType;//回复人类型
@property (nonatomic, strong) YJActivitiesDetailModel *model;//传过来的社区活动详情
@property(nonatomic,assign)long userId;//当前用户Id
@property(nonatomic,assign)long coverPersonalId;//被回复人的Id
@property(nonatomic,strong)YJCommunityCarListModel *carModel;//传过来的拼车活动详情
@end
