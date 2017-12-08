//
//  YJRepairRecoderVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/6.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRepairRecoderVC.h"
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
//#import "UIViewController+Cloudox.h"

static NSInteger start = 0;//上拉加载起始位置
static NSString* tableCellid = @"table_cell";
@interface YJRepairRecoderVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *typeselectBtn;//全部类型btn
@property(nonatomic,weak)UIButton *stateselectBtn;//全部状态btn
@property(nonatomic,weak)UIButton *firstBtn;
@property(nonatomic,weak)UIButton *secondBtn;
@property(nonatomic,weak)UIButton *thirdBtn;
@property(nonatomic,weak)UIButton *fourthBtn;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,assign)int repairType;//报修类型(0=全部 1=水电燃气 2=房屋报修 3=公共设施报修")
@property(nonatomic,assign)int state;//报修类型(0=全部 1=待处理 2=处理中 3=已处理")
@property(nonatomic,strong)NSString *repairTypeId;
@property(nonatomic, assign)NSInteger flag;//我要报修和报修记录按钮标记
@property(nonatomic, assign)NSInteger stateFlag;//报修状态按钮标记
//
@property(nonatomic,weak)UITableView *recordTableView;
@property(nonatomic,strong)NSMutableArray *recordArr;
@property(nonatomic,weak)UIView *backGrayView;//类型选择半透明背景
@property(nonatomic,strong)NSMutableDictionary *cellHeightCache;// 1 .给tableview添加缓存行高属性(字典需要懒加载)
@end

@implementation YJRepairRecoderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"全部类型"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"全部状态"andTag:102];
//        }--------------开始直接请求全部类型，全部状态数据---------------------
    self.repairType = 0;
    self.state = 0;
    http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
        [SVProgressHUD show];// 动画开始
        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&start=0&limit=10&state=%d&repairType=%d",mPrefixUrl,mDefineToken1,self.state,self.repairType];
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
                start = self.recordArr.count;
                    //添加tableView
                    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
                    self.recordTableView = tableView;
                    [self.view addSubview:tableView];
                    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.typeselectBtn.mas_bottom);
                        make.left.right.bottom.offset(0);
                    }];
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    [tableView registerClass:[YJRepairRecordTableViewCell class] forCellReuseIdentifier:tableCellid];
                    tableView.delegate =self;
                    tableView.dataSource = self;
                    tableView.rowHeight = UITableViewAutomaticDimension;
                    tableView.estimatedRowHeight = 180*kiphone6;
                    __weak typeof(self) weakSelf = self;
                    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
                        [SVProgressHUD show];// 动画开始
        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&start=0&limit=10&state=%d&repairType=%d",mPrefixUrl,mDefineToken1,self.state,self.repairType];
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
        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&start=%ld&limit=10&state=%d&repairType=%d",mPrefixUrl,mDefineToken1,start,self.state,self.repairType];
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
//大按钮(确定查询的是什么状态和什么类型)
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.typeselectBtn = btn;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [btn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.offset(0);
            make.width.offset(1);
        }];
    }else{
        self.stateselectBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    self.flag = sender.tag;//记录是报修类型还是报修状态按钮
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.stateselectBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.stateselectBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.stateselectBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        NSArray *typeArr = @[@"全部类型",@"房屋报修",@"水电燃气",@"公共设施"];
        if (self.typeView) {
            [self.firstBtn setTitle:typeArr[0] forState:UIControlStateNormal];
            [self.secondBtn setTitle:typeArr[1] forState:UIControlStateNormal];
            [self.thirdBtn setTitle:typeArr[2] forState:UIControlStateNormal];
            [self.fourthBtn setTitle:typeArr[3] forState:UIControlStateNormal];
            self.typeView.hidden = false;
            self.backGrayView.hidden = false;
        }else{
            [self addTypeViewWith:typeArr :@"全部类型"];
        }
    }else{
        [self.typeselectBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.typeselectBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        NSArray *typeArr = @[@"全部状态",@"待维修",@"处理中",@"已完成"];
        if (self.typeView) {
            [self.firstBtn setTitle:typeArr[0] forState:UIControlStateNormal];
            [self.secondBtn setTitle:typeArr[1] forState:UIControlStateNormal];
            [self.thirdBtn setTitle:typeArr[2] forState:UIControlStateNormal];
            [self.fourthBtn setTitle:typeArr[3] forState:UIControlStateNormal];
            self.typeView.hidden = false;
            self.backGrayView.hidden = false;
        }else{
            [self addTypeViewWith:typeArr :@"全部状态"];
        }
    }
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    //移除view
//    [gesture.view removeFromSuperview];
    self.typeView.hidden = true;
    self.backGrayView.hidden = true;
}

