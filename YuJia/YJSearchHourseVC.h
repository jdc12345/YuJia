//
//  YJSearchHourseVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJSearchHourseVC : UIViewController
@property(nonatomic,assign)NSInteger searchCayegory;//1.根据小区等房源具体信息搜索 2.直接搜索城市
@property(nonatomic,assign)NSString *city;//搜索小区传过来的已显示要搜索的城市
@property (nonatomic,copy)  void(^popVCBlock)(NSString *selectCity);//搜索城市需要回传选中城市
@property(nonatomic,strong)NSString *areaCode;//乡镇一级编码没有，传名字
@property(nonatomic,strong)NSString *codeUpperLevel;//县级市，县，区一级编码
@property(nonatomic,strong)NSString *codeUpperTwo;//市一级编码
@end
