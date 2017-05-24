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

static NSString* tableCellid = @"table_cell";
@interface YJHouseSearchListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *houseArr;
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
    localBtn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [localBtn setImage:[UIImage imageNamed:@"Location_rent"] forState:UIControlStateNormal];
    [localBtn setTitle:@"涿州" forState:UIControlStateNormal];
    localBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [localBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    localBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    localBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    localBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    localBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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
    
    [self setupUI];
}
- (void)backBtnClick:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (void)localBtnClick:(UIButton*)sender {
    
}
- (void)searchBtnClick:(UIButton*)sender {
    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
    vc.searchCayegory = 2;
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
    return 5;
//    return self.statesArr.count;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJHouseListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
//    cell.model = self.statesArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJHouseDetailVC *detailVc = [[YJHouseDetailVC alloc]init];
    
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
