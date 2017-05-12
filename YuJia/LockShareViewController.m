//
//  LockShareViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LockShareViewController.h"
#import "YYPersonalTableViewCell.h"
#import "LockShareTableViewCell.h"
@interface LockShareViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@end

@implementation LockShareViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenW, kScreenH -352.25 -44) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[LockShareTableViewCell class] forCellReuseIdentifier:@"LockShareTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        _tableView.tableFooterView = [self footSelection];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@"自动",@"制冷",@"制热",@"除湿",@"送风"]];
    self.iconList =@[@"self-motion_small",@"cold_small",@"hot_small",@"wet_small",@"wind_small"];
    [self tableView];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, kScreenW, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 44));
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"分享给";
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
        make.bottom.equalTo(headerView).with.offset(0);
        make.centerX.equalTo(headerView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,1));
    }];
    
    return headerView;
}
- (UIView *)footSelection{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 72)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"分享给";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).with.offset(0);
        make.left.equalTo(headerView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(39 ,12));
    }];
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10, 16, 60, 12);
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor colorWithHexString:@"00bfff"] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.layer.cornerRadius = 2.5;
    selectBtn.clipsToBounds = YES;
    selectBtn.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    selectBtn.layer.borderWidth = 1;

    [headerView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).with.offset(0);
        make.left.equalTo(titleLabel.mas_right).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(85 ,32));
    }];
    
    
    return headerView;
}
#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //            NSString *nameStr = @"salkjdklasjdklajslk";
            //            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            //            CGRect rect = [nameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
            //                                                options:NSStringDrawingUsesLineFragmentOrigin
            //                                             attributes:attributes
            //                                                context:nil];
            //            self.nameLabel.text = nameStr;
            //            self.nameLabel.frame = rect;
        }else{
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            
        }else if(indexPath.row == 1){
            
        }else{
            
        }
        
        
        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //    self.tabBarController.selectedIndex = 4;
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
    LockShareTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"LockShareTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.row];
    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    
    return homeTableViewCell;
}
- (void)action:(UIButton *)sender{
    
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

