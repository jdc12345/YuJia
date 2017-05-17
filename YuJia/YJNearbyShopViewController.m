//
//  YJNearbyShopViewController.m
//  YuJia
//
//  Created by 万宇 on 2017/5/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNearbyShopViewController.h"
#import "YJHeaderTitleBtn.h"
#import "YJNearByShopTVCell.h"
#import "YJNearbyShopDetailVC.h"

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
    [self loadData];
    
}
- (void)loadData {
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
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 3;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
            YJNearByShopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
//        cell.model = self.recordArr[indexPath.row];
        return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJNearbyShopDetailVC *vc = [[YJNearbyShopDetailVC alloc]init];
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
