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

static NSString* tableCellid = @"table_cell";
@interface YJNearbyShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *shopsArr;
@property(nonatomic,weak)YJHeaderTitleBtn *locationAddressBtn;
@end

@implementation YJNearbyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近商户";
    self.navigationController.navigationBar.translucent = false;
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
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [LocationView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(1);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_address"]];
    [LocationView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(142*kiphone6);
        make.centerY.equalTo(LocationView);
    }];
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:CGRectZero and:@"名流一品"];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(LocationView);
    }];
    self.locationAddressBtn = btn;
    
    [btn addTarget:self action:@selector(selectAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    //根据地址请求数据
    //http://192.168.1.55:8080/smarthome/mobileapi/business/findBusinessList.do?   token=EC9CDB5177C01F016403DFAAEE3C1182
    //    &rqid=1
    //    &start=0
    //    &limit=10
    //    &lat2=115.984108
    //    &lng2=39.484636
    [SVProgressHUD show];// 动画开始
    NSString *rname = @"名流一品小区";
    rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/business/findBusinessList.do?token=%@&rname=%@&start=0&limit=10&lat2=115.984108&lng2=39.484636",mPrefixUrl,mDefineToken1,rname];
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
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
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
    //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 180*kiphone6;
}
-(void)selectAddressItem:(UIButton*)sender{
    //http://192.168.1.55:8080/smarthome/mobileapi/business/findBusinessList.do?   token=EC9CDB5177C01F016403DFAAEE3C1182
    //    &rqid=1
    //    &start=0
    //    &limit=10
    //    &lat2=115.984108
    //    &lng2=39.484636
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
