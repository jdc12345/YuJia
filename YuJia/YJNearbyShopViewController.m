//
//  YJNearbyShopViewController.m
//  YuJia
//
//  Created by 万宇 on 2017/5/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
// 高德appkey  380748c857866280e77da5bb813e13c5

#import "YJNearbyShopViewController.h"
#import "YJHeaderTitleBtn.h"
#import "YJNearByShopTVCell.h"
#import "YJNearbyShopDetailVC.h"
#import "YJBussinessDetailModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YJNearbyShopChangeAddressVC.h"
//#import "UIViewController+Cloudox.h"

static NSString* tableCellid = @"table_cell";
@interface YJNearbyShopViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *shopsArr;
@property(nonatomic,weak)YJHeaderTitleBtn *locationAddressBtn;
@property (nonatomic, strong) AMapLocationManager *locationManager;//定位实体类
@property (nonatomic, strong) AMapSearchAPI *search;//搜索实体类
///中心点坐标。
@property (nonatomic, copy)   AMapGeoPoint *location;
@end

@implementation YJNearbyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近商户";
//    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self setLocationAddress];
    
}
- (void)setLocationAddress {

    UIView *LocationView = [[UIView alloc]init];
    LocationView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:LocationView];
    [LocationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(45*kiphone6);
    }];
//    UIView *line = [[UIView alloc]init];//添加line
//    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
//    [LocationView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.top.offset(0);
//        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
//    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_address"]];
    [LocationView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(142*kiphone6);
        make.centerY.equalTo(LocationView);
    }];
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:CGRectZero and:@"定位中..."];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(LocationView);
    }];
    self.locationAddressBtn = btn;
    //    -------------------------先用locationKit定位,得出兴趣点
    [AMapServices sharedServices].apiKey =@"380748c857866280e77da5bb813e13c5";
    
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    [self locationRequest];//定位请求
    
    [btn addTarget:self action:@selector(selectAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LocationView.mas_bottom).offset(1);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJNearByShopTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 180*kiphone6;
}


-(void)locationRequest{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@,AOIName---%@,POIName---%@", location,regeocode.AOIName,regeocode.POIName);
        [self.locationAddressBtn setTitle:regeocode.POIName forState:UIControlStateNormal];
        self.location = [[AMapGeoPoint alloc]init];
        self.location.latitude = location.coordinate.latitude;//请求数据时候需要坐标
        self.location.longitude = location.coordinate.longitude;//请求数据时候需要坐标
        [self loaddata];
//        self.search = [[AMapSearchAPI alloc] init];//实例化搜索对象
//        self.search.delegate = self;
//        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];//实例化搜索请求对象
//        regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//        self.location = regeo.location;//请求数据时候需要坐标
//        regeo.requireExtension = YES;//是否返回扩展信息，默认NO。
//        [self.search AMapReGoecodeSearch:regeo];
    }];
   
}
#pragma AMapSearchDelegate
/* 逆地理编码回调. */
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    
//    if (response.regeocode != nil)
//    {
//        //解析response获取地址描述，具体解析见 Demo
//        NSLog(@"reGeocode:%@", response.regeocode.aois[0].name);//aois是兴趣(搜索出的)区域信息组，第一个是最近的一个
//        NSLog(@"reGeocode:%@,%@,%@", response.regeocode.addressComponent.province,response.regeocode.addressComponent.city,response.regeocode.addressComponent.district);//aois是兴趣(搜索出的)区域信息组，第一个是最近的一个
//        [self.locationAddressBtn setTitle:response.regeocode.aois[0].name forState:UIControlStateNormal];
//        [self loaddata];
//        
//    }else{
//        [self.locationAddressBtn setTitle:@"无定位" forState:UIControlStateNormal];
//    }
//}
////当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
//- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//    [SVProgressHUD showErrorWithStatus:error.description];
//}
-(void)loaddata{
    //根据地址请求数据
    //http://192.168.1.55:8080/smarthome/mobileapi/business/findBusinessList.do?   token=EC9CDB5177C01F016403DFAAEE3C1182
    //    &rqid=1
    //    &start=0
    //    &limit=10
    //    &lat2=115.984108
    //    &lng2=39.484636
    [SVProgressHUD show];// 动画开始
    NSString *rname = self.locationAddressBtn.titleLabel.text;
    //        NSString *rname = @"名流一品小区";
    rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/business/findBusinessList.do?token=%@&rname=%@&start=0&limit=10&lat2=%f&lng2=%f",mPrefixUrl,mDefineToken1,rname,self.location.latitude,self.location.longitude];
    [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJBussinessDetailModel *infoModel = [YJBussinessDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.shopsArr = mArr;
            [self.tableView reloadData];
            if (self.shopsArr.count==0) {
                [SVProgressHUD showInfoWithStatus:@"此小区暂无商户资源"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

}
-(void)selectAddressItem:(UIButton*)sender{
    YJNearbyShopChangeAddressVC *addressVC = [[YJNearbyShopChangeAddressVC alloc]init];
    addressVC.popVCBlock = ^(NSString *sname){
        [self.locationAddressBtn setTitle:sname forState:UIControlStateNormal];
        [self loaddata];
    };
    addressVC.presentVCBlock = ^(){
        self.locationAddressBtn.titleLabel.text = @"定位中...";
        [self locationRequest];//定位请求
    };
    //在addressVC上用导航控制器包装，让弹出的模态窗口有一个导航栏可以放返回按钮
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:addressVC];
    [self presentViewController:nvc animated:YES completion:^{
//        NSLog(@"弹出一个模态窗口");
    }];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.shopsArr.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJNearByShopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        cell.model = self.shopsArr[indexPath.row];
        return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJNearbyShopDetailVC *vc = [[YJNearbyShopDetailVC alloc]init];
    YJNearByShopTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.info_id = cell.model.info_id;
    [self.navigationController pushViewController:vc animated:true];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
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
