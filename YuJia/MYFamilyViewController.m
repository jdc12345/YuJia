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
#import "PersonalModel.h"
#import <UIImageView+WebCache.h>
#import "AddFamilyViewController.h"
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
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5 *kiphone6)];
//    headView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableHeaderView = headView;
    [self tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(pushToAdd)];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalModel *personalModel = self.dataSource[indexPath.row];
    FamilyPersonalViewController *familyInfo = [[FamilyPersonalViewController alloc]init];
    familyInfo.homeID = personalModel.myFamilyId;
    familyInfo.telePhone = personalModel.telephone;
    [self.navigationController pushViewController:familyInfo animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalModel *personalModel = self.dataSource[indexPath.row];
    
    MYFamilyTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MYFamilyTableViewCell" forIndexPath:indexPath];
    [homeTableViewCell.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,personalModel.avatar]]];;
    homeTableViewCell.titleLabel.text = personalModel.userName;
//    switch ([personalModel.userType integerValue]) {
//        case 0:
//            homeTableViewCell.introduceLabel.text = @"家庭成员";
//            break;
//        case 1:
//            homeTableViewCell.introduceLabel.text = @"租客";
//            break;
//        case 2:
//            homeTableViewCell.introduceLabel.text = @"访客";
//            break;
//        default:
//            break;
//    }
    homeTableViewCell.introduceLabel.text = personalModel.comment;
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
    
}
- (void)pushToAdd{
    [self.navigationController pushViewController:[[AddFamilyViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpRequestHomeInfo{
    [SVProgressHUD show];
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mFamilyList,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        if (self.dataSource.count>0) {
            [self.dataSource removeAllObjects];
        }
        NSArray *personalList= responseObject[@"personalList"];
        for(NSDictionary *eDict in personalList){
            PersonalModel *personalModel = [PersonalModel mj_objectWithKeyValues:eDict];
            [self.dataSource addObject:personalModel];
        }
        if (self.dataSource.count == 0) {
            _tableView.tableFooterView = [self createTableFootView];
        }else{
            _tableView.tableFooterView = nil;
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
}
//添加没有数据空页面时候tableview尾部视图
- (UIView *)createTableFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 500)];
    footView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UIView *clickView = [[UIView alloc]init];
    clickView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emptyClick)];
    [clickView addGestureRecognizer:tapGest];
    [footView addSubview:clickView];
    [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(125);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(160, 230));
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nofamily"]];
    [clickView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clickView);
        make.centerX.equalTo(clickView);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"还没添加家人哦！";
    titleLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [clickView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).with.offset(15);
        make.centerX.equalTo(clickView);
        make.size.mas_equalTo(CGSizeMake(160, 13));
    }];
    
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.text = @"去添加吧！";
    titleLabel2.textColor = [UIColor colorWithHexString:@"cccccc"];
    titleLabel2.font = [UIFont systemFontOfSize:13];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [clickView addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(clickView);
        make.size.mas_equalTo(CGSizeMake(160, 13));
    }];
    
    return footView;
    
}
- (void)emptyClick{

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self httpRequestHomeInfo];
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
