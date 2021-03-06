//
//  YYFunctionCollectionViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYFunctionCollectionViewCell.h"
#import <Masonry.h>
@interface YYFunctionCollectionViewCell ()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;

@end
@implementation YYFunctionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (void)setFunctionList:(YYPropertyFunctionList*)functionList
{
    _functionList = functionList;
    // 把数据放在控件上
    self.iconView.image = [UIImage imageNamed:functionList.icon];
    self.nameLabel.text = functionList.name;
}

- (void)setupUI
{
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建子控件
    UIImageView* iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"housekeeping"];
    [self.contentView addSubview:iconView];
//    CALayer *layer = [iconView layer];
//    layer.shadowOffset = CGSizeMake(0, 3);
//    layer.shadowRadius = 5.0;
//    layer.shadowColor = [UIColor blackColor].CGColor;
//    layer.shadowOpacity = 0.8;
    
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    nameLabel.text = @"家政服务";
    [self.contentView addSubview:nameLabel];
    
    // 自动布局
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.equalTo(self.contentView);
        make.top.offset(31*kiphone6);
        make.width.height.offset(47*kiphone6);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(iconView.mas_bottom).offset(10*kiphone6);
        make.centerX.equalTo(iconView);
    }];
    
    self.iconView = iconView;
    self.nameLabel = nameLabel;
}

@end
