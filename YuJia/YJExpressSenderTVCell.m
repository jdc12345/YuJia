//
//  YJExpressSenderTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJExpressSenderTVCell.h"
#import "UILabel+Addition.h"

@interface YJExpressSenderTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;


@end
@implementation YJExpressSenderTVCell

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
//-----根据活动状态和已参加人数来确定活动是否还可以参加-----
//-(void)setModel:(YYPropertyItemModel *)model{
//    _model = model;
//    self.itemLabel.text = model.item;
//    [self.btn setTitle:model.event forState:UIControlStateNormal];
//}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIView *headerView = [[UIView alloc]init];//添加line
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.left.right.offset(0);
        make.height.offset(66*kiphone6);
    }];
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"sf"];
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(headerView);
        make.left.offset(10*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"顺丰快递" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//物流状态
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(headerView);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.right.offset(-64*kiphone6);
        make.width.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UIButton *phoneBtn = [[UIButton alloc]init];
    [phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [headerView addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView.mas_right).offset(-32*kiphone6);
    }];
    [phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.offset(kScreenW);
    }];
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    
}
- (void)btnClick:(UIButton *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender.tag);
    }
}

@end
