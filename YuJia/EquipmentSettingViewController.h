//
//  EquipmentSettingViewController.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SightModel.h"
#import "YJEquipmentModel.h"

@interface EquipmentSettingViewController : UIViewController
@property (nonatomic, strong) NSString *equipmentName;
@property (nonatomic, strong) NSString *sightName;
@property (nonatomic, strong) SightModel *sightModel;
@property (nonatomic, strong) YJEquipmentModel *eqipmentModel;
@end
