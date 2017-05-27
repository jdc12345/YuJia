//
//  MyActiveTableViewCell.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActiveTableViewCell : UITableViewCell
@property(nonatomic,strong)NSString *type;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickForAddBlock)(UIButton *btn);
@end
