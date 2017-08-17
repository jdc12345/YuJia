//
//  YJEquipmentListTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/8/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJEquipmentListTVCell.h"

@implementation YJEquipmentListTVCell

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
    [self.iconV sizeToFit];
    
    
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
