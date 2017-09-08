//
//  YJCommunityActivitiesTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJActivitiesDetailModel.h"

@interface YJCommunityActivitiesTVCell : UITableViewCell
@property(nonatomic,strong)YJActivitiesDetailModel *model;
@property (nonatomic, copy) void (^iconViewTapgestureBlock)(YJActivitiesDetailModel *model);//点击头像跳转用户个人详情

@end
