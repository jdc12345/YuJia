//
//  YJRepairRecoderVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/6.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRepairRecoderVC.h"
#import "UIColor+colorValues.h"
#import "YJHeaderTitleBtn.h"
#import "UILabel+Addition.h"
#import "YJRepairBaseInfoTableViewCell.h"
#import "BRPlaceholderTextView.h"
#import "YJPhotoFlowLayout.h"
#import "YJPhotoAddBtnCollectionViewCell.h"
#import <HUImagePickerViewController.h>
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import "YJRepairSectionTwoTableViewCell.h"
#import "YJRepairRecordTableViewCell.h"
#import "AFNetworking.h"
#import "YJReportRepairRecordModel.h"
#import <MJRefresh.h>
#import "UIViewController+Cloudox.h"

static NSInteger start = 0;//上拉加载起始位置
static NSString* tableCellid = @"table_cell";
@interface YJRepairRecoderVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *repairBtn;
@property(nonatomic,weak)UIButton *recordBtn;
@property(nonatomic,weak)UIButton *firstTypeBtn;
@property(nonatomic,weak)UIButton *secondTypeBtn;
@property(nonatomic,weak)UIButton *thirdTypeBtn;
@property(nonatomic,weak)UIButton *fourthTypeBtn;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,strong)NSString *repairType;
@property(nonatomic,strong)NSString *repairTypeId;
@property(nonatomic, assign)NSInteger flag;//我要报修和报修记录按钮标记
@property(nonatomic, assign)NSInteger stateFlag;//报修状态按钮标记
//
@property(nonatomic,weak)UITableView *recordTableView;
@property(nonatomic,strong)NSMutableArray *recordArr;
@property(nonatomic,weak)UIView *backGrayView;//类型选择半透明背景

@end

@implementation YJRepairRecoderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"全部类型"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"全部状态"andTag:102];
//    if (self.flag==101) {
//        self.repairType = @"全部类型";
//    }else{
//        NSString *state = @"";
//        if (self.stateFlag==51) {
//            //加载 待维修 数据
//            state = @"1";
//        }else if (self.stateFlag==52){
//            //加载 处理中 数据
//            state = @"2";
//        }else if (self.stateFlag==53){
//            //加载 已完成 数据
//            state = @"3";
    NSString *state = @"3";
