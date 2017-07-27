//
//  manageAddressTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/25.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "manageAddressTVCell.h"
#import "UILabel+Addition.h"

@interface manageAddressTVCell()
@property (nonatomic, weak) UIButton* btn;

@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* moneyLabel;
@end
@implementation manageAddressTVCell

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
-(void)setModel:(YJLifePayAddressModel *)model{
    _model = model;
    self.addressLabel.text = model.detailAddress;
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加背景
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.bottom.offset(0);
    }];
    backView.layer.masksToBounds = true;
    backView.layer.cornerRadius = 3;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    
    UILabel *addressLabel = [UILabel labelWithText:@"河北名流一品3号楼3单元3层306" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [backView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
    }];
    UIButton *deleBtn = [[UIButton alloc]init];
    deleBtn.tag = 31;
    [deleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [deleBtn setImage:[UIImage imageNamed:@"delete_address"] forState:UIControlStateNormal];
    [backView addSubview:deleBtn];
    [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.bottom.offset(-10*kiphone6);
    }];
    UIButton *editBtn = [[UIButton alloc]init];
    editBtn.tag = 32;
    [editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [editBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"edit_address"] forState:UIControlStateNormal];
    [backView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleBtn.mas_left).offset(-10*kiphone6);
        make.centerY.equalTo(deleBtn);
    }];
    
    self.addressLabel = addressLabel;
    self.backView = backView;
    
}
- (void)btnClick:(UIButton *)sender{
    self.clickBtnBlock(sender.tag, self.model);//根据tag确定删除(31)还是编辑(32)
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
