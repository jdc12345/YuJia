//
//  MyCircleTableViewCell.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJFriendNeighborStateModel.h"
@interface MyCircleTableViewCell : UITableViewCell
@property(nonatomic,strong)YJFriendNeighborStateModel *model;
/** block方式监听点击 */
@property (nonatomic, copy) void (^commentBtnBlock)(YJFriendNeighborStateModel *model);
@property (nonatomic, assign) CGFloat cellHeight;//cell的行高
@end