-(void)addTypeViewWith:(NSArray*)typeArr :(NSString*)title{
    //大蒙布View
    if (!self.backGrayView) {
        UIView *backGrayView = [[UIView alloc]init];
        self.backGrayView = backGrayView;
        backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        backGrayView.alpha = 0.3;
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
    }else{
        self.backGrayView.hidden = false;
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
        btn.tag = 50+i;
        if (btn.tag == 50) {
            self.firstBtn = btn;
        }else if (btn.tag == 51){
            self.secondBtn = btn;
        }else if (btn.tag == 52){
            self.thirdBtn = btn;
        }else{
            self.fourthBtn = btn;
        }
        [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//具体记录类型和状态按钮的点击事件
-(void)selectType:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.typeView.hidden = true;
    self.backGrayView.hidden = true;
    if (self.flag==101) {//确定请求类型
        [self.typeselectBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    }else{
        [self.stateselectBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    }
        switch (sender.tag) {
            case 50:
                if (self.flag==101) {//确定请求类型
                    self.repairType = 0;
                }else{//确定请求状态
                    self.state = 0;
                }
//                self.repairTypeId = [NSString stringWithFormat:@"%d",0];
                self.secondBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.secondBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.thirdBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.thirdBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.fourthBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.fourthBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                break;
            case 51:
                if (self.flag==101) {//确定请求类型
                    self.repairType = 1;
                }else{//确定请求状态
                    self.state = 1;
                }
                self.firstBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.firstBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.thirdBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.thirdBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.fourthBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.fourthBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                break;
            case 52:
                if (self.flag==101) {//确定请求类型
                    self.repairType = 2;
                }else{//确定请求状态
                    self.state = 2;
                }
                self.firstBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.firstBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.secondBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.secondBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.fourthBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.fourthBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                break;
            case 53:
                if (self.flag==101) {//确定请求类型
                    self.repairType = 3;
                }else{//确定请求状态
                    self.state = 3;
                }
                self.firstBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.firstBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.secondBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.secondBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                self.thirdBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [self.thirdBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
        [SVProgressHUD show];// 动画开始
        NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&start=0&limit=10&state=%d&repairType=%d",mPrefixUrl,mDefineToken1,self.state,self.repairType];
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
                [self.recordTableView reloadData];
                if (self.recordArr.count>0) {
                    start = self.recordArr.count;
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];// 动画结束
            return ;
        }];
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
    [cell.urlStrs removeAllObjects];//必须移除，否则在cell复用时候会连起来
    cell.model = self.recordArr[indexPath.row];
        WS(ws);
        //    http://192.169.1.55:8080/smarthome/mobileapi/repair/updateState.do?token=ACDCE729BCE6FABC50881A867CAFC1BC &id=1 &state=2
    __weak typeof(cell) weakCell = cell;
    cell.clickBtnBlock = ^(){//在待处理状态下可以取消维修
    [SVProgressHUD show];// 动画开始
    NSString *changeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/updateState.do?token=%@&id=%ld&state=4",mPrefixUrl,mDefineToken1,weakCell.model.info_id];
    [[HttpClient defaultClient]requestWithPath:changeUrlStr method:0 parameters:nil prepareExecute:^{                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];// 动画结束
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                http://localhost:8080/smarthome/mobileapi/repair/findRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&state=1&start=0&limit=2
                    [SVProgressHUD show];// 动画开始
                    NSString *recordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/findRecord.do?token=%@&start=0&limit=10&state=%d&repairType=%d",mPrefixUrl,mDefineToken1,self.state,self.repairType];
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
    // 2 .给tableview缓存行高属性赋值并计算
    YJReportRepairRecordModel *comModel = self.recordArr[indexPath.row];// 2.1 找到这个cell对应的数据模型
    NSString *thisId = [NSString stringWithFormat:@"%ld",comModel.info_id];// 2.2 取出模型对应id作为cell缓存行高对应key
    CGFloat cacheHeight = [[self.cellHeightCache valueForKey:thisId] doubleValue];// 2.3 根据这个key取这个cell的高度
    if (cacheHeight) {// 2.4 如果取得到就说明已经存过了，不需要再计算，直接返回这个高度
        return cacheHeight;
    }
    YJRepairRecordTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:tableCellid];// 2.4 如果没有取到值说明是第一遍，需要取一个cell(作为计算模型)并给cell的数据model赋值，进而计算出这个cell的高度
    commentCell.model = comModel;// 2.5 赋值并在cell中计算
    [self.cellHeightCache setValue:@(commentCell.cellHeight) forKey:thisId];// 2.6 取cell计算出的高度存入tableview的缓存行高字典里，方便读取
//            NSLog(@"%@",self.cellHeightCache);
    return commentCell.cellHeight;
 }
-(NSMutableDictionary *)cellHeightCache{
    if (_cellHeightCache == nil) {
        _cellHeightCache = [[NSMutableDictionary alloc]init];
    }
    return _cellHeightCache;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
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
