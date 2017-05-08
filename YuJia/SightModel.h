//
//  SightModel.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SightModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *sceneName;

@property (nonatomic, copy) NSArray *equipmentList;

@property (nonatomic, strong) NSString *sceneModel;

@property (nonatomic, strong) NSString *sceneDistance;
@property (nonatomic, strong) NSString *sceneTime;
@property (nonatomic, strong) NSString *sceneTimeString;
@end
