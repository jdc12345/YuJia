//
//  YJHomeAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomeAddressVC.h"
#import "YJHomeAddressTVCell.h"
#import "UIBarButtonItem+Helper.h"
#import "YJAddhomeInfoVC.h"

@interface YJHomeAddressVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation YJHomeAddressVC

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.indicatorStyle =
        _tableView.rowHeight = 150*kiphone6;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_tableView registerClass:[YJHomeAddressTVCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
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
    self.title = @"房屋信息";
    //    self.selectStart = @[@"lim创建的家",@"zzz创建的家"];
    [self tableView];
    [self httpRequestHomeInfo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加房屋信息" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(addHomeInfo)];
}
-(void)addHomeInfo{
    YJAddhomeInfoVC *addHomeInfoVC = [[YJAddhomeInfoVC alloc]init];
    [self.navigationController pushViewController:addHomeInfoVC animated:true];
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mMyHomeListInfo,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
//        NSDictionary *eDict = responseObject[@"Personal"];
//        self.personalModel = [YJPersonalModel mj_objectWithKeyValues:eDict];
//        self.nameLabel.text = self.personalModel.trueName;
//        if (self.personalModel.avatar.length>0) {
//            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]]];
//        }
//        if ([self.personalModel.gender isEqualToString:@"1"]) {
//            self.genderV.image = [UIImage imageNamed:@"man"];
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1) {
//        [self.navigationController pushViewController:[[MYFamilyViewController alloc]init ] animated:YES];
//    }else if (indexPath.row == 2){
//        [self.navigationController pushViewController:[[EquipmentManagerViewController alloc]init ] animated:YES];
//    }else{
//        [self.navigationController pushViewController:[[MMHomeInfoViewController alloc]init ] animated:YES];
//    }
//    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 70 ;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJHomeAddressTVCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"house_myhome"]];
//        homeTableViewCell.titleLabel.text = @"我的房屋信息";
//        
//    }else if(indexPath.row == 1){
//        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"Family_myhome"]];
//        homeTableViewCell.titleLabel.text = @"我的家人管理";
//    }else{
//        homeTableViewCell.iconV.image = [UIImage imageNamed:[NSString stringWithFormat:@"equipmentmanagement_myhome"]];
//        homeTableViewCell.titleLabel.text = @"我的设备管理";
//    }
    //    homeTableViewCell.backgroundColor = [UIColor blackColor];
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
    
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
