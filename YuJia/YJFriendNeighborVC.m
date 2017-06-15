//
//  YJFriendNeighborVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJFriendNeighborVC.h"
#import "YJHeaderTitleBtn.h"
#import "YJFriendStateTableViewCell.h"
#import "YJPostFriendStateVC.h"
#import "UIButton+Badge.h"
#import "YJFriendStateDetailVC.h"
#import "YJPostFriendStateVC.h"
#import "YJNoticeListTableVC.h"
#import "YJFriendNeighborStateModel.h"
#import <MJRefresh.h>
#import "RKNotificationHub.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

static NSInteger start = 0;
static NSString* tableCellid = @"table_cell";
@interface YJFriendNeighborVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *myCommunityBtn;
@property(nonatomic,weak)UIButton *otherCommunityBtn;
@property(nonatomic,weak)UIView *blueView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *areaArr;
@property(nonatomic,strong)NSMutableArray *statesArr;
@property(nonatomic,strong)NSString *categoryId;
@property(nonatomic,strong)NSString *rqId;
@property(nonatomic,weak)UIView *selectView;//选择自己小区
@property(nonatomic,strong)NSString *visibleRange;//可见小区
@property(nonatomic,assign)long userId;

@property(nonatomic,strong)RKNotificationHub *barHub;//bage
@property(nonatomic,assign)Boolean isHasMessage;//是否有消息

@end

