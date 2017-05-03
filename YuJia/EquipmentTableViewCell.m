//
//  EquipmentTableViewCell.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "EquipmentTableViewCell.h"

@implementation EquipmentTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    
    
    self.cardView = [[UIView alloc]init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.cardView];
    
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 50));
    }];
    
    //..邪恶的分割线
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    self.iconV = [[UIImageView alloc]init];
    self.iconV.image = [UIImage imageNamed:@"cell1"];
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"6a6a6a"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"李美丽";
    
    
    [self.cardView addSubview:lineL];
    [self.cardView addSubview:self.iconV];
    [self.cardView addSubview:self.titleLabel];
    
    
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView);
        make.left.equalTo(self.cardView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1));
    }];
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.left.equalTo(self.cardView).with.offset(15 );
        make.size.mas_equalTo(CGSizeMake(15 *kiphone6, 15 *kiphone6));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.left.equalTo(self.iconV.mas_right).with.offset(10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(100 *kiphone6, 14 *kiphone6));
    }];
    
    UISwitch *switch0 = [[UISwitch alloc]init];
    switch0.onTintColor= [UIColor colorWithHexString:@"00bfff"];
    switch0.tintColor = [UIColor colorWithHexString:@"cccccc"];
    // 控件大小，不能设置frame，只能用缩放比例
    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
    [self.cardView addSubview:switch0];
    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.right.equalTo(self.cardView).with.offset(-10 *kiphone6);
        //        make.size.mas_equalTo(CGSizeMake(7.5 *kiphone6, 13 *kiphone6));
    }];
    
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disclosure-arrow-拷贝-2"]];
    [self.cardView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.right.equalTo(self.cardView).with.offset(-10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(7.5 *kiphone6, 13 *kiphone6));
    }];
    
    
    self.imageV = imageV;
    self.switch0 = switch0;

}
- (void)cellMode:(BOOL)isSwitch{
    if (isSwitch) {
        self.imageV.hidden = YES;
        self.switch0.hidden = NO;
    }else{
        self.switch0.hidden = YES;
        self.imageV.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
