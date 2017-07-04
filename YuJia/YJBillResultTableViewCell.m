//
//  YJBillResultTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJBillResultTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import "YJMonthDetailItemModel.h"

static NSString* defaultRightCellid = @"defaultRight_cell";
@interface YJBillResultTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, weak) UILabel* itemLabel;
//@property(nonatomic,strong)NSMutableArray *models;
@property(nonatomic,strong)NSString *waters;
@property(nonatomic,strong)NSString *electric;
@property(nonatomic,strong)NSString *gas;
@end
@implementation YJBillResultTableViewCell

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
-(void)setSumModel:(YJMonthDetailSumModel *)sumModel{
    _sumModel = sumModel;
    if (sumModel.moneySum) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in sumModel.items) {
            YJMonthDetailItemModel *infoModel = [YJMonthDetailItemModel mj_objectWithKeyValues:dic];
            if (infoModel.paymentItemId == 1) {
                self.waters = [NSString stringWithFormat:@"%ld元",infoModel.money];
            }if (infoModel.paymentItemId == 2) {
                self.electric = [NSString stringWithFormat:@"%ld元",infoModel.money];
            }if (infoModel.paymentItemId == 3) {
                self.gas = [NSString stringWithFormat:@"%ld元",infoModel.money];
            }
            [mArr addObject:infoModel];
        }
    }
    [self.tableView reloadData];
    
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    //添加tableView
    UIView *backView = [[UIView alloc]init];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15*kiphone6);
        make.right.offset(-15*kiphone6);
    }];
    [backView layoutIfNeeded];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [backView addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
//    阴影的颜色
    backView.layer.shadowColor = [UIColor colorWithHexString:@"#158070"].CGColor;
//    阴影的透明度
    backView.layer.shadowOpacity = 0.8f;
//    阴影的圆角
    backView.layer.shadowRadius = 6.f;
//    阴影偏移量
    backView.layer.shadowOffset = CGSizeMake(0,3);

//    CALayer *layer = [tableView layer];//加阴影
//        layer.shadowOffset = CGSizeMake(3, 6);
//        layer.shadowRadius = 5.0;
//        layer.shadowColor = [UIColor blackColor].CGColor;
//        layer.shadowOpacity = 0.8;
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultRightCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.scrollEnabled = false;
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *itemArr = @[@"城       市",@"小       区",@"业主姓名",@"手  机  号",@"小区楼号",@"楼       层",@"单       元",@"房       号"];
    UITableViewCell *cell = cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultRightCellid];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];

    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row==0) {
       cell.textLabel.text = self.sumModel.time;
       cell.detailTextLabel.text = [NSString stringWithFormat:@"合计缴费：%ld元", self.sumModel.moneySum];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#00eac6"];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#00eac6"];
    }else if(indexPath.row==1){
        cell.textLabel.text = @"水费";
        cell.detailTextLabel.text = self.waters?self.waters:@"0元";
    }else if(indexPath.row==2){
        cell.textLabel.text = @"电费";
        cell.detailTextLabel.text = self.electric?self.electric:@"0元";
    }else if(indexPath.row==3){
        cell.textLabel.text = @"燃气费";
        cell.detailTextLabel.text = self.gas?self.gas:@"0元";
    }

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return 37*kiphone6;
//    }
    return 46*kiphone6;
}


@end
