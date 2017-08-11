//
//  YJEquipmentModel.h
//  YuJia
//
//  Created by 万宇 on 2017/8/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"iconId": 2,
//"serialNumber": "1",
//"extendState": "",
//"roomId": 2,
//"familyId": 1,
//"sceneTaskId": 156,
//"toState": 0,
//"toExtendState": "",
//"name": "灯灯",
//"iconUrl": "",
//"id": 7,
//"state": 0
#import <Foundation/Foundation.h>

@interface YJEquipmentModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *iconId;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *toExtendState;
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *sceneTaskId;
- (NSDictionary *)properties_aps;
@end
