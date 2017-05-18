//
//  YJNearbyShopDetailVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNearbyShopDetailVC.h"
#import "ZFBLevelView.h"
#import "UILabel+Addition.h"

static NSString* tableCellid = @"table_cell";
@interface YJNearbyShopDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *shopsArr;



@end

@implementation YJNearbyShopDetailVC

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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 340*kiphone6)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UIImageView *bigImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    [headerView addSubview:bigImageView];
    [bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0*kiphone6);
        make.height.offset(168*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"西饼店" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//西饼店
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(bigImageView.mas_bottom).offset(15*kiphone6);
    }];
    ZFBLevelView *starView = [[ZFBLevelView alloc]initWithFrame:CGRectMake(0, 0, 60*kiphone6, 12*kiphone6)];//星星评价
    starView.level = 3;
    [headerView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(nameLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *priceLabel = [UILabel labelWithText:@"人均： ¥ 20/人" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];//价格
    [headerView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(85*kiphone6);
        make.top.equalTo(nameLabel.mas_bottom).offset(10*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-108*kiphone6);
        make.height.offset(1*kiphone6);
    }];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gray_address"]];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line.mas_top).offset(29*kiphone6);
    }];
    UILabel *distanceLabel = [UILabel labelWithText:@"涿州市富康街32号" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//距离
    [headerView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(imageView);
    }];
    UIView *line2 = [[UIView alloc]init];//添加line
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.height.offset(58*kiphone6);
        make.right.offset(-65*kiphone6);
        make.width.offset(1*kiphone6);
    }];
    UIButton *phoneBtn = [[UIButton alloc]init];
    [phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [headerView addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(imageView);
        make.centerX.equalTo(headerView.mas_right).offset(-32*kiphone6);
    }];
    [phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *grayView = [[UIView alloc]init];//添加line
    grayView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [headerView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line2.mas_bottom);
        make.height.offset(5*kiphone6);
    }];
    UILabel *productLabel = [UILabel labelWithText:@"店铺产品" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//西饼店
    [headerView addSubview:productLabel];
    [productLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(grayView.mas_bottom).offset(22.5*kiphone6);
    }];
    UIView *line3 = [[UIView alloc]init];//添加line
    line3.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];

    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.tableHeaderView = headerView;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
//    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.estimatedRowHeight = 180*kiphone6;
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableCellid];
    cell.imageView.image = [UIImage imageNamed:@"sf"];
    cell.textLabel.text = @"小蛋糕";
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = @"¥ 88";
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#00bfff"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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