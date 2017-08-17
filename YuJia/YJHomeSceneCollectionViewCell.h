//
//  YJHomeSceneCollectionViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/7/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJSceneDetailModel.h"
#import "YJEquipmentModel.h"

@interface YJHomeSceneCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) YJSceneDetailModel* sceneDetailModel;//场景模型
@property (nonatomic, strong) YJEquipmentModel* equipmentModel;//设备模型(用以添加最后的添加按钮)
@end
