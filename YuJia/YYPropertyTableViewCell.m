//
//  YYPropertyTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYPropertyTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <Masonry.h>
@interface YYPropertyTableViewCell()
@property (nonatomic, weak) UIButton* btn;
@property (nonatomic, weak) UILabel* itemLabel;
@end
@implementation YYPropertyTableViewCell
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
-(void)setModel:(YYPropertyItemModel *)model{
    _model = model;
    self.itemLabel.text = model.item;
    [self.btn setTitle:model.event forState:UIControlStateNormal];
}
-(void)setupUI{
    UILabel *itemLabel = [UILabel labelWithText:@"2017年5月物业费" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:13];
    [self.contentView addSubview:itemLabel];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];
    [btn setTitle:@"立即缴费" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:btn];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.offset(83*kiphone6);
        make.height.offset(36*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    self.itemLabel = itemLabel;
    self.btn = btn;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender.tag);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
