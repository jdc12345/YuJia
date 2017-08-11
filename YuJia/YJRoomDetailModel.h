//
//  YJRoomDetailModel.h
//  YuJia
//
//  Created by 万宇 on 2017/8/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//"oid": 0,
//"equipmentList": [],
//"pictures": "/static/image/2017525/88c8078b8fba4ba1b1370fec15353f57.jpg",
//"roomName": "卧室2",
//"familyId": 1,
//"id": 11
#import <Foundation/Foundation.h>

@interface YJRoomDetailModel : NSObject
@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, copy) NSArray *equipmentList;
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *pictures;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *oid;
@end
