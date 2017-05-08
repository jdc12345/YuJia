//
//  YJEditNumberVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJEditNumberVC.h"
#import "UIColor+colorValues.h"
#import "UILabel+Addition.h"
#import "YJInputPayNumberVC.h"
static NSString* payCellid = @"pay_cell";
@interface YJEditNumberVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *payTableView;
@property(nonatomic,strong)NSArray *payItemArr;
@property(nonatomic,weak)UITextField *numberField;

@end

@implementation YJEditNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self loadData];
}

- (void)loadData {
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.payTableView = tableView;
    [self.view addSubview:tableView];
    self.payTableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:payCellid];
    
    tableView.delegate =self;
    tableView.dataSource = self;
    
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payCellid];;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    NSArray *itemArr = @[@"缴费单位",@"用户编号"];
    cell.textLabel.text = itemArr[indexPath.row];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];

    if (indexPath.row==0) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.detailTextLabel.text = @"名流一品物业";
    }else{
        //添加电话textField
        UITextField *numberField = [[UITextField alloc]init];
        numberField.font = [UIFont boldSystemFontOfSize:13];
        numberField.placeholder = @"查看纸质账单";
        [numberField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [numberField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        numberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
        [cell.contentView addSubview:numberField];
        [numberField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.textLabel.mas_right).offset(10*kiphone6);
            make.centerY.equalTo(cell.textLabel);
            make.right.offset(-10*kiphone6);
            make.height.equalTo(cell.textLabel);
        }];
        self.numberField = numberField;
        numberField.delegate = self;

    }
    return cell;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 74*kiphone6)];
    headerBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_info"]];
    [headerBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerBtn).offset(-5*kiphone6);
    }];
    UILabel *addressLabel = [UILabel labelWithText:@"名流一品小区" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:13];
    [headerBtn addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_centerY).offset(2.5*kiphone6);
            make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
    }];
    UILabel *cityLabel = [UILabel labelWithText:@"河北" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [headerBtn addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addressLabel.mas_top).offset(-5*kiphone6);
            make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
    }];
    UIImageView *gray_forward = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gray_forward"]];
    [headerBtn addSubview:gray_forward];
    [gray_forward mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10*kiphone6);
            make.centerY.equalTo(headerBtn).offset(-5*kiphone6);
    }];
    [headerBtn addTarget:self action:@selector(goAddAddress) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [headerBtn addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(5*kiphone6);
    }];
    return headerBtn;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 74*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    if (self.payItem) {
        [btn setTitle:self.payItem forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(holdNumber) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goInputPayMoney) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
    
        [footerView addSubview:btn];
    
        return footerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
        return 100*kiphone6;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}


-(void)setPayItem:(NSString *)payItem{
    _payItem = payItem;
    self.title = self.payItem;
    [self tableView:self.payTableView viewForFooterInSection:0];
    
}
-(void)goInputPayMoney{
    YJInputPayNumberVC *vc = [[YJInputPayNumberVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
-(void)holdNumber{
    //接保存编号的接口
    
    
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
