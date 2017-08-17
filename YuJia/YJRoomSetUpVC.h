//
//  YJRoomSetUpVC.h
//  YuJia
//
//  Created by 万宇 on 2017/8/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJRoomDetailModel.h"

@interface YJRoomSetUpVC : UIViewController
//@property (nonatomic, strong) NSString* roomName;//传过来的房间名字
//@property (nonatomic, strong) NSArray* equipmentListData;//传过来的房间设备列表
@property (nonatomic, strong) YJRoomDetailModel* roomModel;//编辑传过来的房间数据模型
@end
