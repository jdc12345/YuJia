//
//  MYHomeViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MYHomeViewController.h"
#import "MYHomeTableViewCell.h"
#import "MYFamilyViewController.h"
#import "EquipmentManagerViewController.h"
//#import "MyRoomInfoViewController.h"
#import "MMHomeInfoViewController.h"
#import "PopListTableViewController.h"
#import "AllHomeModel.h"
#define inputW 20 // 输入框宽度
#define inputH 50  // 输入框高度
@interface MYHomeViewController ()<UITableViewDataSource, UITableViewDelegate,AccountDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, assign) CGFloat leftPodding;

/**
 * 当前账号选择框
 */
@property (nonatomic, copy) UIButton *curAccount;
@property (nonatomic, weak) UIButton *openBtn;

/**
 * 当前账号头像
 */
@property (nonatomic, copy) UIImageView *icon;

/**
 *  账号下拉列表
 */
@property (nonatomic, strong) PopListTableViewController *accountList;

/**
 *  下拉列表的frame
 */
@property (nonatomic) CGRect listFrame;
@property (nonatomic, copy) NSArray *selectStart;
@end

@implementation MYHomeViewController

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
        [_tableView registerClass:[MYHomeTableViewCell class] forCellReuseIdentifier:@"MYHomeTableViewCell"];
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
    self.title = @"我的家";
//    self.selectStart = @[@"lim创建的家",@"zzz创建的家"];
    [self tableView];
    [self httpRequestHomeInfo];
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[[MYFamilyViewController alloc]init ] animated:YES];
    }else if (indexPath.row == 2){
        [self.navigationController pushViewController:[[EquipmentManagerViewController alloc]init ] animated:YES];
    }else{
        [self.navigationController pushViewController:[[MMHomeInfoViewController alloc]init ] animated:YES];
    }
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
    MYHomeTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MYHomeTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"house_myhome"]];
        homeTableViewCell.titleLabel.text = @"我的房屋信息";
        
    }else if(indexPath.row == 1){
        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"Family_myhome"]];
        homeTableViewCell.titleLabel.text = @"我的家人管理";
    }else{
        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"equipmentmanagement_myhome"]];
        homeTableViewCell.titleLabel.text = @"我的设备管理";
    }
    //    homeTableViewCell.backgroundColor = [UIColor blackColor];
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    [headerView addSubview:_curAccount];
    [_curAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.right.equalTo(headerView);
    }];
    [self setPopMenu];
    return headerView;
}
/**
 * 设置下拉菜单
 */
- (void)setPopMenu {
    
    // 1.1帐号选择框
    
    //    _curAccount.center = CGPointMake(self.view.center.x, 200);
    // 默认当前账号为已有账号的第一个
    //    Account *acc = _dataSource[0];
    [_curAccount setTitle:@"我创建的家" forState:UIControlStateNormal];
    
    _curAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _curAccount.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    // 字体
    [_curAccount setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    _curAccount.titleLabel.font = [UIFont systemFontOfSize:14.0];
    // 边框
    _curAccount.layer.cornerRadius = 2.5;
    _curAccount.clipsToBounds = YES;
    _curAccount.layer.borderWidth = 0.5;
    _curAccount.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    // 显示框背景色
    [_curAccount setBackgroundColor:[UIColor whiteColor]];
    [_curAccount addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_curAccount];
    // 1.2图标
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, inputH-10, inputH-10)];
    _icon.layer.cornerRadius = (inputH-10)/2;
    [_icon setImage:[UIImage imageNamed:@""]];
    //    [_curAccount addSubview:_icon];
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn = [[UIButton alloc]init];
    [openBtn setImage:[UIImage imageNamed:@"v"] forState:UIControlStateNormal];
    [openBtn setImage:[UIImage imageNamed:@"^"] forState:UIControlStateSelected];
    [openBtn addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [openBtn sizeToFit];
    [_curAccount addSubview:openBtn];
    self.openBtn = openBtn;
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_curAccount.mas_centerY).with.offset(0);
        make.left.equalTo(_curAccount).with.offset(kScreenW/2.0 +35);
    }];
    
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList.delegate = self;
    // 数据
    _accountList.accountSource = self.selectStart;
    _accountList.isOpen = NO;
    _accountList.isCenter = YES;
    _accountList.cellHigh = 50;
    
    // 初始化frame
    [self updateListH];
    // 隐藏下拉菜单
    _accountList.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList];
    [self.view addSubview:_accountList.view];
}
/**
 *  监听代理更新下拉菜单                                 需要设置高度！！！！！！！！！！！！
 */
- (void)updateListH {
    CGFloat listH;
    // 数据大于3个现实3个半的高度，否则显示完整高度
    if (_dataSource.count > 3) {
        listH = inputH * 3.5;
    }else{
        listH = inputH * _dataSource.count;
    }
    _listFrame = CGRectMake(0, 50+64, kScreenW, 100);
    _accountList.view.frame = _listFrame;
}
/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList {
    NSLog(@"123123");
    [self.view bringSubviewToFront:_accountList.view];
    _accountList.isOpen = !_accountList.isOpen;
    self.openBtn.selected = _accountList.isOpen;
    if (_accountList.isOpen) {
        _accountList.view.frame = _listFrame;
    }
    else {
        _accountList.view.frame = CGRectZero;
    }
}
/**
 * 监听代理选定cell获取选中账号
 */
- (void)selectedCell:(NSInteger)index {
    // 更新当前选中账号
    //    Account *acc = _dataSource[index];
    
    NSString *title = self.selectStart[index];
    [_curAccount setTitle:title forState:UIControlStateNormal];
    _accountList.accountSource = self.selectStart;
//    [_accountList reloadDataSource];
    //    if (index == 0) {
    //        [self back_click];
    //    }else{
    //        [self back_click_location];
    //    }
    
    
    [_icon setImage:[UIImage imageNamed:@""]];
    // 关闭菜单
    [self openAccountList];
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mAllHome,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *allHome = responseObject[@"mapList"];
        NSMutableArray *nameList = [[NSMutableArray alloc]initWithCapacity:2];
        for (NSDictionary *dict in allHome) {
            AllHomeModel *homeModel = [AllHomeModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:homeModel];
            [nameList addObject:homeModel.familyName];
        }
        
      
        self.selectStart = nameList;
        _tableView.tableHeaderView = [self personInfomation];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
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
