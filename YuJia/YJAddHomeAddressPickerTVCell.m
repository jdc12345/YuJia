//
//  YJAddHomeAddressPickerTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/8/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddHomeAddressPickerTVCell.h"
#import "UILabel+Addition.h"

@interface YJAddHomeAddressPickerTVCell()
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UIImageView* locView;
@end

@implementation YJAddHomeAddressPickerTVCell

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
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.locView.image = [UIImage imageNamed:imageName];
    [self layoutIfNeeded];
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    //背景view
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.bottom.offset(0);
        make.right.offset(-10*kiphone6);
    }];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];
    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.image = [UIImage imageNamed:@"gray_forward"];
    [backView addSubview:imageView];
    self.locView = imageView;
    UILabel *itemLabel = [UILabel labelWithText:@"城市" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:13];
    [backView addSubview:itemLabel];
    self.itemLabel = itemLabel;
    UILabel *contentLabel = [UILabel labelWithText:@"" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:13];
    [backView addSubview:contentLabel];
    
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(backView);
        make.width.offset(70*kiphone6);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView);
        make.left.equalTo(itemLabel.mas_right);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(backView);
    }];
    
    self.contentLabel = contentLabel;
    //选ze的按钮
    UIButton *selectBtn = [[UIButton alloc]init];
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor colorWithHexString:@"#0ddcbc"] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [selectBtn sizeToFit];
    [backView addSubview:selectBtn];
    //    self.openBtn = openBtn;
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-10*kiphone6);
    }];
    self.selectBtn = selectBtn;
}
-(void)selectBtnClick:(UIButton*)sender{
    self.clickSelectBtnBlock(sender.tag);
}
@end
