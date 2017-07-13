//
//  YJSelfReplyTableViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJFriendStateCommentModel.h"
#import "YJActiviesAddPersonModel.h"

@interface YJSelfReplyTableViewCell : UITableViewCell
@property (nonatomic, strong) YJFriendStateCommentModel *model;
@property (nonatomic, strong) YJActiviesAddPersonModel *activiesModel;//活动model，可以考虑用友邻圈的model替代
//@property (nonatomic, weak) UIImageView* iconView;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(NSString *name);
- (void)configCellWithModel:(YJFriendStateCommentModel *)model;//计算友邻圈评论行高
-(void)configActiviesCellWithModel:(YJActiviesAddPersonModel *)model;//计算社区活动评论行高
@end
