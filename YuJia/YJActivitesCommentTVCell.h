//
//  YJActivitesCommentTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJActivitesCommentTVCell : UITableViewCell
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickForReplyBlock)(NSString *name,long coverPersonalId);//参数1指被回复人的名字，参数2指被回复人的id(0指的是直接评论)
@property(nonatomic,strong) NSArray *commentList;
@end
