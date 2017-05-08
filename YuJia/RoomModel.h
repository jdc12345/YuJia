//
//  RoomModel.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, copy) NSArray *equipmentList;
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *pictures;
@property (nonatomic, strong) NSString *roomName;
@end
