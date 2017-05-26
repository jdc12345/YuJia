//
//  YJActivitiesDetailsVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJActivitiesDetailModel.h"

@interface YJActivitiesDetailsVC : UIViewController
@property (nonatomic, strong) YJActivitiesDetailModel *model;//传过来的活动详情
@property(nonatomic,assign)long userId;//当前用户Id
-(void)refrish;
@end
