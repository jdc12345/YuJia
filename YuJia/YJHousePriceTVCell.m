//
//  YJHousePriceTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHousePriceTVCell.h"
#import "UILabel+Addition.h"

@implementation YJHousePriceTVCell

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
-(void)setPrice:(NSString *)price{
    _price = price;
    self.itemLabel.text = price;
}

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *itemLabel = [UILabel labelWithText:@"不限" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    self.itemLabel = itemLabel;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
