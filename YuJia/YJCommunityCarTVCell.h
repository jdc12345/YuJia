//
//  YJCommunityCarTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJCommunityCarTVCell : UITableViewCell
@property(nonatomic,strong)NSString *type;
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickForAddBlock)(UIButton *btn);
@end
