//
//  YJCityTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCityTableViewCell.h"
#import "UILabel+Addition.h"

@interface YJCityTableViewCell()
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* contentLabel;
@end
@implementation YJCityTableViewCell

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
-(void)setItem:(NSString *)item{
    _item = item;
    self.itemLabel.text = item;
}
-(void)setCity:(NSString *)city{
    _city = city;
    self.contentLabel.text = city;
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
    UILabel *itemLabel = [UILabel labelWithText:@"城市" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:13];
    [self.contentView addSubview:itemLabel];
    self.itemLabel = itemLabel;
    UILabel *contentLabel = [UILabel labelWithText:@"请选择合适的地区" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:13];
    [self.contentView addSubview:contentLabel];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"gray_forward"];
    [self.contentView addSubview:imageView];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView);
        make.width.offset(70*kiphone6);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemLabel.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10*kiphone6);
    }];
    self.contentLabel = contentLabel;
}

@end
