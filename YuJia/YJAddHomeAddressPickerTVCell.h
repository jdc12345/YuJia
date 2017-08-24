//
//  YJAddHomeAddressPickerTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/8/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAddHomeAddressPickerTVCell : UITableViewCell
@property(nonatomic,strong)NSString *item;
@property(nonatomic,strong)NSString *imageName;
@property (nonatomic, weak) UILabel* contentLabel;//显示内容label
@property (nonatomic, weak) UIButton* selectBtn;//选择按钮
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickSelectBtnBlock)(NSInteger currentIndex);
@end
