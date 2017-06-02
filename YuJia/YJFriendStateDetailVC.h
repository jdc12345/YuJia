//
//  YJFriendStateDetailVC.h
//  YuJia
//
//  Created by 万宇 on 2017/5/9.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJFriendNeighborStateModel.h"
#import "BRPlaceholderTextView.h"

@interface YJFriendStateDetailVC : UIViewController
@property(nonatomic,strong)YJFriendNeighborStateModel *model;
//评论
@property(weak, nonatomic)BRPlaceholderTextView *commentField;
@property(nonatomic,assign)long userId;
@property(nonatomic,assign)long stateId;//传过来的状态id
@end
