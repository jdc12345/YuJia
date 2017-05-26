//
//  YJNearByShopTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNearByShopTVCell.h"
#import "UILabel+Addition.h"
#import "ZFBLevelView.h"
#import <UIImageView+WebCache.h>

@interface YJNearByShopTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) ZFBLevelView* starView;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *distanceLabel;
@end
@implementation YJNearByShopTVCell
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
-(void)setModel:(YJBussinessDetailModel *)model{
    _model = model;
    NSString *iconUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.picture];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nameLabel.text = model.businessName;
    self.starView.level = model.star;
    self.priceLabel.text = [NSString stringWithFormat:@"人均：¥%.f/人",model.average];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.fm",model.average];
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
        make.width.offset(110*kiphone6);
        make.bottom.offset(-10*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"西饼店" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//西饼店
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.offset(21.5*kiphone6);
    }];
    ZFBLevelView *starView = [[ZFBLevelView alloc]initWithFrame:CGRectMake(0, 0, 60*kiphone6, 12*kiphone6)];//星星评价
    starView.level = 3;
    [self.contentView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(nameLabel.mas_bottom).offset(10*kiphone6);
//        make.height.offset(12*kiphone6);
//        make.width.offset(60*kiphone6);
    }];
    self.starView = starView;
    UILabel *priceLabel = [UILabel labelWithText:@"人均： ¥ 20/人" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];//价格
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(starView.mas_bottom).offset(20*kiphone6);
    }];
    UILabel *distanceLabel = [UILabel labelWithText:@"150m" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];//距离
    [self.contentView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(priceLabel.mas_bottom).offset(10*kiphone6);
    }];
    distanceLabel.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
   
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.distanceLabel = distanceLabel;
    self.priceLabel = priceLabel;
}

@end
