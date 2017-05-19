//
//  YJFriendStateTableViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/9.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJFriendNeighborStateModel.h"

@interface YJFriendStateTableViewCell : UITableViewCell
@property(nonatomic,strong)YJFriendNeighborStateModel *model;
/** block方式监听点击 */
@property (nonatomic, copy) void (^commentBtnBlock)(YJFriendNeighborStateModel *model);
@end
