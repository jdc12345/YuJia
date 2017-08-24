//
//  AddFamilyInfoViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AddFamilyInfoViewController.h"
#import "AddFamilyInfoTableViewCell.h"
#import "PopListTableViewController.h"
#import <UIImageView+WebCache.h>
#import "UIBarButtonItem+Helper.h"
#import "MYFamilyViewController.h"

@interface AddFamilyInfoViewController ()<UITableViewDataSource, UITableViewDelegate,AccountDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;




@property (nonatomic, copy) UIButton *curAccount;
@property (nonatomic, weak) UIButton *openBtn;
@property (nonatomic, copy) NSArray *selectStart;
@property (nonatomic, weak) UILabel *startModelLabel;
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
@property (nonatomic, assign) CGFloat leftPodding;
@property (nonatomic, strong) UITextField *commentBtn;
@property (nonatomic, strong) NSString *currentTitle;
@end
#define inputW 230 // 输入框宽度
#define inputH 35  // 输入框高度
@implementation AddFamilyInfoViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[AddFamilyInfoTableViewCell class] forCellReuseIdentifier:@"AddFamilyInfoTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家人信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.dataSource addObjectsFromArray:@[@"控制我的设备",@"控制我的门锁",@"添加设备到我的家",@"从我的家删除设备"]];
    
    self.selectStart = @[@"家人",@"租户",@"访客",@"自定义"];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" normalColor:[UIColor colorWithHexString:@"00bfff"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(httpRequestInfo)];
    //    [self.view addSubview:[self personInfomation]];
    [self tableView];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:@"确认添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(httpRequestInfo) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth =  1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#0ddcbc"].CGColor;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-40*kiphone6);
        make.centerX.equalTo(self.view);
        make.width.offset(150*kiphone6);
        make.height.offset(45*kiphone6);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 170)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenW -20, 90)];
    personV.backgroundColor = [UIColor whiteColor];
    
    //    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
    //    [personV addGestureRecognizer:tapGest];
    
    UIImageView *iconV = [[UIImageView alloc]init];
    [iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]] placeholderImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconV.layer.cornerRadius = 30;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = [NSString stringWithFormat:@"%@  %@",self.personalModel.userName,self.personalModel.comment];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    //
    UILabel *idName = [[UILabel alloc]init];
    idName.text = [NSString stringWithFormat:@"%@",self.personalModel.telephone];
    idName.textColor = [UIColor colorWithHexString:@"#333333"];
    idName.font = [UIFont systemFontOfSize:14];
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:idName];
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV).with.offset(0);
        make.left.equalTo(personV).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60 , 60));
    }];
    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV).with.offset(23.5 );
        make.left.equalTo(iconV.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(140 , 14 ));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(15 );
        make.left.equalTo(nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(260, 14));
    }];
    
    self.nameLabel = nameLabel;
    self.idLabel = idName;
    self.iconV = iconV;
    
    
//    Remarks
    UIView *remarksView = [[UIView alloc]initWithFrame:CGRectMake(10, 110, kScreenW -20, 50)];
    remarksView.backgroundColor = [UIColor whiteColor];
    
    UILabel *remarkLabel = [[UILabel alloc]init];
    remarkLabel.text = @"备注";
    remarkLabel.textColor = [UIColor colorWithHexString:@"333333"];
    remarkLabel.font = [UIFont systemFontOfSize:14];
    
    
    [remarksView addSubview:remarkLabel];
    
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remarksView).with.offset(0);
        make.left.equalTo(remarksView).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(30 , 14));
    }];
    
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 185, 30)];
    _curAccount.backgroundColor = [UIColor redColor];
    [remarksView addSubview:_curAccount];
    [_curAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remarksView);
        make.left.equalTo(remarkLabel.mas_right).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(185 , 30));
    }];
    ////////自定义
    UITextField *newNumberTextF = [[UITextField alloc]init];
    newNumberTextF.font = [UIFont systemFontOfSize:15];
    newNumberTextF.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberTextF.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    newNumberTextF.layer.borderWidth = 1;
    newNumberTextF.layer.cornerRadius = 2.5;
    newNumberTextF.clipsToBounds = YES;
    newNumberTextF.textAlignment = NSTextAlignmentLeft;
    
    [remarksView addSubview:newNumberTextF];
    
    [newNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remarksView).with.offset(0);
        make.left.equalTo(remarkLabel.mas_right).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(185 , 30));
    }];
    self.commentBtn = newNumberTextF;
    self.commentBtn.hidden = YES;
    ////////
    [headView addSubview:remarksView];
    [headView addSubview:personV];
    
    [self setPopMenu];
    return headView;
}

