//
//  YJLifepaymentVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJLifePayAddressModel.h"

@interface YJLifepaymentVC : UIViewController
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(YJLifePayAddressModel *model);
@property (nonatomic, strong)YJLifePayAddressModel *currentAddressModel;//当前选中地址
@property(nonatomic,assign)BOOL isBill;//是否有地址
@end
