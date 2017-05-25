//
//  YJExpressReceiveTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJExpressReceiveTVCell.h"
#import "UILabel+Addition.h"

@interface YJExpressReceiveTVCell()
@property (nonatomic, weak) UILabel* stateContentLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* boxAddressLabel;
@property (nonatomic, weak) UILabel* codeContentLabel;
@property (nonatomic, weak) UILabel* acceptContentLabel;
@property (nonatomic, weak) UILabel* numberContentLabel;
@property (nonatomic, weak) UILabel* acceptStateLabel;
@end
@implementation YJExpressReceiveTVCell

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
-(void)setModel:(YJExpressReceiveModel *)model{
    _model = model;
    if (model.propertyType == 1) {
        self.stateContentLabel.text = @"服务站已签收";
    }else if (model.propertyType == 2) {
        self.stateContentLabel.text = @"服务站未签收";
    }
    self.timeLabel.text = model.signTimeString;
    self.boxAddressLabel.text = model.cabinet;
    self.codeContentLabel.text = model.deliveryCode;
    self.acceptContentLabel.text = model.ename;
    self.numberContentLabel.text = [NSString stringWithFormat:@"%ld",model.expressId];
    if (model.personalType == 1) {
        self.acceptStateLabel.text = @"未收取";
    }else if (model.personalType == 2) {
        self.acceptStateLabel.text = @"已收取";
    }
    
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIView *headerView = [[UIView alloc]init];//添加line
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(195*kiphone6);
    }];
    UILabel *stateLabel = [UILabel labelWithText:@"物流状态" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//物流状态
    [headerView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
    }];
    UILabel *stateContentLabel = [UILabel labelWithText:@"服务站已签收" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:15];//服务站已签收
    [headerView addSubview:stateContentLabel];
    [stateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stateLabel);
        make.left.equalTo(stateLabel.mas_right).offset(10*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"5月6日" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];//物流状态
    [headerView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *boxLabel = [UILabel labelWithText:@"自 提 柜 :" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//自提柜
    [headerView addSubview:boxLabel];
    [boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLabel.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *boxAddressLabel = [UILabel labelWithText:@"名流一品南门" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//时间内容
    [headerView addSubview:boxAddressLabel];
    [boxAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boxLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(boxLabel);
    }];
    UILabel *codeLabel = [UILabel labelWithText:@"提 货 码 :" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//提货码
    [headerView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxLabel.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *codeContentLabel = [UILabel labelWithText:@"888888" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:14];//888888
    [headerView addSubview:codeContentLabel];
    [codeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(codeLabel);
        make.left.equalTo(codeLabel.mas_right).offset(10*kiphone6);
    }];
    UILabel *acceptLabel = [UILabel labelWithText:@"承运单位 :" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//承运单位
    [headerView addSubview:acceptLabel];
    [acceptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *acceptContentLabel = [UILabel labelWithText:@"顺丰快递" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//顺丰快递
    [headerView addSubview:acceptContentLabel];
    [acceptContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(acceptLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(acceptLabel);
    }];
    UILabel *acceptNumberLabel = [UILabel labelWithText:@"运单编号 :" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//运单编号
    [headerView addSubview:acceptNumberLabel];
    [acceptNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(acceptLabel.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *numberContentLabel = [UILabel labelWithText:@"123456789012" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//顺丰快递
    [headerView addSubview:numberContentLabel];
    [numberContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(acceptNumberLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(acceptNumberLabel);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(acceptNumberLabel.mas_bottom).offset(10*kiphone6);
        make.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UILabel *acceptStateLabel = [UILabel labelWithText:@"未签收" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:15];//未签收
    [headerView addSubview:acceptStateLabel];
    [acceptStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_bottom).offset(19*kiphone6);
        make.right.offset(-10*kiphone6);
    }];

//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headerView.mas_bottom).offset(5*kiphone6);
//        make.width.offset(kScreenW);
//    }];
    self.stateContentLabel = stateContentLabel;
    self.timeLabel = timeLabel;
    self.boxAddressLabel = boxAddressLabel;
    self.codeContentLabel = codeContentLabel;
    self.acceptContentLabel = acceptContentLabel;
    self.numberContentLabel = numberContentLabel;
    self.acceptStateLabel = acceptStateLabel;
}


@end
