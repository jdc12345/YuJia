//
//  YJPayRecoderTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPayRecoderTVCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"

@interface YJPayRecoderTVCell()
@property (nonatomic, weak) UIButton* btn;
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* moneyLabel;
@property (nonatomic, weak) UILabel* refundAmountLabel;//退款label
@property (nonatomic, weak) UIImageView* iconView;
@end
@implementation YJPayRecoderTVCell

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
-(void)setModel:(YJLifePayRecoderModel *)model{
    _model = model;
    //personalId            Long        当前用户ID
    //orderNumber             Long        订单号
    //paymentAmount          Long        缴费金额
    //drNumber            String    表的编号，物业费的时候不显示
    //paymentInstruction          String        缴费说明
    //detailHomeId            Long        缴费地址ID
    //paymentTimeString         String        缴费时间
    //paymentMethod         Integer    支付方式1=微信支付2=支付宝支付
    //drType             Integer  缴费类型1=电费2=水费3=燃气费4=物业费
    //id              Long        当前记录ID
    //propertyId            Long        物业单位ID
    //refundTimeString          String           退款时间
    //paymentStatus          Integer      状态：1=支付成功2=退款成功
    //refundAmount           Long        退款金额
    switch (model.drType) {
        case 1:
            self.itemLabel.text = [NSString stringWithFormat:@"电费-%@",model.detailAddress];
            self.iconView.image = [UIImage imageNamed:@"electric_payed"];
            break;
        case 2:
            self.itemLabel.text = [NSString stringWithFormat:@"水费-%@",model.detailAddress];
            self.iconView.image = [UIImage imageNamed:@"water_payed"];
            break;
        case 3:
            self.itemLabel.text = [NSString stringWithFormat:@"燃气费-%@",model.detailAddress];
            self.iconView.image = [UIImage imageNamed:@"Gas_payed"];
            break;
        case 4:
            self.itemLabel.text = [NSString stringWithFormat:@"物业费-%@",model.detailAddress];
            self.iconView.image = [UIImage imageNamed:@"Property_payed"];
            break;
        default:
            break;
    }
    self.timeLabel.text = model.paymentTimeString;
    if (model.paymentStatus==1) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%ld",model.paymentAmount];
        self.refundAmountLabel.hidden = true;
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10*kiphone6);
            make.centerY.equalTo(self.contentView);
        }];
    }else if (model.paymentStatus==2){
        self.moneyLabel.text = [NSString stringWithFormat:@"-%ld",model.paymentAmount];
        self.refundAmountLabel.text = [NSString stringWithFormat:@"已退款(¥%ld)",model.refundAmount];
        self.refundAmountLabel.hidden = false;
        [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10*kiphone6);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-2.5*kiphone6);
        }];

    }
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"electric_payed"];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(10*kiphone6);
        make.width.height.offset(36*kiphone6);
    }];
    UILabel *itemLabel = [UILabel labelWithText:@"电费-*07室" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2.5*kiphone6);
        make.width.offset(100*kiphone6);
    }];
    itemLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;    //中间的内容以……方式省略，显示头尾
    UILabel *timeLabel = [UILabel labelWithText:@"07-17 19:54" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(self.contentView.mas_centerY).offset(2.5*kiphone6);
    }];
    UILabel *moneyLabel = [UILabel labelWithText:@"-60.00" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [self.contentView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(self.contentView);
    }];
    UILabel *refundAmountLabel = [UILabel labelWithText:@"已退款(¥60.00)" andTextColor:[UIColor colorWithHexString:@"#f97878"] andFontSize:14];
    [self.contentView addSubview:refundAmountLabel];
    [refundAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.top.equalTo(self.contentView.mas_centerY).offset(2.5*kiphone6);
    }];
    refundAmountLabel.hidden = true;
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];
    self.itemLabel = itemLabel;
    self.timeLabel = timeLabel;
    self.moneyLabel = moneyLabel;
    self.refundAmountLabel = refundAmountLabel;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
