//
//  YJActivitiesDetailsTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJActivitiesDetailsTVCell.h"
#import "UILabel+Addition.h"
#import <UIImageView+WebCache.h>
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface YJActivitiesDetailsTVCell()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* begainTimeLabel;
@property (nonatomic, weak) UILabel* typeLabel;
@property (nonatomic, weak) UILabel* addressLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* limiteNumberLabel;
@property (nonatomic, weak) UILabel* teleNumberLabel;
@property (nonatomic, weak) UILabel* conentLabel;
@property (nonatomic, weak) UILabel* stateLabel;
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
-(void)setModel:(YJActivitiesDetailModel *)model{
    _model = model;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nameLabel.text = model.user_name;
    self.begainTimeLabel.text = model.starttimeString;
    self.typeLabel.text = model.activityTheme;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.starttimeString,model.endtimeString];
    self.addressLabel.text = model.activityAddress;
    self.limiteNumberLabel.text = [NSString stringWithFormat:@"%ld人",model.activityNumber];
    self.teleNumberLabel.text = [NSString stringWithFormat:@"%ld",model.activityTelephone];
    self.conentLabel.text = model.activityContent;
    if (model.over == 1) {
        self.stateLabel.text = @"正在进行";
    }else if (model.over == 2) {
        self.stateLabel.text = @"已经结束";
    }
    
//    self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld人感兴趣",model.likeNum];
//    self.addNumberLabel.text = [NSString stringWithFormat:@"%ld人",model.participateNumber];
//    if (model.islike) {
//        [self.likeBtn setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
//    }else{
//        [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//    }
//    
//    if (model.over == 1) {
//        self.activitieStateLabel.text = @"正在进行";
//        self.likeBtn.userInteractionEnabled = true;
//        if (model.joined) {//参加过不能参加
//            [self.addBtn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//            self.addBtn.userInteractionEnabled = false;
//        }else{
//            if (model.participateNumber<model.activityNumber) {
//                [self.addBtn setImage:[UIImage imageNamed:@"click_add"] forState:UIControlStateNormal];
//                self.addBtn.userInteractionEnabled = true;
//            }else{//没参加过但是人数满了也不能参加
//                [self.addBtn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//                self.addBtn.userInteractionEnabled = false;
//            }
//        }
//    }else if (model.over == 2) {
//        self.activitieStateLabel.text = @"活动结束";
//        [self.addBtn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//        self.addBtn.userInteractionEnabled = false;
//        self.likeBtn.userInteractionEnabled = false;
//    }
}
- (void)configCellWithModel:(YJActivitiesDetailModel *)model indexPath:(NSIndexPath *)indexPath{
    self.model = model;
}
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
    iconView.userInteractionEnabled = true;
    //添加滑动手势
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [iconView addGestureRecognizer:pan];
    pan.delegate = self;
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//姓名
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *stateLabel = [UILabel labelWithText:@"正在进行" andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:14];//状态
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
    self.hyb_lastViewInCell = conentLabel;
    self.hyb_bottomOffsetToCell = 10*kiphone6;
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.typeLabel = typeLabel;
    self.begainTimeLabel = begainTimeLabel;
    self.timeLabel = timeLabel;
    self.limiteNumberLabel = limiteNumberLabel;
    self.teleNumberLabel = teleNumberLabel;
    self.conentLabel = conentLabel;
    self.stateLabel = stateLabel;
    self.addressLabel = AddressLabel;
}
//设置点击手势
-(void)tapGesture:(UITapGestureRecognizer*)sender{
    self.iconViewTapgestureBlock(self.model);
}

@end
