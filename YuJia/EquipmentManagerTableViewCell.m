//
//  EquipmentManagerTableViewCell.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "EquipmentManagerTableViewCell.h"

@implementation EquipmentManagerTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
-(void)setIsSelecting:(BOOL)isSelecting{
    _isSelecting = isSelecting;
    if (isSelecting) {
        self.selectBtn.hidden = NO;
    }else{
        self.selectBtn.hidden = YES;
    }
}
-(void)setIsAllSelected:(BOOL)isAllSelected{
    _isAllSelected = isAllSelected;
    self.selectBtn.selected = isAllSelected;
}
- (void)createDetailView{
    
    self.cardView = [[UIView alloc]init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.height.offset(80*kiphone6);
    }];
    
//    //..邪恶的分割线
//    UILabel *lineL = [[UILabel alloc]init];
//    lineL.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    self.iconV = [[UIImageView alloc]init];
    self.iconV.image = [UIImage imageNamed:@"cell1"];
    [self.iconV sizeToFit];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.text = @"李美丽";
    
    
//    [self.cardView addSubview:lineL];
    [self.cardView addSubview:self.iconV];
    [self.cardView addSubview:self.titleLabel];
    
//    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.cardView);
//        make.left.equalTo(self.cardView).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenW, 1));
//    }];
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.left.offset(15*kiphone6);
        make.width.height.offset(56*kiphone6);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.left.equalTo(self.iconV.mas_right).offset(15 *kiphone6);
    }];
    
//    UISwitch *switch0 = [[UISwitch alloc]init];
//    switch0.onTintColor= [UIColor colorWithHexString:@"00bfff"];
//    switch0.tintColor = [UIColor colorWithHexString:@"cccccc"];
//    // 控件大小，不能设置frame，只能用缩放比例
//    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
//    [self.cardView addSubview:switch0];
//    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.cardView);
//        make.right.equalTo(self.cardView).with.offset(-10 *kiphone6);
//        //        make.size.mas_equalTo(CGSizeMake(7.5 *kiphone6, 13 *kiphone6));
//    }];
    
    UIButton *selectBtn = [[UIButton alloc]init];
    [self.cardView addSubview:selectBtn];
    [selectBtn setImage:[UIImage imageNamed:@"homeEquipment_unselected"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"homeEquipment_selected"] forState:UIControlStateSelected];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardView);
        make.right.equalTo(self.cardView).with.offset(-10 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(17 *kiphone6, 17 *kiphone6));
    }];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    selectBtn.hidden = YES;
//    self.switch0 = switch0;
    
}
- (void)selectBtnClick:(UIButton*)sender{
    sender.selected = !sender.selected;

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
