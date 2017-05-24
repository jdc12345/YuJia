//
//  YJPayItemTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPayItemTableViewCell.h"
#import "UILabel+Addition.h"

@interface YJPayItemTableViewCell()
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* numberLabel;
@property (nonatomic, weak) UIImageView *iconView;
@end
@implementation YJPayItemTableViewCell

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
-(void)setModel:(YJPayItemModel *)model{
    _model = model;
    self.iconView.image = [UIImage imageNamed:model.icon];
    self.itemLabel.text = model.item;
    self.numberLabel.text = model.number;
    if ([model.number isEqualToString:@""]) {
        [self.itemLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView);
            make.left.equalTo(self.iconView.mas_right).offset(10*kiphone6);
        }];
    }
    
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"water"];
    [self.contentView addSubview:iconView];
   
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(10*kiphone6);
    }];
    UILabel *itemLabel = [UILabel labelWithText:@"电费" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.bottom.equalTo(iconView.mas_centerY).offset(-2.5*kiphone6);
    }];
    UILabel *numberLabel = [UILabel labelWithText:@"1111111" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:10];
    [self.contentView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(iconView.mas_centerY).offset(2.5*kiphone6);
    }];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"forward"];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10*kiphone6);
    }];
    self.numberLabel = numberLabel;
    self.iconView = iconView;
    self.itemLabel = itemLabel;
}


@end
