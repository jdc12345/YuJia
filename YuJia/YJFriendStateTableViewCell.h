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
@property(nonatomic,strong)NSMutableArray *urlStrs;

@property(nonatomic,strong)YJFriendNeighborStateModel *model;
/** block方式监听点击 */
@property (nonatomic, copy) void (^commentBtnBlock)(YJFriendNeighborStateModel *model);//跳转详情页面进行评论
- (void)configCellWithModel:(YJFriendNeighborStateModel *)model indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,assign)BOOL isDetailCell;//判断是否是详情页面的cell
@property (nonatomic, copy) void (^detailCommentBtnBlock)(YJFriendNeighborStateModel *model);//详情页面的评论按钮点击事件

@property (nonatomic, assign) CGFloat cellHeight;//cell的行高
@property (nonatomic, copy) void (^iconViewTapgestureBlock)(YJFriendNeighborStateModel *model);//点击头像跳转用户个人详情
@end
