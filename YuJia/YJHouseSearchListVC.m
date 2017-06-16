//
//  YJHouseSearchListVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHouseSearchListVC.h"
#import "YJHouseListTVCell.h"
#import "YJRentalHouseVC.h"
#import "YJHouseDetailVC.h"
#import "YJSearchHourseVC.h"
#import "YJHouseListModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MJRefresh.h>

static NSInteger start = 0;
static NSString* tableCellid = @"table_cell";
@interface YJHouseSearchListVC ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *houseArr;
@property(nonatomic,weak)UIButton *LocationBtn;//定位按钮
@property (nonatomic, strong) AMapLocationManager *locationManager;//定位实体类
//@property(nonatomic,strong)NSString *currentCity;//当前城市
@end

@implementation YJHouseSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    NSMutableArray* itemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer1.width = -15;
    [itemArr addObject:negativeSpacer1];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20*kiphone6, 30)];
    backBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [itemArr addObject:leftItem1];
    UIButton *localBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 81*kiphone6, 30)];
    self.LocationBtn = localBtn;
    localBtn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [localBtn setImage:[UIImage imageNamed:@"Location_rent"] forState:UIControlStateNormal];
    [localBtn setTitle:@"定位中" forState:UIControlStateNormal];
    localBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [localBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    localBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    localBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    localBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    localBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    -------------------------先用locationKit定位，再根据定位的坐标用searchKit查询
    [AMapServices sharedServices].apiKey =@"380748c857866280e77da5bb813e13c5";
    
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"location:%@", location);
                //定位结果
                NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
                if (regeocode)//定位只返回到城市级别的信息，此处刚好只需要城市的名字
                {
                    NSLog(@"reGeocode:%@", regeocode.district);
                    if(!regeocode.district){
                        [localBtn setTitle:@"无定位" forState:UIControlStateNormal];
                    }else{
                        [localBtn setTitle:regeocode.district forState:UIControlStateNormal];
//                        self.currentCity = localBtn.titleLabel.text;
                        [self loadData];
                    }
                }        
    }];
    [localBtn addTarget:self action:@selector(localBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem2 = [[UIBarButtonItem alloc] initWithCustomView:localBtn];
    [itemArr addObject:leftItem2];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 5;
    [itemArr addObject:negativeSpacer];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 242*kiphone6, 30)];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"请输入小区名、户型" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    searchBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    localBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem3 = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    [itemArr addObject:leftItem3];
     self.navigationItem.leftBarButtonItems = itemArr;
    
    
}
- (void)loadData{
//http://localhost:8080/smarthome/mobileapi/rental/findPage.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &cyty=%E6%B6%BF%E5%B7%9E
//    &residentialQuarters=%E5%90%8D%E6%B5%81%E4%B8%80%E5%93%81%E5%B0%8F%E5%8C%BA  小区可不传,此处不传
//    &lstart=0
//    &limit=1
    [SVProgressHUD show];// 动画开始
    NSString *rname = self.LocationBtn.titleLabel.text;
    rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=0&limit=10",mPrefixUrl,mDefineToken1,rname];
    [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"]isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            if (arr.count>0) {
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                self.houseArr = mArr;
                start = self.houseArr.count;
                [self setupUI];
            }else{
                [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
  
}
- (void)backBtnClick:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (void)localBtnClick:(UIButton*)sender {
    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
    vc.searchCayegory = 0;
//    vc.city = self.currentCity;
    vc.popVCBlock = ^(NSString *cityName){
        [self.LocationBtn setTitle:cityName forState:UIControlStateNormal];
        [SVProgressHUD show];// 动画开始
        cityName = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=0&limit=10",mPrefixUrl,mDefineToken1,cityName];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                if (arr.count>0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    self.houseArr = mArr;
                    start = self.houseArr.count;
                    [self setupUI];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            return ;
        }];
 
    };
    [self.navigationController pushViewController:vc animated:true];
}
- (void)searchBtnClick:(UIButton*)sender {
    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
    vc.searchCayegory = 1;
    vc.city = self.LocationBtn.titleLabel.text;
    [self.navigationController pushViewController:vc animated:true];
}
- (void)setupUI {
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    //    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJHouseListTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight =  107*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *rname = self.LocationBtn.titleLabel.text;
        rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=0&limit=10",mPrefixUrl,mDefineToken1,rname];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                if (arr.count>0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    self.houseArr = mArr;
                    start = self.houseArr.count;
                [self.tableView reloadData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
                }
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
//                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }];
    }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入加载状态后会自动调用这个block
        if (self.houseArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        NSString *rname = self.LocationBtn.titleLabel.text;
        rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=%ld&limit=5",mPrefixUrl,mDefineToken1,rname,start];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                if (arr.count>0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    [self.houseArr addObjectsFromArray:mArr];
                    start = self.houseArr.count;
                [self.tableView reloadData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
                }
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
//                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
            return ;
        }];
    }];

    UIButton *postBtn = [[UIButton alloc]init];
    [postBtn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    //    postBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    postBtn.layer.cornerRadius = 25*kiphone6;
    postBtn.layer.masksToBounds = YES;
    [postBtn addTarget:self action:@selector(postBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
    WS(ws);
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(-54*kiphone6);
        make.right.equalTo(ws.view).with.offset(-12*kiphone6);
        make.size.mas_equalTo(CGSizeMake(49*kiphone6 ,49*kiphone6));
    }];
    

}
- (void)postBtn:(UIButton*)sender {
    YJRentalHouseVC *vc = [[YJRentalHouseVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseArr.count;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJHouseListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.houseArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJHouseDetailVC *detailVc = [[YJHouseDetailVC alloc]init];
    YJHouseListTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    detailVc.info_id = cell.model.info_id;
    [self.navigationController pushViewController:detailVc animated:true];
    
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
