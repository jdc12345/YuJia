//
//  YJPersonalVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/21.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPersonalVC.h"
#import "UIViewController+Cloudox.h"
#import "YYPersonalTableViewCell.h"
#import "MMButton.h"
#import "EditPersonalViewController.h"
#import "PersonalSettingViewController.h"
#import <UIImageView+WebCache.h>
#import "AboutYuJiaViewController.h"
#import "YYFeedbackViewController.h"
#import "YJNoticeListTableVC.h"
#import "YJPersonalModel.h"
#import "UILabel+Addition.h"
#import "YJMyhomeVC.h"
#import "YJSetPersonalVC.h"
#import "YJMyCircleFriendVC.h"
#import "YJMyActivitiesVC.h"
#import "YJNoticeListTableVC.h"
#import "EditPersonalViewController.h"

@interface YJPersonalVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, strong) UILabel *nameLabel;//名字

@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIButton *iconView;//头像
@property (nonatomic, strong) UIImageView *genderV;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, weak) UIButton *rightNotBtn;
@property (nonatomic, strong) YJPersonalModel *personalModel;

@end

@implementation YJPersonalVC
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
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
//    [self httpRequestHomeInfo];
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@"设置",@"关于宇家",@"意见反馈"]];
    self.iconList =@[@"mysettings",@"myabout",@"myopinion"];
    [self tableView];
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mUserInfo,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *eDict = responseObject[@"Personal"];
        self.personalModel = [YJPersonalModel mj_objectWithKeyValues:eDict];
        self.nameLabel.text = self.personalModel.userName;
        if (self.personalModel.avatar.length>0) {
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"当前进度%ld",receivedSize/expectedSize);
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSLog(@"下载完成");
                if (image) {
                    [self.iconView setImage:image forState:UIControlStateNormal];
                }else{
                    [self.iconView setImage:[UIImage imageNamed:@"avatar.jpg"] forState:UIControlStateNormal];
                }
            }];
            
        }
        if ([self.personalModel.gender isEqualToString:@"1"]) {
            self.genderV.image = [UIImage imageNamed:@"man"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (UIView *)personInfomation{
    //添加头部视图
    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 310)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.view addSubview:headerView];
    //添加背景视图
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    backView.userInteractionEnabled = true;
    [headerView addSubview:backView];
    UIImage *oldImage = [UIImage imageNamed:@"personal_back_photo"];
    backView.image = oldImage;
    //添加头像
    UIButton *iconView = [[UIButton alloc]init];
    UIImage *iconImage = [UIImage imageNamed:@"avatar.jpg"];
//    iconView.image = iconImage;
    [iconView setImage:iconImage forState:UIControlStateNormal];
    [backView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.offset(50);
        make.width.height.offset(75);
    }];
    iconView.layer.cornerRadius=37.5;//裁成圆角
    iconView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    [iconView addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
//    iconView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
//    iconView.layer.borderWidth = 1.5f;
    //添加名字
    UILabel *namelabel = [UILabel labelWithText:self.personalModel.userName andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
    [backView addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView);
        make.top.equalTo(iconView.mas_bottom).offset(10);
    }];
    
    self.nameLabel = namelabel;
//    self.idLabel = idName;
    self.iconView = iconView;
//添加性别标识
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"woman"];
    [imageV sizeToFit];
    [headerView addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(namelabel);
        make.left.equalTo(namelabel.mas_right).offset(5);
    }];
    self.genderV = imageV;
    
//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [editBtn setImage:[UIImage imageNamed:@"compile"] forState:UIControlStateNormal];
//    [editBtn sizeToFit];
//    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [editBtn addTarget:self action:@selector(editPersonal) forControlEvents:UIControlEventTouchUpInside];
//    [personV addSubview:editBtn];
//    
//    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(personV);
//        make.left.equalTo(imageV.mas_right).with.offset(10 *kiphone6);
//    }];
    
    NSArray *nameList = @[@"我的家",@"我的圈子",@"我的活动",@"我的消息"];
    NSArray *iconList = @[@"myhome",@"mycircle",@"myactivities",@"mynews"];
    
    CGFloat btnW = kScreenW/4.0;
    for (int i = 0 ; i<4 ;  i++) {
        MMButton *leftNavBtn = [MMButton buttonWithType:UIButtonTypeCustom];
        leftNavBtn.frame = CGRectMake(i *btnW, 200, btnW, 110);
        leftNavBtn.tag = 80 +i;
        leftNavBtn.backgroundColor = [UIColor whiteColor];
        [leftNavBtn setTitle:nameList[i] forState:UIControlStateNormal];
        [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"#6a6a6a"] forState:UIControlStateNormal];
        [leftNavBtn setImage:[UIImage imageNamed:iconList[i]] forState:UIControlStateNormal];
        leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [leftNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:leftNavBtn];
        headerView.userInteractionEnabled = YES;
//        leftNavBtn.enabled = YES;
        
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
    
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[[AboutYuJiaViewController alloc]init] animated:YES];
    }else if(indexPath.row == 2){
        
        YYFeedbackViewController *feedBackVC = [[YYFeedbackViewController alloc]init];
        feedBackVC.personalModel = self.personalModel;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }else{
        YJSetPersonalVC *setVC = [[YJSetPersonalVC alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }

    //    }
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
    //    NSArray *list = self.dataSource[section];
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
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
//按钮点击事件
- (void)action:(UIButton *)sender{
    switch (sender.tag -80) {
        case 0:
            [self.navigationController pushViewController:[[YJMyhomeVC alloc]init] animated:true];
            break;
        case 1:
            [self.navigationController pushViewController:[[YJMyCircleFriendVC alloc]init] animated:true];
            break;
        case 2:
            [self.navigationController pushViewController:[[YJMyActivitiesVC alloc]init] animated:true];
            break;
        case 3:
            [self.navigationController pushViewController:[[YJNoticeListTableVC alloc]init] animated:true];
            break;
            
        default:
            break;
    }
}
//设置个人信息页面
- (void)pushSettingVC{
    EditPersonalViewController *eVC = [[EditPersonalViewController alloc]init];
    eVC.personalModel = self.personalModel;
    [self.navigationController pushViewController:eVC animated:YES];
}
//- (void)pushNotficVC{
//    YJNoticeListTableVC *notficVC = [[YJNoticeListTableVC  alloc]init];
//    [self.navigationController pushViewController:notficVC animated:YES];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBarBgAlpha = @"0.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
    self.navigationController.navigationBar.translucent = true;
    [self httpRequestHomeInfo];
}
-(UIStatusBarStyle)preferredStatusBarStyle{//如果有导航栏必须在导航栏重写- (UIViewController *)childViewControllerForStatusBarStyle{
    //    return self.topViewController;
    //}
    return UIStatusBarStyleLightContent;
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
