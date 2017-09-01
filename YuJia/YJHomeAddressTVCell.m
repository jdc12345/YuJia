//
//  YJHomeAddressTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/8/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomeAddressTVCell.h"
#import "UILabel+Addition.h"
@interface YJHomeAddressTVCell ()

@end
@implementation YJHomeAddressTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
-(void)setHouseModle:(YJHomeHouseInfoModel *)houseModle{
    _houseModle = houseModle;
    self.selectBtn.selected = houseModle.defaults;//是否是默认的地址
    self.nameLabel.text = houseModle.ownerName;
    switch ([houseModle.userType integerValue]) {
        case 0:
            self.typeLabel.text = @"业主";
            break;
        case 1:
            self.typeLabel.text = @"租客";
            break;
        case 2:
            self.typeLabel.text = @"访客";
            break;
        default:
            break;
    }
    self.teleLabel.text = houseModle.ownerTelephone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@%@",houseModle.areaName,houseModle.residentialQuartersName,houseModle.address];
    
}
- (void)createDetailView{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    //背景view
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10*kiphone6);
        make.bottom.offset(0);
        make.right.offset(-10*kiphone6);
    }];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4;
    //选地址的按钮
    UIButton *selectBtn = [[UIButton alloc]init];
    [selectBtn setImage:[UIImage imageNamed:@"homeAddress_unselected"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"homeAddress_select"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [selectBtn sizeToFit];
    [backView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_top).offset(25*kiphone6);
        make.left.offset(20*kiphone6);
    }];
    //选择此地址为常用
    UILabel *itemLabel = [UILabel labelWithText:@"选择此地址为常用" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:12];
    [backView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.left.equalTo(selectBtn.mas_right).offset(10*kiphone6);
    }];
    //删除地址的按钮
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setImage:[UIImage imageNamed:@"homeAddress_delete"] forState:UIControlStateNormal];
    [deleteBtn sizeToFit];
    [backView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.right.offset(-20*kiphone6);
    }];

    //编辑地址的按钮
    UIButton *editBtn = [[UIButton alloc]init];
    [editBtn setImage:[UIImage imageNamed:@"homeAddress_edit"] forState:UIControlStateNormal];
    //    [openBtn addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [editBtn sizeToFit];
    [backView addSubview:editBtn];
    self.editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtn);
        make.right.equalTo(deleteBtn.mas_left).offset(-40*kiphone6);
    }];
    [self.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    //..邪恶的分割线
    UILabel *lineL = [[UILabel alloc]init];
    lineL.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [backView addSubview:lineL];
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50*kiphone6);
        make.left.right.offset(0);
        make.height.offset(1);
    }];
    //姓名
    UILabel *nameLabel = [UILabel labelWithText:@"用户姓名" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    self.nameLabel = nameLabel;
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineL.mas_bottom).offset(15*kiphone6);
        make.left.offset(20*kiphone6);
    }];
    //业主类型
    UILabel *typeLabel = [UILabel labelWithText:@"业主" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    self.typeLabel = typeLabel;
    [backView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineL.mas_bottom).offset(15*kiphone6);
        make.left.equalTo(nameLabel.mas_right).offset(20*kiphone6);
    }];
    //联系电话
    UILabel *numLabel = [UILabel labelWithText:@"17000000000" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    self.teleLabel = numLabel;
    [backView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineL.mas_bottom).offset(15*kiphone6);
        make.left.equalTo(typeLabel.mas_right).offset(20*kiphone6);
    }];
    //地址
    UILabel *addressLabel = [UILabel labelWithText:@"河北省 保定市 涿州市 范阳中路 名流一品小区 一号楼 一单元 102" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    self.addressLabel = addressLabel;
    addressLabel.numberOfLines = 0;
    [backView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(15*kiphone6);
        make.left.offset(20*kiphone6);
        make.right.offset(-40*kiphone6);
    }];

}
-(void)selectBtnClick:(UIButton*)sender{
//    sender.selected = !sender.selected;
    self.selectedBlock(self.houseModle);
}
-(void)deleteBtnClick:(UIButton*)sender{
    self.deleBlock(self.houseModle);
}
-(void)editBtnClick:(UIButton*)sender{
    self.editBlock(self.houseModle);
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
