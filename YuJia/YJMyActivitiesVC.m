//
//  YJMyActivitiesVC.m
//  YuJia
//
//  Created by 万宇 on 2017/9/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJMyActivitiesVC.h"
#import "UIBarButtonItem+Helper.h"
#import <MJRefresh.h>
#import "YJHeaderTitleBtn.h"
#import "YJCommunityActivitiesTVCell.h"
#import "YJActivitiesDetailsVC.h"
#import "YJActivitiesDetailModel.h"
#import "AFNetworking.h"

static NSInteger start = 0;
static NSString* tableCellid = @"table_cell";
@interface YJMyActivitiesVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isSelecting;//判断是否正在选择
@property (nonatomic, assign) BOOL isAllSelected;//判断是否全选
@property (nonatomic, weak) UIButton *deletSelectedBtn;//删除所选btn
@property (nonatomic, weak) UIButton *allSelectBtn;//全选btn
//@property (nonatomic, weak) UIButton *addBtn;//添加btn
@property (nonatomic, weak) UIView *editView;//处于编辑状态的下侧view
@property(nonatomic,strong)NSArray *areaArr;//小区数据
@property(nonatomic,strong)NSMutableArray *activiesArr;//状态数据源
@property(nonatomic,strong)NSMutableArray *selectBtnArr;//选择按钮状态数组
//@property(nonatomic,strong)NSString *categoryId;//分类id
//@property(nonatomic,strong)NSString *rqId;//小区ID
//@property(nonatomic,strong)NSString *visibleRange;//可见小区
@property(nonatomic,assign)long userId;
//@property(nonatomic,strong)NSDictionary *personal;//个人信息
//@property(nonatomic,strong)NSMutableDictionary *cellHeightCache;// 1 .给tableview添加缓存行高属性(字典需要懒加载)
@property(nonatomic,assign)NSInteger over;//当前页面显示的活动状态
@end

@implementation YJMyActivitiesVC

- (NSMutableArray *)activiesArr{
    if (_activiesArr == nil) {
        _activiesArr = [[NSMutableArray alloc]init];
    }
    return _activiesArr;
}
-(NSMutableArray *)selectBtnArr{
    if (_selectBtnArr == nil) {
        _selectBtnArr = [[NSMutableArray alloc]init];
    }
    return _selectBtnArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的活动";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.navigationController.navigationBar.translucent = false;
    self.isSelecting = NO;
    [self loadActivitysData];
    [self setUPTabView];
    [self setEditView];
    
}
//添加tableview
-(void)setUPTabView{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCommunityActivitiesTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight =  235*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    //下拉刷新、上拉加载
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=1&start=0&limit=10",mPrefixUrl,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSString *userId = responseObject[@"userid"];
                weakSelf.userId = [userId integerValue];
                NSArray *arr = responseObject[@"result"];
                [self.activiesArr removeAllObjects];
                [self.selectBtnArr removeAllObjects];//刷新需要先清除数据
                for (NSDictionary *dic in arr) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                    infoModel.over = weakSelf.over;//传入活动状态
                    [weakSelf.activiesArr addObject:mArr];
                }
                start = weakSelf.activiesArr.count;
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
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入加载状态后会自动调用这个block
        if (self.activiesArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivity.do?token=%@&over=1&start=%ld&limit=5",mPrefixUrl,mDefineToken1,start];
        [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSString *userId = responseObject[@"userid"];
                weakSelf.userId = [userId integerValue];
                NSArray *arr = responseObject[@"result"];
                
                for (NSDictionary *dic in arr) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                    infoModel.over = weakSelf.over;//传入活动状态
                    [weakSelf.activiesArr addObject:mArr];
                }
                start = weakSelf.activiesArr.count;
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
    
}
//处于编辑状态的下侧view
-(void)setEditView{
    UIView *editView = [[UIView alloc]init];
    editView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editView];
    //    [self.view bringSubviewToFront:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(50*kiphone6);
    }];
    self.editView = editView;
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [editView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(1);
    }];
    //全选按钮
    YJHeaderTitleBtn *allSelectBtn = [[YJHeaderTitleBtn alloc]init];
    [editView addSubview:allSelectBtn];
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [allSelectBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"homeEquipment_unselected"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"homeEquipment_selected"] forState:UIControlStateSelected];
    [allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(editView);
    }];
    [allSelectBtn addTarget:self action:@selector(selectAllState:) forControlEvents:UIControlEventTouchUpInside];
    self.allSelectBtn = allSelectBtn;
    //删除按钮
    UIButton *deletSelectedBtn = [[UIButton alloc]init];
    [editView addSubview:deletSelectedBtn];
    [deletSelectedBtn setTitle:@"删除" forState:UIControlStateNormal];
    deletSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deletSelectedBtn setTitleColor:[UIColor colorWithHexString:@"#e00610"] forState:UIControlStateNormal];
    [deletSelectedBtn setBackgroundColor:[UIColor whiteColor]];
    [deletSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25*kiphone6);
        make.centerY.equalTo(editView);
    }];
    [deletSelectedBtn addTarget:self action:@selector(deletSelectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deletSelectedBtn = deletSelectedBtn;
    editView.hidden = YES;
}
#pragma mark ------------------btnClick------------------
//编辑状态
-(void)deletedBtnClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.isSelecting = YES;
        self.editView.hidden = NO;
        
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.isSelecting = NO;
        self.editView.hidden = YES;
        [self.selectBtnArr removeAllObjects];//移除存起来的用于删除时候查找id的btn，确保最后删除的是最新保存的选择按钮
    }
    [self.tableView reloadData];
}
//删除所选
-(void)deletSelectedBtnClick:(UIButton*)sender{
    UIButton *rightBtn = self.navigationItem.rightBarButtonItem.customView;
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    rightBtn.selected = !sender.selected;
    self.editView.hidden = YES;
    self.isSelecting = NO;
    //    删除所选状态
    NSString *ids = @"";
    for (int i = 0; i<self.selectBtnArr.count; i++) {
        YJHeaderTitleBtn *headerBtn = self.selectBtnArr[i];
        YJActivitiesDetailModel *model = self.activiesArr[i][0];
        if(headerBtn.selected){
            if (ids.length>0) {
                ids = [NSString stringWithFormat:@"%@,%ld",ids,model.info_id];
            }else{
                ids = [NSString stringWithFormat:@"%ld",model.info_id];
            }
        }
    }
    if (ids.length>0) {//有选中状态，需要删除
        http://localhost:8080/smarthome/mobileapi/activity/BatchDelete.do?ids=69,80&token=736F2C031E131CDF8993936169ADEE6C
        [SVProgressHUD show];// 动画开始
        NSString *deleUrlStr = [NSString stringWithFormat:@"%@ids=%@&token=%@",mDeleActivitys,ids,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:deleUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.activiesArr removeAllObjects];
                [self.selectBtnArr removeAllObjects];//保存选择按钮的集合也需要从新保存
                [self loadActivitysData];
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];// 动画结束
        }];
    }
    self.isAllSelected = NO;
    [self.tableView reloadData];
    
}
//全选/取消全选
-(void)selectAllState:(UIButton*)sender{
    sender.selected = !sender.selected;
    for (YJHeaderTitleBtn *selectBtn in self.selectBtnArr) {
        if (sender.selected) {
            selectBtn.selected = true;
            self.isAllSelected = true;
        }else{
            selectBtn.selected = false;
            self.isAllSelected = false;
        }
    }
}
//编辑状态下选择单个cell
-(void)selectThisState:(UIButton*)sender{
    sender.selected = !sender.selected;
}
#pragma mark - ------------------requestForData------------------

