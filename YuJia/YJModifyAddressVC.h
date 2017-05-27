//
//  YJModifyAddressVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPropertyDetailAddressModel.h"
@interface YJModifyAddressVC : UIViewController
@property(nonatomic,strong)NSMutableArray *addresses;
@property(nonatomic,strong)YJPropertyDetailAddressModel *addressModel;//修改回来时候更新用
@end
