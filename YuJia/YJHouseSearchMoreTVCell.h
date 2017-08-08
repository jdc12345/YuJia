//
//  YJHouseSearchMoreTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/7/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJHouseSearchMoreTVCell : UITableViewCell
@property(nonatomic,assign)long baseTag;//给cell的按钮设置tag
@property(nonatomic,strong)NSDictionary *dic;//给cell的控件赋值
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(NSString *title);
@end
