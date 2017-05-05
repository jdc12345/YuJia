//
//  AddSightViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AddSightViewController.h"
#import "EquipmentTableViewCell.h"
#import "PopListTableViewController.h"
#define inputW 230 // 输入框宽度
#define inputH 35  // 输入框高度

@interface AddSightViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) CGFloat leftPodding;

/**
 * 当前账号选择框
 */
@property (nonatomic, copy) UIButton *curAccount;
@property (nonatomic, weak) UIButton *openBtn;

///**
// *  当前选中账号
// */
//@property (nonatomic, strong) Account *curAcc;

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

@end

@implementation AddSightViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:@"EquipmentTableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        _tableView.tableFooterView = [self customFootView];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加情景";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UILabel *sectionTitleLabel  = [[UILabel alloc]init];
    sectionTitleLabel.text = @"执 行 任 务";
    sectionTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    sectionTitleLabel.font = [UIFont systemFontOfSize:14];
    
    
    [sectionView addSubview:sectionTitleLabel];
    [sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView).with.offset(18);
        make.left.equalTo(sectionView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,14));
    }];
    
    return sectionView;
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3 +1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    // 图标  情景设置setting  灯light 电视tv 插座socket
    EquipmentTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentTableViewCell" forIndexPath:indexPath];
    if(indexPath.row == 3){
        homeTableViewCell.titleLabel.text = @"添加";
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"+-1"];
        [homeTableViewCell cellMode:YES];
        homeTableViewCell.switch0.hidden = YES;
    }else{
        homeTableViewCell.titleLabel.text = @"客厅灯";
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"light"];
        [homeTableViewCell cellMode:YES];
    }
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}
- (void)action:(NSString *)actionStr{
    NSLog(@"点什么点");
}
- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 135)];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSString *sightName = @"情 景 名 称";
    NSString *startW = @"启 动 条 件";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [sightName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
    
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    
//    UITextField  *startWText = [[UITextField alloc]init];
//    startWText.textColor = [UIColor colorWithHexString:@"333333"];
//    startWText.font = [UIFont systemFontOfSize:14];
//    
//    startWText.layer.cornerRadius = 2.5;
//    startWText.clipsToBounds = YES;
//    startWText.layer.borderWidth = 1;
//    startWText.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
//    startWText.text = @"一键启动";
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    
    
    CGRect frame = CGRectMake(0, 0, 10.0, 30);
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
//    startWText.leftViewMode = UITextFieldViewModeAlways;
//    startWText.leftView = leftview;
    
    // ？？？？
    //    sightNameText.leftViewMode = UITextFieldViewModeAlways;
    //    sightNameText.leftView = leftview;
    UIView *sightLeftView = [[UIView alloc] initWithFrame:frame];
    sightNameText.leftViewMode = UITextFieldViewModeAlways;
    sightNameText.leftView = sightLeftView;
    
    
    UILabel *sightNameLabel = [[UILabel alloc]init];
    sightNameLabel.text = sightName;
    sightNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    sightNameLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *startWLabel = [[UILabel alloc]init];
    startWLabel.text = startW;
    startWLabel.textColor = [UIColor colorWithHexString:@"333333"];
    startWLabel.font = [UIFont systemFontOfSize:14];
    
    
    [headView addSubview:sightNameText];
    [headView addSubview:_curAccount];
    [headView addSubview:sightNameLabel];
    [headView addSubview:startWLabel];
    
    
    [sightNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).with.offset(25);
        make.left.equalTo(headView).with.offset(35 +rect.size.width);
        make.size.mas_equalTo(CGSizeMake(210 ,30));
    }];
    [_curAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sightNameText.mas_bottom).with.offset(25);
        make.left.equalTo(headView).with.offset(35 +rect.size.width);
        make.size.mas_equalTo(CGSizeMake(210 ,30));
    }];
    
    [sightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sightNameText.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(rect.size.width +5,14));
    }];
    [startWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_curAccount.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(rect.size.width +5,14));
    }];
    
    
    self.leftPodding = 35 +rect.size.width;
    
    // 设置下拉菜单
    [self setPopMenu];
    
    
    return headView;
}
- (UIView *)customFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 74)];
    footView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"确定添加" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [footView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(30);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    
    return footView;
}

/**
 * 设置下拉菜单
 */
- (void)setPopMenu {
    
    // 1.1帐号选择框
    
//    _curAccount.center = CGPointMake(self.view.center.x, 200);
    // 默认当前账号为已有账号的第一个
//    Account *acc = _dataSource[0];
    [_curAccount setTitle:@"一键启动" forState:UIControlStateNormal];
    
    _curAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _curAccount.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
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
        make.right.equalTo(_curAccount).with.offset(-10);
    }];
    
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList.delegate = self;
    // 数据
    _accountList.accountSource = @[@"定时启动",@"定位启动"];
    _accountList.isOpen = NO;
    
    // 初始化frame
    [self updateListH];
    // 隐藏下拉菜单
    _accountList.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList];
    [self.view addSubview:_accountList.view];
}
/**
 *  监听代理更新下拉菜单
 */
- (void)updateListH {
    CGFloat listH;
    // 数据大于3个现实3个半的高度，否则显示完整高度
    if (_dataSource.count > 3) {
        listH = inputH * 3.5;
    }else{
        listH = inputH * _dataSource.count;
    }
    _listFrame = CGRectMake(_leftPodding, 174, 210, 60);
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
    [_icon setImage:[UIImage imageNamed:@""]];
    [_curAccount setTitle:@"" forState:UIControlStateNormal];
    // 关闭菜单
    [self openAccountList];
}

@end
