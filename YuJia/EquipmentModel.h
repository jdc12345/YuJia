//
//  EquipmentModel.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *iconId;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *toExtendState;
@property (nonatomic, strong) NSString *familyId;

- (NSDictionary *)properties_aps;

@end

