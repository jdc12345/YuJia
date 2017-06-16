//
//  YJLikeActivitiesTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJActiviesLikeModel.h"

@interface YJLikeActivitiesTVCell : UITableViewCell
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSArray *likeList;
///** block方式监听点击 */点赞跳转需要id
@property (nonatomic, copy) void (^clickAddBlock)(NSString *personalId);
@end
