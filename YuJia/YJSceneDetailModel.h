//
//  YJSceneDetailModel.h
//  YuJia
//
//  Created by 万宇 on 2017/8/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"sceneDistance": 0,
//"repeatMode": "",
//"sceneName": "睡觉",
//"sceneTime": "",
//"oid": 0,
//"sceneIcon": 0,
//"equipmentList": [],
//"familyId": 1,
//"id": 31,
//"sceneModel": 1,
//"sceneState": 0
#import <Foundation/Foundation.h>

@interface YJSceneDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *sceneName;
@property (nonatomic, strong) NSString *sceneIcon;
@property (nonatomic, copy) NSArray *equipmentList;
@property (nonatomic, strong) NSString *repeatMode;
@property (nonatomic, strong) NSString *sceneState;
@property (nonatomic, strong) NSString *sceneModel;

@property (nonatomic, strong) NSString *sceneDistance;
@property (nonatomic, strong) NSString *sceneTime;
@property (nonatomic, strong) NSString *sceneTimeString;
@end
