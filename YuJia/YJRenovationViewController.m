//
//  YJRenovationViewController.m
//  YuJia
//
//  Created by 万宇 on 2017/5/20.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRenovationViewController.h"
#import "ZFBLevelView.h"
#import "UILabel+Addition.h"
#import "YJBussinessDetailModel.h"
#import "YJBussinessServeDetailModel.h"
#import <UIImageView+WebCache.h>

static NSString* tableCellid = @"table_cell";
@interface YJRenovationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *shopsArr;
@property(nonatomic,strong)YJBussinessDetailModel *detailModel;//商家数据
@property(nonatomic,strong)NSArray *servesArr;//服务数据
@end

@implementation YJRenovationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"装修服务";
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
//    [self loadData];
}
- (void)loadData {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 340*kiphone6)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.detailModel.picture];
    UIImageView *bigImageView = [[UIImageView alloc]init];
    [bigImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    [headerView addSubview:bigImageView];
    [bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0*kiphone6);
        make.height.offset(168*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:self.detailModel.businessName?self.detailModel.businessName:@"一站装修" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//西饼店
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(bigImageView.mas_bottom).offset(15*kiphone6);
    }];
    ZFBLevelView *starView = [[ZFBLevelView alloc]initWithFrame:CGRectMake(0, 0, 60*kiphone6, 12*kiphone6)];//星星评价
    starView.level = self.detailModel.star;
    [headerView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(nameLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *priceLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%.0f元",self.detailModel.average] andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];//价格
    [headerView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(85*kiphone6);
        make.top.equalTo(nameLabel.mas_bottom).offset(7*kiphone6);
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
    UILabel *distanceLabel = [UILabel labelWithText:self.detailModel.address?self.detailModel.address:@"涿州市富康街32号" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//距离
    [headerView addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(imageView);
    }];
    
    UIView *grayView = [[UIView alloc]init];//添加line
    grayView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [headerView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line.mas_bottom).offset(58*kiphone6);
        make.height.offset(5*kiphone6);
    }];
    UILabel *productLabel = [UILabel labelWithText:@"服务项目" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//服务项目
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
        make.top.left.right.offset(0);
        make.bottom.offset(-55*kiphone6);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    //    tableView.rowHeight = UITableViewAutomaticDimension;
    //    tableView.estimatedRowHeight = 180*kiphone6;
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"立即咨询" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(55*kiphone6);
    }];
    [btn addTarget:self action:@selector(queryBill) forControlEvents:UIControlEventTouchUpInside];

}
-(void)queryBill{
    
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.servesArr.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableCellid];
    YJBussinessServeDetailModel *model = self.servesArr[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.picture];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"sf"]];
    cell.textLabel.text = model.productName;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %.0f元/㎡",model.price];
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
-(void)setBusinessId:(long)businessId{
    _businessId = businessId;
http://192.168.1.55:8080/smarthome/mobileapi/business/findbusinessOne.do?
//    businessId=1
//    &token=ACDCE729BCE6FABC50881A867CAFC1BC
    [SVProgressHUD show];// 动画开始
    NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/business/findbusinessOne.do?businessId=%ld&token=%@",mPrefixUrl,businessId,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
             NSDictionary *bigDic = responseObject[@"result"];
            NSDictionary *smallDic = bigDic[@"businessEntity"];
            YJBussinessDetailModel *detailModel = [YJBussinessDetailModel mj_objectWithKeyValues:smallDic];
            self.detailModel = detailModel;
            [self loadData];//加载UI
            NSArray *arr = bigDic[@"menulist"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJBussinessServeDetailModel *infoModel = [YJBussinessServeDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.servesArr = mArr;
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
 
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
