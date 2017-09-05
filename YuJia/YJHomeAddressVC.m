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
#import "YJHomeHouseInfoModel.h"
#import "YJEditHomeAddressInfoVC.h"

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
        _tableView.rowHeight = 160*kiphone6;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        [_tableView registerClass:[YJHomeAddressTVCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        [self.view addSubview:_tableView];
//        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.title = @"房屋信息";
    //添加空页面视图
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nohousing"]];
    backView.userInteractionEnabled = true;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).offset(-5*kiphone6);
        make.width.height.offset(160*kiphone6);
    }];
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.text = @"还没有添加房屋信息，去添加吧!";
    noticeLabel.font = [UIFont systemFontOfSize:13];
    noticeLabel.textColor = [UIColor colorWithHexString:@"#c6c6c6"];
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY).offset(5*kiphone6);
        make.width.offset(150*kiphone6);

    }];
    [self tableView];
//    [self httpRequestHomeInfo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加房屋信息" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(addHomeInfo)];
}
//添加房屋信息
-(void)addHomeInfo{
    YJAddhomeInfoVC *addHomeInfoVC = [[YJAddhomeInfoVC alloc]init];
    [self.navigationController pushViewController:addHomeInfoVC animated:true];
}
//请求房屋信息
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mMyHomeListInfo,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if (self.dataSource.count>0) {
            [self.dataSource removeAllObjects];
        }
        NSArray *addressArr = responseObject[@"result"];
        for (NSDictionary *aDict in addressArr) {
            YJHomeHouseInfoModel *houseModel = [YJHomeHouseInfoModel mj_objectWithKeyValues:aDict];
            [self.dataSource addObject:houseModel];
        }
        
        if (self.dataSource.count>0) {
            self.tableView.hidden = false;
            [self.tableView reloadData];
        }else{
            self.tableView.hidden = true;
        }
        
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
    return self.dataSource.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 70 ;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJHomeAddressTVCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    YJHomeHouseInfoModel *model = self.dataSource[indexPath.row];
    homeTableViewCell.houseModle = model;
    WS(ws);
    //切换默认地址
    homeTableViewCell.selectedBlock = ^(YJHomeHouseInfoModel *houseModel) {
        NSString *urlStr = [NSString stringWithFormat:@"%@token=%@&familyId=%@&personalId=%@",mSetFamily,mDefineToken2,houseModel.info_id,houseModel.personalId];
        [SVProgressHUD show];
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"选择默认地址成功"];
                [ws httpRequestHomeInfo];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    };
    //编辑地址
    homeTableViewCell.editBlock = ^(YJHomeHouseInfoModel *houseModel) {
        YJEditHomeAddressInfoVC *vc = [[YJEditHomeAddressInfoVC alloc]init];
        vc.houseModel = houseModel;
        [ws.navigationController pushViewController:vc animated:YES];
    };
    //删除地址
    homeTableViewCell.deleBlock = ^(YJHomeHouseInfoModel *houseModel) {
        NSString *urlStr = [NSString stringWithFormat:@"%@ids=%@&token=%@",mDeleHouseInfo,houseModel.info_id,mDefineToken2];
        [SVProgressHUD show];
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [SVProgressHUD showSuccessWithStatus:@"删除地址成功"];
                [SVProgressHUD dismiss];
                [ws httpRequestHomeInfo];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    };
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
    
 }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self httpRequestHomeInfo];
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
