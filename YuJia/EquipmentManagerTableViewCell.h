//
//  EquipmentManagerTableViewCell.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentManagerTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, assign) BOOL isSelecting;//判断是否正在选择设备
@property (nonatomic, assign) BOOL isAllSelected;//判断是否全选
//- (void)cellMode:(BOOL)isSwitch;
@end