//        }--------------开始直接请求全部类型，全部状态数据---------------------
    http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
        [SVProgressHUD show];// 动画开始
        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=0&limit=2",mPrefixUrl,mDefineToken1,state];
        [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                self.recordArr = mArr;
                    //添加tableView
                    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
                    self.recordTableView = tableView;
                    [self.view addSubview:tableView];
                    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.repairBtn.mas_bottom);
                        make.left.right.bottom.offset(0);
                    }];
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    [tableView registerClass:[YJRepairRecordTableViewCell class] forCellReuseIdentifier:tableCellid];
                    //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
                    tableView.delegate =self;
                    tableView.dataSource = self;
                    tableView.rowHeight = UITableViewAutomaticDimension;
                    tableView.estimatedRowHeight = 180*kiphone6;
                    __weak typeof(self) weakSelf = self;
                    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        // 进入刷新状态后会自动调用这个block
                        NSString *state = @"";
                        if (weakSelf.stateFlag==51) {
                            //加载 待维修 数据
                            state = @"1";
                        }else if (weakSelf.stateFlag==52){
                            //加载 处理中 数据
                            state = @"2";
                        }else if (weakSelf.stateFlag==53){
                            //加载 已完成 数据
                            state = @"3";
                        }
                    http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
                        [SVProgressHUD show];// 动画开始
                        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=0&limit=2",mPrefixUrl,mDefineToken1,state];
                        [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                            [SVProgressHUD dismiss];// 动画结束
                            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                                NSArray *arr = responseObject[@"result"];
                                NSMutableArray *mArr = [NSMutableArray array];
                                for (NSDictionary *dic in arr) {
                                    YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                                    [mArr addObject:infoModel];
                                }
                                weakSelf.recordArr = mArr;
                                start = weakSelf.recordArr.count;
                                [weakSelf.recordTableView reloadData];
                            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                            }
                            [weakSelf.recordTableView.mj_header endRefreshing];
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [weakSelf.recordTableView.mj_header endRefreshing];
                            return ;
                        }];
                        
                    }];
                    //设置上拉加载更多
                    self.recordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        // 进入加载状态后会自动调用这个block
                        if (self.recordArr.count==0) {
                            [weakSelf.recordTableView.mj_footer endRefreshing];
                            return ;
                        }
                        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=%ld&limit=2",mPrefixUrl,mDefineToken1,state,start];
                        [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                            [SVProgressHUD dismiss];// 动画结束
                            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                                NSArray *arr = responseObject[@"result"];
                                for (NSDictionary *dic in arr) {
                                    YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                                    [weakSelf.recordArr addObject:infoModel];
                                }
                                start = weakSelf.recordArr.count;
                                [weakSelf.recordTableView reloadData];
                            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                            }
                            //            if (weakSelf.commentInfos.count==3||weakSelf.commentInfos.count==4) {//第一次刷新需要滑动到的位置
                            //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            //                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            //            }
                            [weakSelf.recordTableView.mj_footer endRefreshing];
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [weakSelf.recordTableView.mj_footer endRefreshing];
                            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
                            return ;
                        }];
                    }];
                    
                if (self.recordArr.count>0) {
                    start = self.recordArr.count;
                }
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
        self.repairBtn = btn;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [btn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.offset(0);
            make.width.offset(1);
        }];
    }else{
        self.recordBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    self.flag = sender.tag;//记录是我要报修还是报修记录按钮
//    self.tableView.hidden = true;
//    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.recordBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.recordBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.recordBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        NSArray *typeArr = @[@"全部",@"房屋报修",@"水电燃气",@"公共设施"];
        if (self.typeView) {
            [self.firstTypeBtn setTitle:typeArr[0] forState:UIControlStateNormal];
            [self.secondTypeBtn setTitle:typeArr[1] forState:UIControlStateNormal];
            [self.thirdTypeBtn setTitle:typeArr[2] forState:UIControlStateNormal];
            [self.fourthTypeBtn setTitle:typeArr[3] forState:UIControlStateNormal];
            self.typeView.hidden = false;
        }else{
            
            [self addTypeViewWith:typeArr :@"全部类型"];
            
        }
    }else{
//        self.recordTableView.hidden = true;
//        self.repairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.repairBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.repairBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        NSArray *typeArr = @[@"全部",@"待维修",@"处理中",@"已完成"];
        if (self.typeView) {
            [self.firstTypeBtn setTitle:typeArr[0] forState:UIControlStateNormal];
            [self.secondTypeBtn setTitle:typeArr[1] forState:UIControlStateNormal];
            [self.thirdTypeBtn setTitle:typeArr[2] forState:UIControlStateNormal];
            [self.fourthTypeBtn setTitle:typeArr[3] forState:UIControlStateNormal];
            self.typeView.hidden = false;
        }else{
            
            [self addTypeViewWith:typeArr :@"全部状态"];
        }
    }
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    //移除view
    [gesture.view removeFromSuperview];
    [self.typeView removeFromSuperview];
