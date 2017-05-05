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

static NSString* defaultRightCellid = @"defaultRight_cell";
@interface YJBillResultTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, weak) UILabel* itemLabel;
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

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ecebeb"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(5*kiphone6);
    }];
//    //添加line
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
//    [self.contentView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.offset(0);
//        make.height.offset(1*kiphone6);
//    }];
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.contentView addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.bottom.left.right.offset(0);
    }];
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultRightCellid];
//    [tableView registerClass:[YJBillInfoTableViewCell class] forCellReuseIdentifier:detailInfoCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *itemArr = @[@"城       市",@"小       区",@"业主姓名",@"手  机  号",@"小区楼号",@"楼       层",@"单       元",@"房       号"];
    UITableViewCell *cell = cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defaultRightCellid];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];

    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.row==0) {
       cell.textLabel.text = @"2017-5";
       cell.detailTextLabel.text = @"合计缴费：180.00元";
    }else if(indexPath.row==1){
        cell.textLabel.text = @"水费";
        cell.detailTextLabel.text = @"60.00元";
    }else if(indexPath.row==2){
        cell.textLabel.text = @"电费";
        cell.detailTextLabel.text = @"60.00元";
    }else if(indexPath.row==3){
        cell.textLabel.text = @"燃气费";
        cell.detailTextLabel.text = @"60.00元";
    }

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 37*kiphone6;
    }
    return 45*kiphone6;
}


@end
