//
//  YJHomeAddressTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/8/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJHomeHouseInfoModel.h"

@interface YJHomeAddressTVCell : UITableViewCell
@property (nonatomic, weak) UIButton* selectBtn;
@property (nonatomic, weak) UIButton* editBtn;
@property (nonatomic, weak) UIButton* deleteBtn;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *teleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) YJHomeHouseInfoModel *houseModle;
@property (nonatomic,copy) void(^selectedBlock)(YJHomeHouseInfoModel* houseModel);//切换默认地址
@property (nonatomic,copy) void(^editBlock)(YJHomeHouseInfoModel* houseModel);//编辑地址
@property (nonatomic,copy) void(^deleBlock)(YJHomeHouseInfoModel* houseModel);//删除地址
@end
