//
//  YYCircleTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYCircleTableViewCell.h"
#import <Masonry.h>
#import "UIColor+colorValues.h"
@interface YYCircleTableViewCell ()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UIButton* btn;

@end
@implementation YYCircleTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
-(void)setModel:(YYPropertyFunctionList *)model{
    _model = model;
    self.iconView.image = [UIImage imageNamed:model.icon];
    self.nameLabel.text = model.name;
}
- (void)setupUI
{
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建子控件
    UIImageView* iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"friends_circle"];
    [self.contentView addSubview:iconView];
    
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.text = @"友邻圈";
    [self.contentView addSubview:nameLabel];
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    // 自动布局
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(10*kiphone6);
        make.width.height.offset(23*kiphone6);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(iconView.mas_right).offset(5*kiphone6);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10*kiphone6);
    }];
    self.iconView = iconView;
    self.nameLabel = nameLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
