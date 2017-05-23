//
//  LockRecardTableViewCell.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LockRecardTableViewCell.h"

@implementation LockRecardTableViewCell
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
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 60));
    }];
    
    //..邪恶的分割线
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    self.iconV = [[UIImageView alloc]init];
    self.iconV.image = [UIImage imageNamed:@"cell1"];
    self.iconV.layer.cornerRadius = 37/2.0;
    self.iconV.clipsToBounds = YES;
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
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
        make.size.mas_equalTo(CGSizeMake(37 , 37 ));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.left.equalTo(self.iconV.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(98, 14));
    }];
    
    
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentRight;
    
//    self.titleLabel.backgroundColor = [UIColor orangeColor];
//    timeLabel.backgroundColor = [UIColor cyanColor];
    [self.cardView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.right.equalTo(self.cardView).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(150, 12));
    }];
    
    
    self.timeLabel = timeLabel;
    
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
