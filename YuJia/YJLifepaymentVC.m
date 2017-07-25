//
//  YJLifepaymentVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJLifepaymentVC.h"
#import "UIColor+colorValues.h"
#import "UILabel+Addition.h"
#import "YJModifyAddressVC.h"
#import "YJAddPropertyBillAddressVC.h"
#import "YJPayItemTableViewCell.h"
#import "YJPayItemModel.h"
#import "YJEditNumberVC.h"
#import "YJInputPayNumberVC.h"
#import "UIViewController+Cloudox.h"
#import "YJPayPropertyVC.h"
#import "YJPayRecoderVC.h"

static NSString* emptyCellid = @"empty_cell";
static NSString* payCellid = @"pay_cell";

@interface YJLifepaymentVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *emptyTableView;
@property(nonatomic,weak)UITableView *payTableView;
@property(nonatomic,assign)BOOL isBill;
@property(nonatomic,strong)NSArray *payItemArr;
@end

@implementation YJLifepaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活缴费";
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    
}
- (void)loadData {
    BOOL isBill = true;//请求判断是否是业主，依据地址请求账单
    self.isBill = isBill;
    NSArray *iconArr = @[@"electricity_pay",@"water_pay",@"gas_pay",@"property_pay"];
    NSArray *itemArr = @[@"电费",@"水费",@"燃气费",@"物业费"];
    NSArray *numberArr = @[@"111111",@"111111",@"",@""];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        YJPayItemModel *payItemModel = [[YJPayItemModel alloc]init];
        payItemModel.icon = iconArr[i];
        payItemModel.item = itemArr[i];
        payItemModel.number = numberArr[i];
        [modelArr addObject:payItemModel];
    }
    self.payItemArr = modelArr;
    if (isBill) {
        NSMutableArray* rightItemArr = [NSMutableArray array];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;
        [rightItemArr addObject:negativeSpacer];//修正按钮离屏幕边缘位置的UIBarButtonItem应在按钮的前边加入数组
        UIButton *payRecordBtn = [[UIButton alloc]init];
        [payRecordBtn setTitle:@"缴费记录" forState:UIControlStateNormal];
        payRecordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [payRecordBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [payRecordBtn sizeToFit];
        [payRecordBtn addTarget:self action:@selector(payRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:payRecordBtn];
        [rightItemArr addObject:rightBarItem];
        self.navigationItem.rightBarButtonItems = rightItemArr;//导航栏右侧按钮
        //缴费项目tableView
        [self setupTableView];
    }else{
        [self addAddress];
    }
}
- (void)payRecordBtnClick{
    //跳转缴费记录页面
    YJPayRecoderVC *vc = [[YJPayRecoderVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
- (void)addAddress{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.emptyTableView = tableView;
    [self.view addSubview:tableView];
    self.emptyTableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:emptyCellid];
    //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;

}
- (void)setupTableView{
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
    [tableView registerClass:[YJPayItemTableViewCell class] forCellReuseIdentifier:payCellid];
    //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
  
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.emptyTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCellid forIndexPath:indexPath];
        NSArray *imageArr = @[@"un_electricity",@"un_water",@"un_gas",@"un_propery"];
        cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
        NSArray *itemArr = @[@"电费",@"水费",@"燃气费",@"物业费"];
        cell.textLabel.text = itemArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        //添加line
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(1*kiphone6);
        }];

        return cell;
    }else{
        YJPayItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payCellid forIndexPath:indexPath];
        cell.model = self.payItemArr[indexPath.row];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 86*kiphone6)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 76*kiphone6)];
    [headerBtn setImage:[UIImage imageNamed:@"address_backPhoto"] forState:UIControlStateNormal];
    [view addSubview:headerBtn];
    headerBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_info"]];
    [headerBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerBtn);
    }];
    if (tableView == self.emptyTableView) {
        UILabel *addressLabel = [UILabel labelWithText:@"无信息" andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
        [headerBtn addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerBtn);
            make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
        }];
        self.clickBtnBlock = ^(NSString *address) {
            addressLabel.text = address;
            //此处需要根据新地址刷新账单
            
            
            
        };

    }else{
        UILabel *addressLabel = [UILabel labelWithText:@"名流一品小区" andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
        [headerBtn addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_centerY).offset(2.5*kiphone6);
            make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
        }];
        self.clickBtnBlock = ^(NSString *address) {
            addressLabel.text = address;
            //此处需要根据新地址刷新账单
            
            
            
        };
        
        UILabel *cityLabel = [UILabel labelWithText:@"河北" andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:17];
        [headerBtn addSubview:cityLabel];
        [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addressLabel.mas_top).offset(-5*kiphone6);
            make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
        }];
    }
    UIImageView *gray_forward = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gray_forward"]];
    [headerBtn addSubview:gray_forward];
    [gray_forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(headerBtn);
    }];
    [headerBtn addTarget:self action:@selector(goAddAddress) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 86*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.emptyTableView) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
        footerView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [btn setTitle:@"添加小区" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
        btn.layer.borderWidth = 1;
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(40*kiphone6);
            make.centerX.equalTo(footerView);
            make.width.offset(325*kiphone6);
            make.height.offset(45*kiphone6);
        }];
        [btn addTarget:self action:@selector(goAddAddress) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        return footerView;

    }else{
        return nil;
    }
    }
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.emptyTableView==tableView) {
        return 100*kiphone6;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    YJEditNumberVC *vc = [[YJEditNumberVC alloc]init];
    NSArray *itemArr = @[@"电费",@"水费",@"燃气费",@"物业费"];
    vc.title = itemArr[indexPath.row];
    if (indexPath.row==3) {
        YJPayPropertyVC *vc = [[YJPayPropertyVC alloc]init];
        vc.title = itemArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:true];

    }else{
       [self.navigationController pushViewController:vc animated:true]; 
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了修改");
        YJEditNumberVC *vc = [[YJEditNumberVC alloc]init];
        vc.payItem = @"修改编号";
        //vc.title = @"修改编号";
        [self.navigationController pushViewController:vc animated:true];

        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    
    return @[ action0];
}

- (void)modifyAddress{
    YJModifyAddressVC *vc = [[YJModifyAddressVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
- (void)goAddAddress{
    YJModifyAddressVC *vc = [[YJModifyAddressVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
    if (self.emptyTableView&&self.isBill) {
        [self.emptyTableView removeFromSuperview];
        [self loadData];
    }
    
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
