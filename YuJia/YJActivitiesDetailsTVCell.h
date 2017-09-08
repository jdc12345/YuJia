//
//  YJActivitiesDetailsTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJActivitiesDetailModel.h"

@interface YJActivitiesDetailsTVCell : UITableViewCell
@property(nonatomic,strong)YJActivitiesDetailModel *model;
- (void)configCellWithModel:(YJActivitiesDetailModel *)model indexPath:(NSIndexPath *)indexPath;
@property (nonatomic, copy) void (^iconViewTapgestureBlock)(YJActivitiesDetailModel *model);//点击头像跳转用户个人详情
@end
