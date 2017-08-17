//
//  YJSceneSetVC.h
//  YuJia
//
//  Created by 万宇 on 2017/8/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJSceneDetailModel.h"

@interface YJSceneSetVC : UIViewController
//@property (nonatomic, strong) NSString* sceneName;//传过来的情景名字
//@property (nonatomic, strong) NSArray* equipmentListData;//传过来的房间设备列表
@property (nonatomic, strong) YJSceneDetailModel* sceneModel;//编辑传过来的情景数据模型
@end
