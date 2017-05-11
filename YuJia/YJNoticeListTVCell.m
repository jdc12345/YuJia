//
//  YJNoticeListTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNoticeListTVCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"

@interface YJNoticeListTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@end
@implementation YJNoticeListTVCell

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
//}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [self.contentView addSubview:iconView];
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [self.contentView addSubview:nameLabel];

    UILabel *itemLabel = [UILabel labelWithText:@"用户TIAN给你点赞了" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];
    [self.contentView addSubview:itemLabel];
    UILabel *timeLabel = [UILabel labelWithText:@"10:00" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:12];
    [self.contentView addSubview:timeLabel];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView);
        make.width.height.offset(40*kiphone6);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2.5*kiphone6);
    }];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(self.contentView.mas_centerY).offset(2.5*kiphone6);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1*kiphone6);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconView.mas_centerY).offset(27.5*kiphone6);
        make.width.offset(kScreenW);
    }];
    self.itemLabel = itemLabel;
    
}



@end
