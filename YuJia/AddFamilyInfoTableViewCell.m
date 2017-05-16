//
//  AddFamilyInfoTableViewCell.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AddFamilyInfoTableViewCell.h"

@implementation AddFamilyInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    self.cardView = [[UIView alloc]init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0 );
        make.left.equalTo(self.contentView).with.offset(10 );
        make.size.mas_equalTo(CGSizeMake(kScreenW - 20 , 50));
    }];
    
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.cardView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView.mas_bottom).with.offset(0);
        make.left.equalTo(self.cardView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 40 , 1));
    }];
    
    
    self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.iconBtn setImage:[UIImage imageNamed:@"unselected_family"] forState:UIControlStateNormal];
    [self.iconBtn setImage:[UIImage imageNamed:@"selected_family"] forState:UIControlStateSelected];
    
    [self.iconBtn sizeToFit];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    
    
    [self.cardView addSubview:self.iconBtn];
    [self.cardView  addSubview:self.titleLabel];
    
    
    WS(ws);
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.cardView).with.offset(0);
        make.left.equalTo(ws.cardView).with.offset(15 );
        //        make.size.mas_equalTo(CGSizeMake(30 , 30 ));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.cardView).with.offset(0 );
        make.left.equalTo(ws.iconBtn.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150 , 15));
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
