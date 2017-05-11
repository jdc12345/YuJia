//
//  AirDirectionTableViewCell.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AirDirectionTableViewCell.h"

@implementation AirDirectionTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    
    //..邪恶的分割线
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    self.iconV = [[UIImageView alloc]init];
    self.iconV.image = [UIImage imageNamed:@"cell1"];
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"李美丽";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.contentView addSubview:lineL];
//    [self.contentView addSubview:self.iconV];
    [self.contentView addSubview:self.titleLabel];
    
    
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-1);
        make.left.equalTo(self.contentView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 1));
    }];
//    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).with.offset((kScreenW - 58) *0.5);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset((kScreenW - 60) *0.5);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
    
    //    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disclosure-arrow-拷贝-2"]];
    //    [self.contentView addSubview:imageV];
    //    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.contentView);
    //        make.right.equalTo(self.contentView).with.offset(-10 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake(7.5 *kiphone6, 13 *kiphone6));
    //    }];
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
