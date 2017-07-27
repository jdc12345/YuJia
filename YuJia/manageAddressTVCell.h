//
//  manageAddressTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/7/25.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YJPropertyAddressModel.h"
#import "YJLifePayAddressModel.h"

@interface manageAddressTVCell : UITableViewCell
@property (nonatomic, weak) UIView* backView;//选中cell时候需要改变边框颜色
@property (nonatomic, strong) YJLifePayAddressModel *model;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(NSInteger tag,YJLifePayAddressModel *model);
@property (nonatomic, weak) UILabel* addressLabel;
@end