#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    [self.navigationController pushViewController:[[FamilyPersonalViewController alloc]init] animated:YES];
    AddFamilyInfoTableViewCell *familyCell = [tableView cellForRowAtIndexPath:indexPath];
    familyCell.iconBtn.selected  = !familyCell.iconBtn.selected;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenW -20, 40)];
    personV.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"权限选择";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    [personV addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV).with.offset(0);
        make.left.equalTo(personV).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(50 ,12));
    }];
  
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [personV addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV.mas_bottom).with.offset(0);
        make.left.equalTo(personV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 20 , 1));
    }];
    
    [headView addSubview:personV];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFamilyInfoTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AddFamilyInfoTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.row];
    //    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}

/**
 * 设置下拉菜单
 */
- (void)setPopMenu {
    
    // 1.1帐号选择框
    
    //    _curAccount.center = CGPointMake(self.view.center.x, 200);
    // 默认当前账号为已有账号的第一个
    //    Account *acc = _dataSource[0];
    [_curAccount setTitle:@"家人" forState:UIControlStateNormal];
    self.currentTitle = @"家人";
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
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 0, 10)];
    _icon.layer.cornerRadius = (10)/2;
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
    _accountList.accountSource = self.selectStart;
    _accountList.isOpen = NO;
    _accountList.isCenter = NO;
    _accountList.cellHigh = 30;
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
//    CGFloat listH;
//    // 数据大于3个现实3个半的高度，否则显示完整高度
//    if (_dataSource.count > 3) {
//        listH = inputH * 3.5;
//    }else{
//        listH = inputH * _dataSource.count;
//    }
    _listFrame = CGRectMake(100, 150, 185, 120);
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
- (void)selectedCell:(NSInteger)index {
    // 更新当前选中账号
    //    Account *acc = _dataSource[index];
    
    NSString *title = self.selectStart[index];
    self.currentTitle = title;
    [_curAccount setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"自定义"]) {
        _curAccount.hidden = YES;
        _commentBtn.hidden = NO;
    }
//    else if([title isEqualToString:@"定位启动"]){
////        [self back_click_location];
//        self.selectStart = @[@"一键启动",@"定时启动"];
//    }else{
//        self.selectStart = @[@"定时启动",@"定位启动"];
//    }
    _accountList.accountSource = self.selectStart;
    [_accountList reloadDataSource];
    //    if (index == 0) {
    //        [self back_click];
    //    }else{
    //        [self back_click_location];
    //    }
    
    
    [_icon setImage:[UIImage imageNamed:@""]];
    // 关闭菜单
    [self openAccountList];
}
- (void)httpRequestInfo{
    
    NSMutableArray *pmsnArray = [[NSMutableArray alloc]initWithCapacity:2];;
    for (int i = 0; i<4; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AddFamilyInfoTableViewCell *familyCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(familyCell.iconBtn.selected){
            [pmsnArray addObject:@"1"];
        }else{
            [pmsnArray addObject:@"0"];
        }
    }
    NSLog(@"array = %@",self.personalModel.info_id);
    NSDictionary *dict2 = @{
                            @"token":mDefineToken2,
                            @"homePersonalId":self.personalModel.info_id,
                            @"comment":self.currentTitle,
                            @"pmsnCtrlDevice":pmsnArray[0],
                            @"pmsnCtrlDoor":pmsnArray[1],
                            @"pmsnCtrlAdd":pmsnArray[2],
                            @"pmsnCtrlDel":pmsnArray[3]
                            };
    
    NSLog(@"dict2 = %@",dict2);
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mSetFamilyUsers] method:1 parameters:dict2 prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"添加成员成功"];
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[MYFamilyViewController class]]) {
                [self.navigationController popToViewController:vc animated:true];

                break;
                
            }
        }
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
