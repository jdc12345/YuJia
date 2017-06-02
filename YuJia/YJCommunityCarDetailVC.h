//
//  YJCommunityCarDetailVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJCommunityCarListModel.h"

@interface YJCommunityCarDetailVC : UIViewController
@property(nonatomic,strong)YJCommunityCarListModel *model;
@property(nonatomic,assign)long userId;//当前用户Id
@property(nonatomic,assign)long carpoolingId;//拼车活动的id
-(void)refrish;
@end
