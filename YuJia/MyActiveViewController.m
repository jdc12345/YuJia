//
//  MyActiveViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MyActiveViewController.h"
#import "UIButton+Badge.h"
#import "YJCommunityActivitiesTVCell.h"
#import "YJCreatActivitiesVC.h"
#import "YJActivitiesDetailsVC.h"
#import "YJActivitiesDetailModel.h"

static NSInteger start = 0;
static NSString* tableCellid = @"table_cell";
@interface MyActiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *underwayBtn;//正在进行
@property(nonatomic,weak)UIButton *endBtn;//结束
//@property(nonatomic,weak)UIView *blueView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)long userId;//当前用户Id
@property(nonatomic,strong)NSMutableArray *activiesArr;//数据源
@property(nonatomic,assign)NSInteger over;//当前页面显示的活动状态

@end

@implementation MyActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区活动";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加右侧消息中心按钮
    UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [informationBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    informationBtn.badgeValue = @" ";
    informationBtn.badgeBGColor = [UIColor redColor];
    informationBtn.badgeFont = [UIFont systemFontOfSize:0.1];
    informationBtn.badgeOriginX = 16;
    informationBtn.badgeOriginY = 1;
    informationBtn.badgePadding = 0.1;
    informationBtn.badgeMinSize = 5;
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 0) WithTitle:@"正在进行"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 0) WithTitle:@"活动结束"andTag:102];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:line];
    self.underwayBtn.hidden = YES;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.underwayBtn.mas_bottom).offset(-1*kiphone6/[UIScreen mainScreen].scale);
        make.right.left.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    [self loadData];
}
-(void)loadData{
    //http://192.168.1.55:8080/smarthome/mobileapi/activity/findActivity.do?token=EC9CDB5177C01F016403DFAAEE3C1182
    //    &over=1
    //    &start=0&limit=10
    self.over = 1;
    [SVProgressHUD show];// 动画开始
    NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=1&start=0&limit=10",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *userId = responseObject[@"userid"];
            self.userId = [userId integerValue];
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                infoModel.over = self.over;//传入活动状态
                [mArr addObject:infoModel];
            }
            self.activiesArr = mArr;
            start = self.activiesArr.count;
            [self setupTableView];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
    
}
-(void)setupTableView{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    //    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.underwayBtn.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCommunityActivitiesTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight = 235*kiphone6;
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
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    if (btn.tag==101) {
        self.underwayBtn = btn;
    }else{
        self.endBtn = btn;
    }
    btn.hidden = YES;
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.endBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.endBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        //更新数据源
        //http://192.168.1.55:8080/smarthome/mobileapi/activity/findActivity.do?token=EC9CDB5177C01F016403DFAAEE3C1182
        //    &over=1
        //    &start=0&limit=10
        self.over = 1;
        [SVProgressHUD show];// 动画开始
        NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=1&start=0&limit=10",mPrefixUrl,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSString *userId = responseObject[@"userid"];
                self.userId = [userId integerValue];
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                    infoModel.over = self.over;//传入活动状态
                    [mArr addObject:infoModel];
                }
                self.activiesArr = mArr;
                start = self.activiesArr.count;
                [self.tableView reloadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];// 动画结束
            return ;
        }];
        
    }else{
        self.underwayBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.underwayBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        //更新数据源
        //http://192.168.1.55:8080/smarthome/mobileapi/activity/findActivity.do?token=EC9CDB5177C01F016403DFAAEE3C1182
        //    &over=1
        //    &start=0&limit=10
        self.over = 2;
        [SVProgressHUD show];// 动画开始
        NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=2&start=0&limit=10",mPrefixUrl,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSString *userId = responseObject[@"userid"];
                self.userId = [userId integerValue];
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                    infoModel.over = self.over;//传入活动状态
                    [mArr addObject:infoModel];
                }
                self.activiesArr = mArr;
                start = self.activiesArr.count;
                [self.tableView reloadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];// 动画结束
            return ;
        }];
        
    }
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.activiesArr.count;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJCommunityActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.activiesArr[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJActivitiesDetailsVC *detailVc = [[YJActivitiesDetailsVC alloc]init];
    YJCommunityActivitiesTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    detailVc.model = cell.model;
    detailVc.userId = self.userId;
    [self.navigationController pushViewController:detailVc animated:true];
    
}

- (void)postBtn:(UIButton*)sender {
    YJCreatActivitiesVC *vc = [[YJCreatActivitiesVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
//删除状态返回该页面调用刷新
-(void)deleRefresh{
    //更新数据源
    //http://192.168.1.55:8080/smarthome/mobileapi/activity/findActivity.do?token=EC9CDB5177C01F016403DFAAEE3C1182
    //    &over=1
    //    &start=0&limit=10
    [SVProgressHUD show];// 动画开始
    NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=%ld&start=0&limit=10",mPrefixUrl,mDefineToken1,self.over];
    [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *userId = responseObject[@"userid"];
            self.userId = [userId integerValue];
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                infoModel.over = self.over;//传入活动状态
                [mArr addObject:infoModel];
            }
            self.activiesArr = mArr;
            start = self.activiesArr.count;
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
}
-(void)informationBtnClick:(UIButton*)sender{
    
    //    YJNoticeListTableVC *vc = [[YJNoticeListTableVC alloc]init];
    //    [self.navigationController pushViewController:vc animated:true];
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