-(void)loadActivitysData{
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
            if (arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                    infoModel.over = self.over;//传入活动状态
                    [self.activiesArr addObject:mArr];
                }
                start = self.activiesArr.count;
                [self.tableView reloadData];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(deletedBtnClick:)];
            }
            
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
}

#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    // 2 .给tableview缓存行高属性赋值并计算
//    YJActivitiesDetailModel *comModel = self.statesArr[indexPath.section][0];// 2.1 找到这个cell对应的数据模型
//    NSString *thisId = [NSString stringWithFormat:@"%ld",comModel.info_id];// 2.2 取出模型对应id作为cell缓存行高对应key
//    CGFloat cacheHeight = [[self.cellHeightCache valueForKey:thisId] doubleValue];// 2.3 根据这个key取这个cell的高度
//    if (cacheHeight) {// 2.4 如果取得到就说明已经存过了，不需要再计算，直接返回这个高度
//        return cacheHeight;
//    }
//    YJCommunityActivitiesTVCell *commentCell = [tableView dequeueReusableCellWithIdentifier:tableCellid];// 2.4 如果没有取到值说明是第一遍，需要取一个cell(作为计算模型)并给cell的数据model赋值，进而计算出这个cell的高度
//    commentCell.model = comModel;// 2.5 赋值并在cell中计算
//    [self.cellHeightCache setValue:@(commentCell.cellHeight) forKey:thisId];// 2.6 取cell计算出的高度存入tableview的缓存行高字典里，方便读取
//    //            NSLog(@"%@",self.cellHeightCache);
//    return commentCell.cellHeight;
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSelecting) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        //    self.headerView = headerView;
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.offset(10*kiphone6);
        }];
        BOOL isHas = false;
        for (YJHeaderTitleBtn *selectBtn in self.selectBtnArr) {
            if (selectBtn.tag-50 == section) {
                [backView addSubview:selectBtn];
                [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10*kiphone6);
                    make.centerY.equalTo(backView);
                }];
                //                [selectBtn addTarget:self action:@selector(selectThisState:) forControlEvents:UIControlEventTouchUpInside];
                if (self.selectBtnArr.count>=self.activiesArr.count) {
                    isHas = true;
                }
            }
        }
        if (!isHas) {
            //全选按钮
            YJHeaderTitleBtn *selectBtn = [[YJHeaderTitleBtn alloc]init];
            [backView addSubview:selectBtn];
            selectBtn.tag = 50+section;//-50可以得到对应cell的序号
            [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
            selectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [selectBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"homeEquipment_unselected"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"homeEquipment_selected"] forState:UIControlStateSelected];
            [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10*kiphone6);
                make.centerY.equalTo(backView);
            }];
            [selectBtn addTarget:self action:@selector(selectThisState:) forControlEvents:UIControlEventTouchUpInside];
            if (self.selectBtnArr.count<self.activiesArr.count) {
                [self.selectBtnArr addObject:selectBtn];//用以批量删除时候获得按钮
            }
            if (self.isAllSelected) {//全选
                selectBtn.selected = YES;
            }else{//取消全选
                selectBtn.selected = NO;
            }
        }
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(1);
        }];
        
        return headerView;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSelecting) {
        return 40*kiphone6;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJActivitiesDetailsVC *detailVc = [[YJActivitiesDetailsVC alloc]init];
    YJCommunityActivitiesTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    detailVc.activityId = cell.model.info_id;
    detailVc.userId = self.userId;
    [self.navigationController pushViewController:detailVc animated:true];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.activiesArr.count;//根据请求回来的数据定
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *arr = self.activiesArr[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    YJCommunityActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.activiesArr[indexPath.section][0];
    return cell;
}
//- (void)action:(NSString *)actionStr{
//    NSLog(@"点什么点");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
