//
//  MYFamilyViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MYFamilyViewController.h"
#import "MYFamilyTableViewCell.h"
#import "UIBarButtonItem+Helper.h"
#import "FamilyPersonalViewController.h"

@interface MYFamilyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentRow;


@end

@implementation MYFamilyViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_tableView registerClass:[MYFamilyTableViewCell class] forCellReuseIdentifier:@"MYFamilyTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        
        
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的家人管理";
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5 *kiphone6)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" normalColor:[UIColor colorWithHexString:@"00bfff"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(pushToAdd)];
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[[FamilyPersonalViewController alloc]init] animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MYFamilyTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MYFamilyTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"avatar.jpg"]];
        homeTableViewCell.titleLabel.text = @"LIM";
        
    }else if(indexPath.row == 1){
        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"avatar.jpg"]];
        homeTableViewCell.titleLabel.text = @"赵医生";
    }else{
        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"avatar.jpg"]];
        homeTableViewCell.titleLabel.text = @"安迪";
    }
    //    homeTableViewCell.backgroundColor = [UIColor blackColor];
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
    
}
- (void)pushToAdd{
    
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
