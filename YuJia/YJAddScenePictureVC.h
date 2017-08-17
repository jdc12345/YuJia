//
//  YJAddScenePictureVC.h
//  YuJia
//
//  Created by 万宇 on 2017/8/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAddScenePictureVC : UIViewController
@property (nonatomic, assign) NSInteger curruntPicNum;//当前选中图片序号
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(NSInteger curruntPicNum);
@end
