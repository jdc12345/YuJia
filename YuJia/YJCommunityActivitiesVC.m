//
//  YJCommunityActivitiesVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityActivitiesVC.h"
#import "UIButton+Badge.h"
#import "YJCommunityActivitiesTVCell.h"
#import "YJCreatActivitiesVC.h"
#import "YJActivitiesDetailsVC.h"
#import "YJActivitiesDetailModel.h"
#import "RKNotificationHub.h"
#import "YJNoticeListTableVC.h"
#import <MJRefresh.h>

static NSInteger start = 0;
static NSString* tableCellid = @"table_cell";
@interface YJCommunityActivitiesVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *underwayBtn;//正在进行
@property(nonatomic,weak)UIButton *endBtn;//结束
//@property(nonatomic,weak)UIView *blueView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)long userId;//当前用户Id
@property(nonatomic,strong)NSMutableArray *activiesArr;//数据源
@property(nonatomic,assign)NSInteger over;//当前页面显示的活动状态

@property(nonatomic,strong)RKNotificationHub *barHub;//bage
@property(nonatomic,assign)Boolean isHasMessage;//是否有消息
//改动又添加的
@property(nonatomic,weak)UIView *headerImageView;
@property(nonatomic,weak)UIView *scrollowView;//滚动条
@end

@implementation YJCommunityActivitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区活动";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加头部视图
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 55*kiphone6)];
    headerView.userInteractionEnabled = true;
    [self.view addSubview:headerView];
    UIImage *oldImage = [UIImage imageNamed:@"activites_header"];
    headerView.image = oldImage;
    self.headerImageView = headerView;
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 55*kiphone6) WithTitle:@"正在进行"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 55*kiphone6) WithTitle:@"活动结束"andTag:102];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#373840"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.right.left.offset(0);
        make.height.offset(2*kiphone6);
    }];
    UIView *scrollowView = [[UIView alloc]init];//添加滚动线
    scrollowView.backgroundColor = [UIColor colorWithHexString:@"#03c2a5"];
    [line addSubview:scrollowView];
    self.scrollowView = scrollowView;
    [scrollowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.height.offset(2*kiphone6);
        make.width.offset(kScreenW*0.5);
    }];
    [self checkHasMessade];
    [self loadData];
}
-(void)checkHasMessade{
    //添加右侧消息中心按钮
//    UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
//    [informationBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
//    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    NSMutableArray* itemArr = [NSMutableArray array];
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [postBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    [itemArr addObject:rightBarItem2];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 15;
    [itemArr addObject:negativeSpacer];
    UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [informationBtn setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
    [itemArr addObject:rightBarItem];
    
    self.navigationItem.rightBarButtonItems = itemArr;

    //  http://192.168.1.55:8080/smarthome/mobileapi/message/hasmessage.do?msgType=&token=9DB2FD6FDD2F116CD47CE6C48B3047EE&msgTypeBegin=2&msgTypeEnd=3
    NSString *checkUrlStr = [NSString stringWithFormat:@"%@/mobileapi/message/hasmessage.do?msgType=&token=%@&msgTypeBegin=31&msgTypeEnd=50",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:checkUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *isHasMessage = responseObject[@"hasMessage"];
            self.isHasMessage = [isHasMessage boolValue];
            if (self.isHasMessage) {
                self.barHub = [[RKNotificationHub alloc] initWithBarButtonItem: self.navigationItem.rightBarButtonItems[2]];//初始化bageView
                [self.barHub setCircleAtFrame:CGRectMake(15, 1, 5, 5)];//bage的frame
                [self.barHub increment];//显示count+1
                [self.barHub hideCount];//隐藏数字
                
            }
        }else if ([responseObject[@"code"] isEqualToString:@"10000"]){
            [SVProgressHUD showErrorWithStatus:@"您还未登陆，请登录后再试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
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
        make.top.equalTo(self.underwayBtn.mas_bottom).offset(2*kiphone6);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCommunityActivitiesTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight = 235*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=1&start=0&limit=10",mPrefixUrl,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
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
        if (self.activiesArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=1&start=%ld&limit=5",mPrefixUrl,mDefineToken1,start];
        [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
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
                [self.activiesArr addObjectsFromArray:mArr];
                start = self.activiesArr.count;
                [self.tableView reloadData];
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

//    UIButton *postBtn = [[UIButton alloc]init];
//    [postBtn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
//    //    postBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
//    postBtn.layer.cornerRadius = 25*kiphone6;
//    postBtn.layer.masksToBounds = YES;
//    [postBtn addTarget:self action:@selector(postBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:postBtn];
//    
//    WS(ws);
//    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(ws.view).with.offset(-54*kiphone6);
//        make.right.equalTo(ws.view).with.offset(-12*kiphone6);
//        make.size.mas_equalTo(CGSizeMake(49*kiphone6 ,49*kiphone6));
//    }];

}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [self.headerImageView addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.tag = tag;
    if (btn.tag==101) {
        self.underwayBtn = btn;
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    }else{
        self.endBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
//    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    [self.scrollowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sender);
        make.top.equalTo(sender.mas_bottom);
        make.height.offset(2*kiphone6);
    }];
    if (sender.tag == 101) {
//        self.endBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.endBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
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
//        self.underwayBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.underwayBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
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
    detailVc.activityId = cell.model.info_id;
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
    
    YJNoticeListTableVC *vc = [[YJNoticeListTableVC alloc]init];
    vc.noticeType = 2;
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
