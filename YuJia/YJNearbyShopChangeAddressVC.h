//
//  YJNearbyShopChangeAddressVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJNearbyShopChangeAddressVC : UIViewController
@property(nonatomic,assign)NSInteger searchCayegory;//1.根据小区等房源具体信息搜索 2.直接搜索城市
@property(nonatomic,assign)NSString *city;//搜索小区传过来的已显示要搜索的城市
@property (nonatomic,copy)  void(^popVCBlock)(NSString *selectArea);//搜索小区需要回传选中小区
@property (nonatomic,copy)  void(^presentVCBlock)();//重新定位
@end
