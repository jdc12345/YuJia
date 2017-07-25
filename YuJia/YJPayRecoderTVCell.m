//
//  YJPayRecoderTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPayRecoderTVCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"

@interface YJPayRecoderTVCell()
@property (nonatomic, weak) UIButton* btn;
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* moneyLabel;
@end
@implementation YJPayRecoderTVCell

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
//-(void)setModel:(YYPropertyItemModel *)model{
//    _model = model;
//    self.itemLabel.text = model.item;
//    [self.btn setTitle:model.event forState:UIControlStateNormal];
//    if ([model.event isEqualToString:@""]) {
//        self.btn.hidden = true;
//    }else{
//        self.btn.hidden = false;
//    }
//    
//}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"electric_payed"];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(10*kiphone6);
        make.width.height.offset(36*kiphone6);
    }];
    UILabel *itemLabel = [UILabel labelWithText:@"电费-*07室" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2.5*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"07-17 19:54" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(self.contentView.mas_centerY).offset(2.5*kiphone6);
    }];
    UILabel *moneyLabel = [UILabel labelWithText:@"-60.00" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [self.contentView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(self.contentView);
    }];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];
    self.itemLabel = itemLabel;
    self.timeLabel = timeLabel;
    self.moneyLabel = moneyLabel;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
