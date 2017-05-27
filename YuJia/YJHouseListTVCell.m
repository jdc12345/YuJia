//
//  YJHouseListTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHouseListTVCell.h"
#import "UILabel+Addition.h"
#import <UIImageView+WebCache.h>

@interface YJHouseListTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* detailLabel;
@property (nonatomic, weak) UILabel* priceLabel;

@end
@implementation YJHouseListTVCell

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
-(void)setModel:(YJHouseListModel *)model{
    _model = model;
    NSString *iconUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.picture];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %ld㎡ %@ %@",model.residentialQuarters,model.apartmentLayout,model.housingArea,model.paymentMethod,model.direction];
    self.priceLabel.text = [NSString stringWithFormat:@"%ld元/月",model.rent];
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"icon"];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(10*kiphone6);
        make.width.offset(100*kiphone6);
        make.height.offset(75*kiphone6);
    }];
    UILabel *detailLabel = [UILabel labelWithText:@"涿州名流一品 一室一厅 48平米 押一付三 南北" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//详情
    [self.contentView addSubview:detailLabel];
    detailLabel.numberOfLines = 0;
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(iconView);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *typeLabel = [UILabel labelWithText:@"整租" andTextColor:[UIColor colorWithHexString:@"#f98f40"] andFontSize:14];//整租
    [self.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(detailLabel.mas_bottom).offset(4*kiphone6);
        make.height.offset(20*kiphone6);
        make.width.offset(52*kiphone6);
    }];
    typeLabel.layer.borderWidth = 1;
    typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#f98f40"].CGColor;
    typeLabel.layer.masksToBounds = true;
    typeLabel.layer.cornerRadius = 2;
    UILabel *priceLabel = [UILabel labelWithText:@"1000元/月" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:15];//价格
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(typeLabel.mas_bottom).offset(4*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    
    self.iconView = iconView;
    self.detailLabel = detailLabel;
    self.priceLabel = priceLabel;
}

@end
