//
//  YJBillInfoTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJBillInfoTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"

@interface YJBillInfoTableViewCell()<UITextFieldDelegate>
@property(nonatomic,weak)UITextField *contentField;
@property (nonatomic, weak) UILabel* itemLabel;
@end
@implementation YJBillInfoTableViewCell

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
    UILabel *itemLabel = [UILabel labelWithText:@"城  市" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:13];
    [self.contentView addSubview:itemLabel];
    self.itemLabel = itemLabel;
    UITextField *contentField = [[UITextField alloc]init];
    contentField.font = [UIFont boldSystemFontOfSize:13];
    contentField.placeholder = @"请准确输入你的信息";
    [contentField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [contentField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.contentView addSubview:contentField];
    self.contentField = contentField;
    contentField.delegate = self;

    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView);
        make.width.offset(70*kiphone6);
    }];
    [contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10*kiphone6);
    }];
}


@end