@implementation YJFriendNeighborVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"友邻圈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self checkHasMessade];
    [self loadData];
    
}
-(void)checkHasMessade{
    //添加右侧消息中心按钮
    UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [informationBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
//  http://192.168.1.55:8080/smarthome/mobileapi/message/hasmessage.do?msgType=&token=9DB2FD6FDD2F116CD47CE6C48B3047EE&msgTypeBegin=2&msgTypeEnd=3
    NSString *checkUrlStr = [NSString stringWithFormat:@"%@/mobileapi/message/hasmessage.do?msgType=&token=%@&msgTypeBegin=11&msgTypeEnd=30",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:checkUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *isHasMessage = responseObject[@"hasMessage"];
            self.isHasMessage = [isHasMessage boolValue];
            if (self.isHasMessage) {
                self.barHub = [[RKNotificationHub alloc] initWithBarButtonItem: self.navigationItem.rightBarButtonItem];//初始化bageView
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
    [SVProgressHUD show];// 动画开始
//    http://192.168.1.55:8080/smarthome/mobileapi/residentialQuarters/findRQ.do?token=EC9CDB5177C01F016403DFAAEE3C1182  获取小区
    NSString *areaUrlStr = [NSString stringWithFormat:@"%@/mobileapi/residentialQuarters/findRQ.do?token=%@",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:areaUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            self.areaArr = responseObject[@"result"];
            [self setupUI];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:@"您还未登陆，请登录后再试"];
        }else if ([responseObject[@"code"] isEqualToString:@"-2"]){
            [SVProgressHUD showErrorWithStatus:@"您的信息还不够完善，请完善信息"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
}
-(void)setupUI{
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"我的小区"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"其他小区"andTag:102];
    UIView *barView = [[UIView alloc]init];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.myCommunityBtn.mas_bottom);
        make.height.offset(30*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [barView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    NSArray *itemArr = @[@"全部",@"健康",@"居家",@"母婴",@"旅游",@"美食",@"宠物"];
    for (int i=0; i<itemArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 1+i;
        [btn setTitle:itemArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [barView addSubview:btn];
        [btn sizeToFit];
        CGSize size = btn.bounds.size;
        CGFloat margen = (kScreenW-20*kiphone6-7*size.width)/6;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10*kiphone6+i*(margen+size.width));
            make.centerY.equalTo(barView);
        }];
        
        [btn addTarget:self action:@selector(scrollBlueView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];
    [barView addSubview:blueView];
    self.blueView = blueView;
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.bottom.offset(0);
        make.width.offset(28*kiphone6);
        make.height.offset(2.5*kiphone6);
    }];
    http://192.168.1.55:8080/smarthome/mobileapi/state/findstate.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE
//    &residentialQuartersId=2
//    &visibleRange=1
//    &start=0
//    &limit=4
//    &categoryId=1
    [SVProgressHUD show];// 动画开始
    if (self.areaArr.count) {
        self.rqId = self.areaArr[0][@"id"];
    }
    self.visibleRange = [NSString stringWithFormat:@"%d",1];
    self.categoryId = [NSString stringWithFormat:@"%d",1];
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=%@&start=0&limit=4&categoryId=1",mPrefixUrl,mDefineToken1,self.rqId,self.visibleRange];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *userId = responseObject[@"userid"];
            self.userId = [userId integerValue];
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.statesArr = mArr;
            start = self.statesArr.count;
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
    self.tableView = tableView;
    [self.view addSubview:tableView];
    //    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueView.mas_bottom).offset(5*kiphone6);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJFriendStateTableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight =  235*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=%@&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,weakSelf.rqId,weakSelf.visibleRange,weakSelf.categoryId];
        [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                weakSelf.statesArr = mArr;
                start = weakSelf.statesArr.count;
                [weakSelf.tableView reloadData];
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
        if (self.statesArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=%@&start=%ld&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,weakSelf.rqId,weakSelf.visibleRange,start,weakSelf.categoryId];
        [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                for (NSDictionary *dic in arr) {
                    YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                    [weakSelf.statesArr addObject:infoModel];
                }
                start = weakSelf.statesArr.count;
                [weakSelf.tableView reloadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
//                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
//            if (weakSelf.commentInfos.count==3||weakSelf.commentInfos.count==4) {//第一次刷新需要滑动到的位置
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
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
-(void)scrollBlueView:(UIButton*)sender{
    [UIView animateWithDuration:0.3 animations:^{
        [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.width.offset(28*kiphone6);
            make.height.offset(2.5*kiphone6);
            make.centerX.equalTo(sender);
        }];
    }];
    [SVProgressHUD show];// 动画开始
    self.categoryId = [NSString stringWithFormat:@"%ld",sender.tag];
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=1&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,self.rqId,self.categoryId];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.statesArr = mArr;
            start = self.statesArr.count;
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            self.statesArr = [NSMutableArray array];
            start = self.statesArr.count;
            [self.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];

    
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.myCommunityBtn = btn;
    }else{
        self.otherCommunityBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.otherCommunityBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.otherCommunityBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.otherCommunityBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.visibleRange = @"1";
        if (self.areaArr.count>1) {
            if (self.selectView) {
                if (self.selectView.hidden==false) {
                    self.selectView.hidden=true;
                }else{
                    self.selectView.hidden=false;
                }
                
            }else{
                UIView *selectView = [[UIView alloc]init];
                selectView.backgroundColor = [UIColor whiteColor];
                selectView.layer.borderColor = [UIColor colorWithHexString:@"#cccaca"].CGColor;
                selectView.layer.borderWidth =1*kiphone6/[UIScreen mainScreen].scale;
                [self.view addSubview:selectView];
                [self.view bringSubviewToFront:selectView];
                [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(sender);
                    make.top.equalTo(sender.mas_bottom);
                    make.height.offset(28*kiphone6*self.areaArr.count);
                }];
                self.selectView =selectView;
                for (int i=0; i<self.areaArr.count; i++) {
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*28*kiphone6, 130*kiphone6, 28*kiphone6)];
                    btn.tag = [self.areaArr[i][@"id"] integerValue]+50;
                    [btn setTitle:self.areaArr[i][@"rname"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [selectView addSubview:btn];
                    [btn addTarget:self action:@selector(updateAreaType:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else if (self.areaArr.count==1){
            self.rqId = self.areaArr[0][@"id"];
            [SVProgressHUD show];// 动画开始
            NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=%@&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,self.rqId,self.visibleRange,self.categoryId];
            [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];// 动画结束
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    NSArray *arr = responseObject[@"result"];
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    self.statesArr = mArr;
                    start = self.statesArr.count;
                    [self.tableView reloadData];
                }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                    self.statesArr = [NSMutableArray array];
                    start = self.statesArr.count;
                    [self.tableView reloadData];
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];// 动画结束
                return ;
            }];
        }
        }else{
        self.myCommunityBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.myCommunityBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.myCommunityBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.visibleRange = [NSString stringWithFormat:@"%d",2];
            [SVProgressHUD show];// 动画开始
            NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=%@&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,self.rqId,self.categoryId,self.visibleRange];
            [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];// 动画结束
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    NSArray *arr = responseObject[@"result"];
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    self.statesArr = mArr;
                    start = self.statesArr.count;
                    [self.tableView reloadData];
                }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                    self.statesArr = [NSMutableArray array];
                    start = self.statesArr.count;
                    [self.tableView reloadData];
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];// 动画结束
                return ;
            }];
    }
}
-(void)updateAreaType:(UIButton*)sender{
    
    self.rqId = [NSString stringWithFormat:@"%ld",sender.tag-50];
    self.selectView.hidden = true;
    [SVProgressHUD show];// 动画开始
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=1&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,self.rqId,self.categoryId];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.statesArr = mArr;
            start = self.statesArr.count;
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            self.statesArr = [NSMutableArray array];
            start = self.statesArr.count;
            [self.tableView reloadData];
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

 return self.statesArr.count;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJFriendStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.statesArr[indexPath.row];
    WS(ws);
    cell.commentBtnBlock = ^(YJFriendNeighborStateModel *model){
        YJFriendStateDetailVC *detailVc = [[YJFriendStateDetailVC alloc]init];
        detailVc.userId = ws.userId;
        detailVc.model = model;
        [ws.navigationController pushViewController:detailVc animated:true];
        [detailVc.commentField becomeFirstResponder];
    };
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJFriendNeighborStateModel *model = self.statesArr[indexPath.row];
    return[YJFriendStateTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        YJFriendStateTableViewCell *cell = (YJFriendStateTableViewCell *)sourceCell;
        
        // 配置数据
        [cell configCellWithModel:model indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey :[NSString stringWithFormat:@"%ld",model.info_id],
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(model.shouldUpdateCache)};
        model.shouldUpdateCache = NO;
        return cache;
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJFriendStateDetailVC *detailVc = [[YJFriendStateDetailVC alloc]init];
    YJFriendStateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    detailVc.userId = self.userId;
    detailVc.stateId = cell.model.info_id;
    [self.navigationController pushViewController:detailVc animated:true];
}

- (void)postBtn:(UIButton*)sender {
    YJPostFriendStateVC *vc = [[YJPostFriendStateVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
-(void)deleRefresh{
    // 进入刷新状态后会自动调用这个block
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findstate.do?token=%@&RQid=%@&visibleRange=%@&start=0&limit=4&categoryId=%@",mPrefixUrl,mDefineToken1,self.rqId,self.visibleRange,self.categoryId];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.statesArr = mArr;
            start = self.statesArr.count;
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        return ;
    }];
}
-(void)informationBtnClick:(UIButton*)sender{

    YJNoticeListTableVC *vc = [[YJNoticeListTableVC alloc]init];
    vc.noticeType = 1;
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