//    [self.monthPickerView removeFromSuperview];
}
-(void)addTypeViewWith:(NSArray*)typeArr :(NSString*)title{
    //大蒙布View
    if (!self.backGrayView) {
        UIView *backGrayView = [[UIView alloc]init];
        self.backGrayView = backGrayView;
        backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        backGrayView.alpha = 0.2;
        [self.view.window addSubview:backGrayView];
        [backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.bottom.right.offset(0);
        }];
        backGrayView.userInteractionEnabled = YES;
        //添加tap手势：
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        [backGrayView addGestureRecognizer:tapGesture];
    }
    //类型view
    UIView *view = [[UIView alloc]init];
    view.layer.masksToBounds = true;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view.window addSubview:view];
    self.typeView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.window);
        make.top.offset(162*kiphone6);
        make.width.offset(325*kiphone6);
        make.height.offset(114*kiphone6);
    }];
    UILabel *allTypeLabel = [UILabel labelWithText:title andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [view addSubview:allTypeLabel];
    [allTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view.mas_top).offset(12*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(37*kiphone6);
        make.height.offset(1*kiphone6);
    }];
    for (int i = 0; i<4; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
        btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [btn setTitle:typeArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.frame = CGRectMake(10*kiphone6+i*79*kiphone6, 63*kiphone6, 70*kiphone6, 25*kiphone6);
        btn.tag = 51+i;
        if (btn.tag == 51) {
            self.firstTypeBtn = btn;
        }else if (btn.tag == 52){
            self.secondTypeBtn = btn;
        }else if (btn.tag == 53){
            self.thirdTypeBtn = btn;
        }else{
            self.fourthTypeBtn = btn;
        }
        [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)selectType:(UIButton*)sender{
    self.stateFlag = sender.tag;//记录保修状态
    sender.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.typeView.hidden = true;
    if (sender.tag == 51) {
        self.repairTypeId = [NSString stringWithFormat:@"%d",1];
        self.secondTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.secondTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.thirdTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.thirdTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.fourthTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.fourthTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else if (sender.tag == 52){
        self.repairTypeId = [NSString stringWithFormat:@"%d",2];
        self.firstTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.firstTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.thirdTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.thirdTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.fourthTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.fourthTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else if (sender.tag == 53){
        self.repairTypeId = [NSString stringWithFormat:@"%d",3];
        self.firstTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.firstTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.secondTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.secondTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.fourthTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.fourthTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else if (sender.tag == 54){
        self.repairTypeId = [NSString stringWithFormat:@"%d",3];
        self.firstTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.firstTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.secondTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.secondTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.thirdTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.thirdTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
    
    if (self.flag==101) {//确定请求类型
        self.repairType = sender.titleLabel.text;
            }else{//确定请求状态
        NSString *state = @"";
        if (self.stateFlag==51) {
            //加载 待维修 数据
            state = @"1";
        }else if (self.stateFlag==52){
            //加载 处理中 数据
            state = @"2";
        }else if (self.stateFlag==53){
            //加载 已完成 数据
            state = @"3";
        }
    http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
        [SVProgressHUD show];// 动画开始
        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=0&limit=2",mPrefixUrl,mDefineToken1,state];
        [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                self.recordArr = mArr;
                if (self.recordTableView) {
                    self.recordTableView.hidden = false;
                    [self.recordTableView reloadData];
                }else{
                    //添加tableView
                    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
                    self.recordTableView = tableView;
                    [self.view addSubview:tableView];
                    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.repairBtn.mas_bottom);
                        make.left.right.bottom.offset(0);
                    }];
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    [tableView registerClass:[YJRepairRecordTableViewCell class] forCellReuseIdentifier:tableCellid];
                    //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
                    tableView.delegate =self;
                    tableView.dataSource = self;
                    tableView.rowHeight = UITableViewAutomaticDimension;
                    tableView.estimatedRowHeight = 180*kiphone6;
                    __weak typeof(self) weakSelf = self;
                    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                        // 进入刷新状态后会自动调用这个block
                        NSString *state = @"";
                        if (weakSelf.stateFlag==51) {
                            //加载 待维修 数据
                            state = @"1";
                        }else if (weakSelf.stateFlag==52){
                            //加载 处理中 数据
                            state = @"2";
                        }else if (weakSelf.stateFlag==53){
                            //加载 已完成 数据
                            state = @"3";
                        }
                    http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
                        [SVProgressHUD show];// 动画开始
                        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=0&limit=2",mPrefixUrl,mDefineToken1,state];
                        [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                            [SVProgressHUD dismiss];// 动画结束
                            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                                NSArray *arr = responseObject[@"result"];
                                NSMutableArray *mArr = [NSMutableArray array];
                                for (NSDictionary *dic in arr) {
                                    YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                                    [mArr addObject:infoModel];
                                }
                                weakSelf.recordArr = mArr;
                                start = weakSelf.recordArr.count;
                                [weakSelf.recordTableView reloadData];
                            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                            }
                            [weakSelf.recordTableView.mj_header endRefreshing];
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [weakSelf.recordTableView.mj_header endRefreshing];
                            return ;
                        }];
                        
                    }];
                    //设置上拉加载更多
                    self.recordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        // 进入加载状态后会自动调用这个block
                        if (self.recordArr.count==0) {
                            [weakSelf.recordTableView.mj_footer endRefreshing];
                            return ;
                        }
                        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=%ld&limit=2",mPrefixUrl,mDefineToken1,state,start];
                        [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
                            
                        } success:^(NSURLSessionDataTask *task, id responseObject) {
                            [SVProgressHUD dismiss];// 动画结束
                            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                                NSArray *arr = responseObject[@"result"];
                                for (NSDictionary *dic in arr) {
                                    YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                                    [weakSelf.recordArr addObject:infoModel];
                                }
                                start = weakSelf.recordArr.count;
                                [weakSelf.recordTableView reloadData];
                            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                            }
                            //            if (weakSelf.commentInfos.count==3||weakSelf.commentInfos.count==4) {//第一次刷新需要滑动到的位置
                            //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            //                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            //            }
                            [weakSelf.recordTableView.mj_footer endRefreshing];
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [weakSelf.recordTableView.mj_footer endRefreshing];
                            [SVProgressHUD showErrorWithStatus:@"刷新失败"];
                            return ;
                        }];
                    }];
                    
                }
                if (self.recordArr.count>0) {
                    start = self.recordArr.count;
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];// 动画结束
            return ;
        }];
        
        
    }
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.recordArr.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        YJRepairRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        cell.model = self.recordArr[indexPath.row];
        WS(ws);
        //    http://192.169.1.55:8080/smarthome/mobileapi/repair/updateState.do?token=ACDCE729BCE6FABC50881A867CAFC1BC &id=1 &state=2
        __weak typeof(cell) weakCell = cell;
        cell.clickBtnBlock = ^(NSString *state){
            [SVProgressHUD show];// 动画开始
            NSString *changeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/updateState.do?token=%@&id=%ld&state=%@",mPrefixUrl,mDefineToken1,weakCell.model.info_id,state];
            [[HttpClient defaultClient]requestWithPath:changeUrlStr method:0 parameters:nil prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];// 动画结束
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    if ([state isEqualToString:@"4"]) {
                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                    }
                    if ([state isEqualToString:@"3"]) {
                        [SVProgressHUD showSuccessWithStatus:@"已完成维修"];
                    }
                    NSString *bigState = @"";
                    if (ws.stateFlag==51) {
                        //加载 待维修 数据
                        bigState = @"1";
                    }else if (ws.stateFlag==52){
                        //加载 处理中 数据
                        bigState = @"2";
                    }else if (ws.stateFlag==53){
                        //加载 已完成 数据
                        bigState = @"3";
                    }
                http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
                    [SVProgressHUD show];// 动画开始
                    NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&state=%@&start=0&limit=2",mPrefixUrl,mDefineToken1,bigState];
                    [[HttpClient defaultClient]requestWithPath:recordUrlStr method:0 parameters:nil prepareExecute:^{
                        
                    } success:^(NSURLSessionDataTask *task, id responseObject) {
                        [SVProgressHUD dismiss];// 动画结束
                        if ([responseObject[@"code"] isEqualToString:@"0"]) {
                            NSArray *arr = responseObject[@"result"];
                            NSMutableArray *mArr = [NSMutableArray array];
                            for (NSDictionary *dic in arr) {
                                YJReportRepairRecordModel *infoModel = [YJReportRepairRecordModel mj_objectWithKeyValues:dic];
                                [mArr addObject:infoModel];
                            }
                            ws.recordArr = mArr;
                            [ws.recordTableView reloadData];
                            if (ws.recordArr.count>0) {
                                start = ws.recordArr.count;
                            }
                        }
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [SVProgressHUD dismiss];// 动画结束
                        return ;
                    }];
                    
                }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                    [SVProgressHUD showErrorWithStatus:@"状态修改失败"];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];// 动画结束
                return ;
            }];
            
        };
        return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return UITableViewAutomaticDimension;//自动计算并缓存行高
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
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
