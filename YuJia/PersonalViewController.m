//
//  PersonalViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIColor+Extension.h"
#import "YYPersonalTableViewCell.h"
#import "MMButton.h"
#import "EditPersonalViewController.h"
#import "MYHomeViewController.h"

@interface PersonalViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UIImageView *navBarHairlineImageView;
    UIImageView *tabBarHairlineImageView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
//@property (nonatomic, strong) YYHomeUserModel *personalModel;

@property (nonatomic, weak) UIButton *rightNotBtn;

@end

@implementation PersonalViewController
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
        [_tableView registerClass:[YYPersonalTableViewCell class] forCellReuseIdentifier:@"YYPersonalTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//        self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"收货地址"],@[@"关于宇家",@"意见反馈"]]];
    self.iconList =@[@[@"address"],@[@"about",@"opinion"]];
    // 左侧地址按钮   测
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setFrame:CGRectMake(0,0,20, 20)];
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftButton sizeToFit];
    
    // 右侧通知按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0,0,20, 20)];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(pushNotficVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton sizeToFit];
    
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // 改变navBar 下面的线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    UILabel *coverView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    coverView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [navBarHairlineImageView removeFromSuperview];
    [navBarHairlineImageView addSubview:coverView];
    
    [self tableView];
    
//    self.rightNotBtn = rightButton;
    
    // Do any additional setup after loading the view.
}
/**
 * PS:navigation  下面的线
 */
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 230)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    personV.backgroundColor = [UIColor whiteColor];
    personV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_color"]];
    
    
    [headerView addSubview:personV];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
;
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconV.layer.cornerRadius = 32.5 *kiphone6;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"赵启平";
    nameLabel.textColor = [UIColor colorWithHexString:@"6a6a6a"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //
    UILabel *idName = [[UILabel alloc]init];
//    idName.text = @"涿州市中医院  检验科";
    idName.textColor = [UIColor colorWithHexString:@"6a6a6a"];
    idName.font = [UIFont systemFontOfSize:12];
    idName.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.backgroundColor = [UIColor cyanColor];
    [settingBtn addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *notficVC = [UIButton buttonWithType:UIButtonTypeCustom];
    notficVC.backgroundColor = [UIColor cyanColor];
    [notficVC addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:idName];
    
    [personV addSubview:settingBtn];
    [personV addSubview:notficVC];
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personV).with.offset(15);
        make.centerY.equalTo(personV);
        make.size.mas_equalTo(CGSizeMake(65 , 65 ));
    }];

    NSString * nameStr = @"赵启平";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [nameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV);
        make.left.equalTo(iconV.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, 14));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10 *kiphone6);
        make.left.equalTo(personV).with.offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14 *kiphone6));;
    }];
    
    self.nameLabel = nameLabel;
    self.idLabel = idName;
    self.iconV = iconV;
    
    personV.backgroundColor = [UIColor colorWithHexString:@"c0eefd"];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"woman"];
    [imageV sizeToFit];
    [personV addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV);
        make.left.equalTo(nameLabel.mas_right).with.offset(5 *kiphone6);
    }];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"compile"] forState:UIControlStateNormal];
    [editBtn sizeToFit];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [editBtn addTarget:self action:@selector(editPersonal) forControlEvents:UIControlEventTouchUpInside];

    [personV addSubview:editBtn];
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV);
        make.left.equalTo(imageV.mas_right).with.offset(10 *kiphone6);
    }];
    
    NSArray *nameList = @[@"我的家",@"我的圈子",@"我的订单",@"我的收藏"];
    NSArray *iconList = @[@"myhome",@"mycircle",@"MyOrder",@"collect"];
    
    
    CGFloat btnW = kScreenW/4.0;
    for (int i = 0 ; i<4 ;  i++) {
        MMButton *leftNavBtn = [MMButton buttonWithType:UIButtonTypeCustom];
        leftNavBtn.frame = CGRectMake(i *btnW, 130, btnW, 100);
        leftNavBtn.tag = 800 +i;
        leftNavBtn.backgroundColor = [UIColor whiteColor];
        [leftNavBtn setTitle:nameList[i] forState:UIControlStateNormal];
        [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [leftNavBtn setImage:[UIImage imageNamed:iconList[i]] forState:UIControlStateNormal];
        leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [leftNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:leftNavBtn];
        
    }

    
    
    
    return headerView;
}
- (void)headViewClick{
    NSLog(@"123");
    //    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
    //    pInfoVC.personalModel = self.personalModel;
    //    [self.navigationController pushViewController:pInfoVC animated:YES];
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
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataSource[section];
    return list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    return headerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPersonalTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYPersonalTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.section][indexPath.row];
    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.section][indexPath.row]];
    
    return homeTableViewCell;
}
- (void)editPersonal{
    EditPersonalViewController *editVC = [[EditPersonalViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)action:(UIButton *)sender{
    switch (sender.tag -800) {
        case 0:
            [self.navigationController pushViewController:[[MYHomeViewController alloc]init] animated:YES];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
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
