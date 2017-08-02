//
//  YJHomeSceneCollectionViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/7/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPropertyFunctionList.h"
#import "YJEquipmentListModel.h"

@interface YJHomeSceneCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) YYPropertyFunctionList* functionList;
@property (nonatomic, strong) YJEquipmentListModel* equipmentListModels;//设备模型
@end
