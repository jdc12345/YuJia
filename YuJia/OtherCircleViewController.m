//
//  OtherCircleViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "OtherCircleViewController.h"
#import "MyCircleTableViewCell.h"
#import "YJFriendStateDetailVC.h"
@interface OtherCircleViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation OtherCircleViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64 -220) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 44.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[MyCircleTableViewCell class] forCellReuseIdentifier:@"MyCircleTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        //        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeVCType)];
    [titleView addGestureRecognizer:tapGest];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"我的圈子";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel = titleLabel;
    [titleView addSubview:titleLabel];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView).with.offset(0);
        make.left.equalTo(titleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 17));
    }];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v"]];
    [imageV sizeToFit];
    [titleView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView).with.offset(0);
        make.left.equalTo(titleLabel.mas_right).with.offset(10);
        //        make.size.mas_equalTo(CGSizeMake(17, 15));
    }];
    
    
    self.navigationItem.titleView = titleView;
    
    [self updateAreaType:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    return headerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCircleTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    WS(ws);
    cell.commentBtnBlock = ^(YJFriendNeighborStateModel *model){
        YJFriendStateDetailVC *detailVc = [[YJFriendStateDetailVC alloc]init];
        //        detailVc.userId = ws.userId;
        detailVc.model = model;
        [ws.navigationController pushViewController:detailVc animated:true];
        [detailVc.commentField becomeFirstResponder];
    };
    return cell;
}
-(void)updateAreaType:(UIButton*)sender{
    
    //    self.rqId = [NSString stringWithFormat:@"%ld",sender.tag-50];
    [SVProgressHUD show];// 动画开始
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=1&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,@"3",@"1"];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.dataSource = mArr;
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            self.dataSource = [NSMutableArray array];
            [self.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画
        return ;
    }];
    
    
}
- (void)changeVCType{
    if ([self.titleLabel.text isEqualToString:@"我的圈子"]) {
        self.titleLabel.text = @"我的活动";
    }else
    {
        self.titleLabel.text = @"我的圈子";
    }
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
