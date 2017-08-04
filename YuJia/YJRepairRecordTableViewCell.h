//
//  YJRepairRecordTableViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJReportRepairRecordModel.h"

@interface YJRepairRecordTableViewCell : UITableViewCell
@property(nonatomic,strong)YJReportRepairRecordModel *model;
@property(nonatomic,copy)void (^clickBtnBlock)();//cell中的取消按钮点击事件
@property(nonatomic,strong)NSMutableArray *urlStrs;//用来放大图片的数据源

@property (nonatomic, assign) CGFloat cellHeight;//cell的行高属性
@end
