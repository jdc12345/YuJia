//
//  YJSelfReplyTableViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJSelfReplyTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *model;
@property (nonatomic, weak) UIImageView* iconView;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(NSString *name);
@end