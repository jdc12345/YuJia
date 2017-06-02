//
//  YJCommunityCarNoticesCenterTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityCarNoticesCenterTVCell.h"
@interface YJCommunityCarNoticesCenterTVCell ()

/**
 *  聊天内容
 */
@property (nonatomic, weak) UILabel* chatLabel;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel* timeLabel;

@end
@implementation YJCommunityCarNoticesCenterTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setModel:(YJNoticeListModel *)model{
    _model = model;
    self.timeLabel.text = model.createTimeString;
    self.chatLabel.text = model.content;
}
// 初始化UI
- (void)setupUI
{
    // 初始化子控件
    
    // 时间的label
    UILabel* timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"昨天";
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLabel];
    
    // 头像
    UIImageView* avatarView = [[UIImageView alloc] init];
    avatarView.image = [UIImage imageNamed:@"Service"];
    [self.contentView addSubview:avatarView];
    
    // 聊天背景
    UIImageView* backgroundView = [[UIImageView alloc] init];
    backgroundView.image = [UIImage imageNamed:@"Dialog_white.left"];
    [self.contentView addSubview:backgroundView];
    
    //    UIView* backgroundView = [[UIView alloc] init];
    //    backgroundView.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    //    //    backgroundView.image = [UIImage imageNamed:@"Dialog_green.right"];
    //    [self.contentView addSubview:backgroundView];
    
    // 聊天内容
    UILabel* chatLabel = [[UILabel alloc] init];
    chatLabel.textColor = [UIColor darkGrayColor];
    chatLabel.text = @"Tian您好，司机张接收了您从名流一品到风景公园的拼车。请您尽快与司机沟通。                     电话：18611439783";
    chatLabel.numberOfLines = 0;
    chatLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:chatLabel];
    
    // 自动布局
    // 时间
    [timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.offset(4);
        make.centerX.equalTo(self.contentView);
    }];
    
    // 头像
    [avatarView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(8);
        make.left.offset(8);
        make.width.height.offset(40);
    }];
    
    // 聊天内容
    [chatLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(avatarView).offset(8);
        make.left.equalTo(avatarView.mas_right).offset(20);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    // 聊天背景
    [backgroundView mas_makeConstraints:^(MASConstraintMaker* make) {
        // 貌似不能直接用offset设置不好使.....
        // 使用edgeInset
        make.edges.equalTo(chatLabel).mas_offset(UIEdgeInsetsMake(-8, -18, -8, -6));
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    // 赋值给全局方便设置内容
    self.timeLabel = timeLabel;
    self.chatLabel = chatLabel;
}

@end
