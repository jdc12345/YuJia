//
//  YJActivitiesDetailsTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJActivitiesDetailsTVCell.h"
#import "UILabel+Addition.h"

@interface YJActivitiesDetailsTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* begainTimeLabel;
@property (nonatomic, weak) UILabel* typeLabel;
@property (nonatomic, weak) UILabel* addressLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* limiteNumberLabel;
@property (nonatomic, weak) UILabel* teleNumberLabel;
@property (nonatomic, weak) UILabel* conentLabel;

@end
@implementation YJActivitiesDetailsTVCell

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
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIImageView *iconView = [[UIImageView alloc]init];//头像图片
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView.mas_top).offset(30*kiphone6);
        make.width.height.offset(40*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//姓名
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *stateLabel = [UILabel labelWithText:@"正在进行" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:14];//状态
    [self.contentView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *begainTimeLabel = [UILabel labelWithText:@"5月6日 6:30" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//开始时间
    [self.contentView addSubview:begainTimeLabel];
    [begainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.right.equalTo(stateLabel.mas_left).offset(-10*kiphone6);
    }];

    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60*kiphone6);
        make.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    
    UILabel *typeLabel = [UILabel labelWithText:@"烧烤聚会" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//活动类型
    [self.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *timeItemLabel = [UILabel labelWithText:@"时间" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//时间标题
    [self.contentView addSubview:timeItemLabel];
    [timeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(typeLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"5.6 6:30-5.31 18:30" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//时间内容
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(timeItemLabel);
    }];
    UILabel *AddressItemLabel = [UILabel labelWithText:@"地点" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//地点标题
    [self.contentView addSubview:AddressItemLabel];
    [AddressItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(timeItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *AddressLabel = [UILabel labelWithText:@"风景区公园" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//地点内容
    [self.contentView addSubview:AddressLabel];
    [AddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(AddressItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(AddressItemLabel);
    }];
    UILabel *numberItemLabel = [UILabel labelWithText:@"人数" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//总人数标题
    [self.contentView addSubview:numberItemLabel];
    [numberItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(AddressItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *limiteNumberLabel = [UILabel labelWithText:@"3人" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//总人数
    [self.contentView addSubview:limiteNumberLabel];
    [limiteNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(numberItemLabel);
    }];
    UILabel *teleItemLabel = [UILabel labelWithText:@"电话" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//电话标题
    [self.contentView addSubview:teleItemLabel];
    [teleItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(numberItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *teleNumberLabel = [UILabel labelWithText:@"186 1143 9783" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//电话号码
    [self.contentView addSubview:teleNumberLabel];
    [teleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teleItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(teleItemLabel);
    }];
    UILabel *contentItemLabel = [UILabel labelWithText:@"活动内容" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//活动内容标题
    [self.contentView addSubview:contentItemLabel];
    [contentItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(teleItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *conentLabel = [UILabel labelWithText:@"活动内容186活动内容1143活动内容9783活动内容186活动内容1143活动内容9783" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//电话号码
    conentLabel.numberOfLines = 0;
    [self.contentView addSubview:conentLabel];
    [conentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(contentItemLabel.mas_bottom).offset(15*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(conentLabel.mas_bottom).offset(15*kiphone6);
        make.width.offset(kScreenW);
    }];
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.typeLabel = typeLabel;
    self.begainTimeLabel = begainTimeLabel;
    self.timeLabel = timeLabel;
    self.limiteNumberLabel = limiteNumberLabel;
    self.teleNumberLabel = teleNumberLabel;
    self.conentLabel = conentLabel;
    
}


@end
