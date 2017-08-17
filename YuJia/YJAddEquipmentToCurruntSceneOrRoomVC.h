//
//  YJAddEquipmentToCurruntSceneOrRoomVC.h
//  YuJia
//
//  Created by 万宇 on 2017/8/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJEquipmentModel.h"

@interface YJAddEquipmentToCurruntSceneOrRoomVC : UIViewController
@property (nonatomic, copy) void(^itemClick)(YJEquipmentModel  *index);//选中的设备用来回传父控制器
@property (nonatomic, copy) NSArray *equipmentList;//传过来的已有设备
@end
