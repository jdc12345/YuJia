//
//  LockSettingViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LockSettingViewController.h"
#import "LockSettingTableViewCell.h"
#import "AirModelTableViewCell.h"
#import "LockChangePWViewController.h"
#import "LockRecardViewController.h"
@interface LockSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@end

@implementation LockSettingViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenW, kScreenH -352.25) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[LockSettingTableViewCell class] forCellReuseIdentifier:@"LockSettingTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
//        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@"修改密码",@"开锁记录"]];
    self.iconList =@[@"self-motion_small",@"cold_small",@"hot_small",@"wet_small",@"wind_small"];
    [self tableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 32)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"模式选择";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).with.offset(0);
        make.left.equalTo(headerView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50 ,12));
    }];
    
    
    // 中间灰条
    UILabel *grayLabelBottom = [[UILabel alloc]init];
    grayLabelBottom.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [headerView addSubview:grayLabelBottom];
    
    [grayLabelBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(32);
        make.centerX.equalTo(headerView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,1));
    }];
    
    return headerView;
}
#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[LockChangePWViewController alloc]init] animated:YES];
        }else{
            
            [self.navigationController pushViewController:[[LockRecardViewController alloc]init] animated:YES];
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            
        }else if(indexPath.row == 1){
            
        }else{
            
        }
        
        
        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LockSettingTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"LockSettingTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.row];
//    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    
    return homeTableViewCell;
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
