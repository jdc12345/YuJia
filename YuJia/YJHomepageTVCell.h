//
//  YJHomepageTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/8/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YYPropertyFunctionList.h"
#import "YJSceneDetailModel.h"
#import "YJRoomDetailModel.h"

@interface YJHomepageTVCell : UITableViewCell
@property (nonatomic, strong) YJSceneDetailModel* sceneDetailModel;//情景数据模型
@property (nonatomic, strong) YJRoomDetailModel* roomDetailModel;//房间数据模型
@property (nonatomic, weak) UILabel* itemLabel;
@end
