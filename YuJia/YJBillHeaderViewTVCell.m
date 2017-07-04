//
//  YJBillHeaderViewTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJBillHeaderViewTVCell.h"

@implementation YJBillHeaderViewTVCell

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
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15*kiphone6, 20*kiphone6, 345*kiphone6, 44*kiphone6)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#373840"];
        [self.contentView addSubview:headerView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    headerView.layer.mask = maskLayer;
        //添加line
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#03c2a5"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.left.offset(15*kiphone6);
            make.right.offset(-15*kiphone6);
            make.height.offset(1*kiphone6);
        }];
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    //添加tableView
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
