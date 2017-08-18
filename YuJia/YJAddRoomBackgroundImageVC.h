//
//  YJAddRoomBackgroundImageVC.h
//  YuJia
//
//  Created by 万宇 on 2017/8/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAddRoomBackgroundImageVC : UIViewController
@property (nonatomic, copy) void(^itemClick)(UIImage  *selectImage,NSInteger defaultImageNum);//选中的图片用来回传父控制器
@end
