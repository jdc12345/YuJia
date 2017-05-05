//
//  YJAddPropertyBillAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddPropertyBillAddressVC.h"
#import "YJCityTableViewCell.h"
#import "YJBillInfoTableViewCell.h"
#import "YJPropertyBillVC.h"

static NSString* cityCellid = @"city_cell";
static NSString* detailInfoCellid = @"detailInfo_cell";
@interface YJAddPropertyBillAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@end

@implementation YJAddPropertyBillAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加地址";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
}
- (void)setupUI {
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.bottom.left.right.offset(0);
    }];
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCityTableViewCell class] forCellReuseIdentifier:cityCellid];
    [tableView registerClass:[YJBillInfoTableViewCell class] forCellReuseIdentifier:detailInfoCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(submitAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    tableView.tableFooterView = footerView;
  
}
- (void)submitAddress{
    YJPropertyBillVC *vc = [[YJPropertyBillVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *itemArr = @[@"城       市",@"小       区",@"业主姓名",@"手  机  号",@"小区楼号",@"楼       层",@"单       元",@"房       号"];
    if (indexPath.row<2) {
        YJCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellid forIndexPath:indexPath];
        cell.item = itemArr[indexPath.row];
        return cell;
    }else{
        YJBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellid forIndexPath:indexPath];
        cell.item = itemArr[indexPath.row];
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*kiphone6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
