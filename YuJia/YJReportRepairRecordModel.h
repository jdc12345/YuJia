//
//  YJReportRepairRecordModel.h
//  YuJia
//
//  Created by 万宇 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//
//createTimeString   String    报修时间
//personalId      Long    用户ID
//contactTelephone    Long    联系人电话
//contactName       String    联系人姓名
//repairType       Integer     1=水电燃气 2=房屋报修 3=公共设施报修”
//picture          String    图片
//contactAddress       String     地址
//details          String    详情描述
//state           Integer    1=待处理2=处理中 3=已处理 4=已取消”
//processingTimeString.  String    希望处理时间
#import <Foundation/Foundation.h>

@interface YJReportRepairRecordModel : NSObject
@property (nonatomic, copy) NSString *createTimeString;
@property (nonatomic, copy) NSString *personalId;
@property (nonatomic, copy) NSString *contactTelephone;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, assign) NSInteger repairType;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) long info_id;
@property (nonatomic, copy) NSString *processingTimeString;
@end
