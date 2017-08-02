//
//  YJHomepageTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/8/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPropertyFunctionList.h"

@interface YJHomepageTVCell : UITableViewCell
@property (nonatomic, strong) YYPropertyFunctionList* functionList;//情景数据模型
@property (nonatomic, strong) NSString* roomName;//房间名字
@property (nonatomic, weak) UILabel* itemLabel;
@end
