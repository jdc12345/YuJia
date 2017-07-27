//
//  YJEditNumberVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJLifePayAddressModel.h"

@interface YJEditNumberVC : UIViewController
@property(nonatomic,strong)NSString *payItem;//用来判断是要修改编号时候
/** block方式监听点击 *///回传地址
@property (nonatomic, copy) void (^clickBtnBlock)(YJLifePayAddressModel *model);
@property (nonatomic, strong)YJLifePayAddressModel *currentAddressModel;//当前选中地址
@end
