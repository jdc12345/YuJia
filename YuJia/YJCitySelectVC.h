//
//  YJCitySelectVC.h
//  YuJia
//
//  Created by 万宇 on 2017/7/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJCitySelectVC : UIViewController
@property(nonatomic,strong)NSString *cityName;//定位传过来的城市
@property (nonatomic,copy)  void(^popVCBlock)(NSString *selectCity);//搜索城市需要回传选中城市

@end
