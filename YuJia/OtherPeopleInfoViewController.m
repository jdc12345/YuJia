//
//  OtherPeopleInfoViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "OtherPeopleInfoViewController.h"
#import "UIColor+Extension.h"
#import "YYPersonalTableViewCell.h"
#import "MMButton.h"
#import "EditPersonalViewController.h"
#import "MYHomeViewController.h"
#import "PersonalSettingViewController.h"
#import "PersonalModel.h"
#import <UIImageView+WebCache.h>
#import "AboutYuJiaViewController.h"
#import "YYFeedbackViewController.h"
#import "CirleAndActiveViewController.h"
#import "MyActiveViewController.h"
#import "OtherCircleViewController.h"
@interface OtherPeopleInfoViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UIImageView *navBarHairlineImageView;
    UIImageView *tabBarHairlineImageView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UIImageView *genderV;
@property (nonatomic, strong) UIButton *editBtn;
//@property (nonatomic, strong) YYHomeUserModel *personalModel;

@property (nonatomic, weak) UIButton *rightNotBtn;
@property (nonatomic, strong) PersonalModel *personalModel;

@property (nonatomic, weak) MMButton *circleBtn;
@property (nonatomic, weak) MMButton *activeBtn;


@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) MyActiveViewController *myActiveVC;
@property (nonatomic, weak) OtherCircleViewController *mycircleVC;
@property (nonatomic, weak) UIView *myActiveView;
@property (nonatomic, weak) UIView *myCircleView;

@end

@implementation OtherPeopleInfoViewController

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
        _tableView.tableFooterView = [self createFootView];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //        self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self httpRequestHomeInfo];
    
    [self tableView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 220)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    personV.backgroundColor = [UIColor whiteColor];
    personV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_color"]];
    [headerView addSubview:personV];
    
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
    self.genderV = imageV;
    
    
    NSArray *nameList = @[@"ta的圈子",@"ta的活动",@"我的订单",@"我的收藏"];
    NSArray *iconList = @[@"mycircle",@"activity_other",@"MyOrder",@"collect"];
    
    
    CGFloat btnW = kScreenW/2.0;
    for (int i = 0 ; i<2 ;  i++) {
        MMButton *leftNavBtn = [MMButton buttonWithType:UIButtonTypeCustom];
        leftNavBtn.frame = CGRectMake(i *btnW, 120, btnW, 100);
        leftNavBtn.tag = 800 +i;
        leftNavBtn.backgroundColor = [UIColor whiteColor];
        [leftNavBtn setTitle:nameList[i] forState:UIControlStateNormal];
        [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [leftNavBtn setImage:[UIImage imageNamed:iconList[i]] forState:UIControlStateNormal];
        leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [leftNavBtn addTarget:self action:@selector(changeVCType:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:leftNavBtn];
        leftNavBtn.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
        leftNavBtn.layer.borderWidth = 0.5;
        
        if (i == 0) {
            leftNavBtn.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
            self.circleBtn = leftNavBtn;
        }else{
            self.activeBtn = leftNavBtn;
        }
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
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[AboutYuJiaViewController alloc]init] animated:YES];
    }else if(indexPath.row == 1){
        
        YYFeedbackViewController *feedBackVC = [[YYFeedbackViewController alloc]init];
        feedBackVC.personalModel = self.personalModel;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }else{
        
    }
    
    
    
    //    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //    self.tabBarController.selectedIndex = 4;
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
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
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.row];
    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    
    return homeTableViewCell;
}
- (void)editPersonal{
    EditPersonalViewController *editVC = [[EditPersonalViewController alloc]init];
    editVC.personalModel = self.personalModel;
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)action:(UIButton *)sender{
    switch (sender.tag -800) {
        case 0:
            [self.navigationController pushViewController:[[MYHomeViewController alloc]init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[CirleAndActiveViewController alloc]init] animated:YES];
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}
- (void)pushSettingVC{
    [self.navigationController pushViewController:[[PersonalSettingViewController alloc]init] animated:YES];
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&tataId=%@",mUserInfo,mDefineToken,self.info_id] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *eDict = responseObject[@"Personal"];
        self.personalModel = [PersonalModel mj_objectWithKeyValues:eDict];
        self.nameLabel.text = self.personalModel.userName;
        if (self.personalModel.avatar.length>0) {
            [self.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]]];
        }
        if ([self.personalModel.gender isEqualToString:@"1"]) {
            self.genderV.image = [UIImage imageNamed:@"man"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [self httpRequestHomeInfo];
}
- (UIView *)createFootView{
    // 120 +100
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64 -220)];
    footView.backgroundColor = [UIColor colorWithHexString:@"000000"];
    OtherCircleViewController *sightVC = [[OtherCircleViewController alloc]init];
    //    sightVC.dataSource = self.sightDataSource;
    sightVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH -64 -220);
    
    self.myCircleView = sightVC.view;
    self.mycircleVC = sightVC;
//    [self.view addSubview:sightVC.view];
    [self addChildViewController:sightVC];
    
    
    MyActiveViewController *equipmentVC = [[MyActiveViewController alloc]init];
    equipmentVC.view.frame = CGRectMake(0, 0, kScreenW, kScreenH -64 -220);
    equipmentVC.view.hidden = YES;
    self.myActiveVC = equipmentVC;
    self.myActiveView = equipmentVC.view;
//    [self.view addSubview:equipmentVC.view];
    [self addChildViewController:equipmentVC];
    
    [footView addSubview:sightVC.view];
    [footView addSubview:equipmentVC.view];
    
    return footView;

}
- (void)changeVCType:(UIButton *)sender{
    if (sender.tag - 800 == 1) {
        self.myActiveView.hidden = NO;
        self.myCircleView.hidden = YES;
        self.circleBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }else
    {
        self.myActiveView.hidden = YES;
        self.myCircleView.hidden = NO;
        self.activeBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    sender.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
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

