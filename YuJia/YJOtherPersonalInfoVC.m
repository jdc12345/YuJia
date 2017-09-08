//
//  YJOtherPersonalInfoVC.m
//  YuJia
//
//  Created by 万宇 on 2017/9/6.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJOtherPersonalInfoVC.h"
#import "UIViewController+Cloudox.h"
#import "MMButton.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Addition.h"
#import "YJFriendStateTableViewCell.h"
#import "YJFriendStateDetailVC.h"
#import "YJCommunityActivitiesTVCell.h"
#import "YJActivitiesDetailsVC.h"
#import "YJActivitiesDetailModel.h"
#import <MJRefresh.h>
#import "YJPersonalModel.h"

#define limit 4
static NSInteger start = 0;
@interface YJOtherPersonalInfoVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, strong) UILabel *nameLabel;//名字

//@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIButton *iconView;//头像
@property (nonatomic, strong) UIImageView *genderV;
@property (nonatomic, strong) UIButton *editBtn;

//@property (nonatomic, weak) UIButton *rightNotBtn;
@property (nonatomic, strong) YJPersonalModel *personalModel;

@property (nonatomic, assign) BOOL isCircle;//是否处于圈子状态
//@property(nonatomic,assign)long userId;
@property(nonatomic,strong)NSMutableDictionary *cellHeightCache;// 1 .给tableview添加缓存行高属性(字典需要懒加载)
@property (nonatomic, strong) UIButton *circleBtn;//圈子按钮
@property (nonatomic, strong) UIButton *activityBtn;//活动按钮
@end

@implementation YJOtherPersonalInfoVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCircle = true;
    [self personInfomation];
    [self setupTabView];
}
//--------添加tableview----------
-(void)setupTabView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300*kiphone6, kScreenW, kScreenH-300*kiphone6) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[YJFriendStateTableViewCell class] forCellReuseIdentifier:@"YJFriendStateTableViewCell"];
    [_tableView registerClass:[YJCommunityActivitiesTVCell class] forCellReuseIdentifier:@"YJCommunityActivitiesTVCell"];
    [self.view addSubview:_tableView];

    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *urlStr;
        if (weakSelf.isCircle) {
            urlStr = [NSString stringWithFormat:@"%@tataId=%@&token=%@&start=0&limit=%d",mOtherStateInfo,weakSelf.info_id,mDefineToken,limit];
        }else{
            urlStr = [NSString stringWithFormat:@"%@tataId=%@&token=%@&start=0&limit=%d",mOtherActivityInfo,self.info_id,mDefineToken,limit];
        }
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject[@"total"]>0 ) {
                NSArray *arr = responseObject[@"rows"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    if (weakSelf.isCircle) {//他的圈子
                        YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }else{//他的活动
                        YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                }
                weakSelf.dataSource = mArr;
//                start = weakSelf.dataSource.count;
                start = limit;
                [weakSelf.tableView reloadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                weakSelf.dataSource = [NSMutableArray array];
                [weakSelf.tableView reloadData];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
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
                if (weakSelf.dataSource.count<limit) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                    return ;
                }
                NSString *urlStr;
                if (weakSelf.isCircle) {//他的圈子
                    urlStr = [NSString stringWithFormat:@"%@tataId=%@&token=%@&start=%ld&limit=%d",mOtherStateInfo,weakSelf.info_id,mDefineToken,start,limit];
                }else{//他的活动
                    urlStr = [NSString stringWithFormat:@"%@tataId=%@&token=%@&start=%ld&limit=%d",mOtherActivityInfo,self.info_id,mDefineToken,start,limit];
                }
                [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (responseObject[@"total"]>0 ) {
                        NSArray *arr = responseObject[@"rows"];
                        for (NSDictionary *dic in arr) {
                            if (weakSelf.isCircle) {//他的圈子
                                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                                [weakSelf.dataSource addObject:infoModel];
                            }else{//他的活动
                                YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                                [weakSelf.dataSource addObject:infoModel];
                            }
                        }
//                        start = weakSelf.dataSource.count;
                        start += limit;
                        [weakSelf.tableView reloadData];
                    }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                        weakSelf.dataSource = [NSMutableArray array];
                        [weakSelf.tableView reloadData];
                        [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                    }
                    [weakSelf.tableView.mj_footer endRefreshing];
    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                    [SVProgressHUD showErrorWithStatus:@"刷新失败"];
                    return ;
                }];
            }];

}
//-----请求个人信息------
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@tataId=%@&token=%@",mOtherInfo,self.info_id,mDefineToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *eDict = responseObject[@"Personal"];
        self.personalModel = [YJPersonalModel mj_objectWithKeyValues:eDict];
        self.nameLabel.text = self.personalModel.userName;
        if (self.personalModel.avatar.length>0) {
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"当前进度%ld",receivedSize/expectedSize);
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSLog(@"下载完成");
                if (image) {
                    [self.iconView setImage:image forState:UIControlStateNormal];
                }else{
                    [self.iconView setImage:[UIImage imageNamed:@"avatar.jpg"] forState:UIControlStateNormal];
                }
            }];
            
        }
        if ([self.personalModel.gender isEqualToString:@"1"]) {
            self.genderV.image = [UIImage imageNamed:@"man"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//添加头部视图
- (UIView *)personInfomation{
    //添加头部视图
    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 300*kiphone6)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.view addSubview:headerView];
    //添加背景视图
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200*kiphone6)];
    backView.userInteractionEnabled = true;
    [headerView addSubview:backView];
    UIImage *oldImage = [UIImage imageNamed:@"personal_back_photo"];
    backView.image = oldImage;
    //添加头像
    UIButton *iconView = [[UIButton alloc]init];
    UIImage *iconImage = [UIImage imageNamed:@"avatar.jpg"];
    //    iconView.image = iconImage;
    [iconView setImage:iconImage forState:UIControlStateNormal];
    [backView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.offset(50*kiphone6);
        make.width.height.offset(75*kiphone6);
    }];
    iconView.layer.cornerRadius=37.5*kiphone6;//裁成圆角
    iconView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
//    [iconView addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    //    iconView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    //    iconView.layer.borderWidth = 1.5f;
    //添加名字
    UILabel *namelabel = [UILabel labelWithText:self.personalModel.userName andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
    [backView addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView);
        make.top.equalTo(iconView.mas_bottom).offset(10*kiphone6);
    }];
    
    self.nameLabel = namelabel;
    //    self.idLabel = idName;
    self.iconView = iconView;
    //添加性别标识
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"woman"];
    [imageV sizeToFit];
    [headerView addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(namelabel);
        make.left.equalTo(namelabel.mas_right).offset(5*kiphone6);
    }];
    self.genderV = imageV;
    
    NSArray *nameList = @[@"我的圈子",@"我的活动"];
    NSArray *iconList = @[@"mycircle",@"myactivities"];
    
    CGFloat btnW = kScreenW/2.0;
    for (int i = 0 ; i<2 ;  i++) {
        MMButton *leftNavBtn = [MMButton buttonWithType:UIButtonTypeCustom];
        leftNavBtn.frame = CGRectMake(i *btnW, 200*kiphone6, btnW, 99*kiphone6);
        leftNavBtn.tag = 80 +i;
        if (i==0) {
            leftNavBtn.backgroundColor = [UIColor colorWithHexString:@"#fbfbfb"];
            self.circleBtn = leftNavBtn;
        }else{
            leftNavBtn.backgroundColor = [UIColor whiteColor];
            self.activityBtn = leftNavBtn;
        }
        [leftNavBtn setTitle:nameList[i] forState:UIControlStateNormal];
        [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"#6a6a6a"] forState:UIControlStateNormal];
        [leftNavBtn setImage:[UIImage imageNamed:iconList[i]] forState:UIControlStateNormal];
        leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [leftNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:leftNavBtn];
        headerView.userInteractionEnabled = YES;
    }
    return headerView;
}
#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isCircle) {//他的圈子
        YJFriendStateDetailVC *detailVc = [[YJFriendStateDetailVC alloc]init];
        YJFriendStateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        detailVc.userId = [self.info_id integerValue];
        detailVc.stateId = cell.model.info_id;
        [self.navigationController pushViewController:detailVc animated:true];
    }else{//他的状态
        YJActivitiesDetailsVC *detailVc = [[YJActivitiesDetailsVC alloc]init];
        YJCommunityActivitiesTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        detailVc.activityId = cell.model.info_id;
        detailVc.userId = [self.info_id integerValue];
        [self.navigationController pushViewController:detailVc animated:true];

    }
   
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
    if (self.isCircle) {//处于圈子列表状态
        // 2 .给tableview缓存行高属性赋值并计算
        YJFriendNeighborStateModel *comModel = self.dataSource[indexPath.row];// 2.1 找到这个cell对应的数据模型
        NSString *thisId = [NSString stringWithFormat:@"%@",comModel.info_id];// 2.2 取出模型对应id作为cell缓存行高对应key
        CGFloat cacheHeight = [[self.cellHeightCache valueForKey:thisId] doubleValue];// 2.3 根据这个key取这个cell的高度
        if (cacheHeight) {// 2.4 如果取得到就说明已经存过了，不需要再计算，直接返回这个高度
            return cacheHeight;
        }
        YJFriendStateTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"YJFriendStateTableViewCell"];// 2.4 如果没有取到值说明是第一遍，需要取一个cell(作为计算模型)并给cell的数据model赋值，进而计算出这个cell的高度
        commentCell.model = comModel;// 2.5 赋值并在cell中计算
        [self.cellHeightCache setValue:@(commentCell.cellHeight) forKey:thisId];// 2.6 取cell计算出的高度存入tableview的缓存行高字典里，方便读取
        //            NSLog(@"%@",self.cellHeightCache);
        return commentCell.cellHeight;
    }else{//处于活动列表状态
        return 235*kiphone6;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
//    headerView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//    
//    return headerView;
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCircle) {//处于圈子列表状态
        YJFriendStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJFriendStateTableViewCell" forIndexPath:indexPath];
        [cell.urlStrs removeAllObjects];//解决cell复用时候图片数组没有清空造成的图片放大显示错误问题
        cell.model = self.dataSource[indexPath.row];
        WS(ws);
        cell.commentBtnBlock = ^(YJFriendNeighborStateModel *model){
            YJFriendStateDetailVC *detailVc = [[YJFriendStateDetailVC alloc]init];
            detailVc.commentField.hidden = false;
            detailVc.userId = [ws.info_id integerValue];
            detailVc.stateId = model.info_id;
            [ws.navigationController pushViewController:detailVc animated:true];
        };
        cell.iconViewTapgestureBlock = ^(YJFriendNeighborStateModel *model) {
            YJOtherPersonalInfoVC *detailVc = [[YJOtherPersonalInfoVC alloc]init];
            detailVc.info_id = [NSString stringWithFormat:@"%ld",model.personalId];
            [ws.navigationController pushViewController:detailVc animated:true];
        };

        return cell;
    }else{//处于活动列表状态
        YJCommunityActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJCommunityActivitiesTVCell" forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
}
//- (void)editPersonal{
//    EditPersonalViewController *editVC = [[EditPersonalViewController alloc]init];
//    editVC.personalModel = self.personalModel;
//    [self.navigationController pushViewController:editVC animated:YES];
//}
//按钮点击事件 fb
- (void)action:(UIButton *)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#fbfbfb"];
    switch (sender.tag -80) {
        case 0:
            self.activityBtn.backgroundColor = [UIColor whiteColor];
            self.isCircle = true;
            [self requestForState];
            break;
        case 1:
            self.circleBtn.backgroundColor = [UIColor whiteColor];
            self.isCircle = false;
            [self requestForActivity];
            break;
        default:
            break;
    }
}
////设置个人信息页面
//- (void)pushSettingVC{
//    EditPersonalViewController *eVC = [[EditPersonalViewController alloc]init];
//    eVC.personalModel = self.personalModel;
//    [self.navigationController pushViewController:eVC animated:YES];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBarBgAlpha = @"0.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
    self.navigationController.navigationBar.translucent = true;
    [self httpRequestHomeInfo];
    if (self.isCircle) {//他的圈子
        [self requestForState];
    }else{//他的活动
        [self requestForActivity];
    }
    
}
//-----请求状态数据--------
-(void)requestForState{
    [SVProgressHUD show];// 动画开始
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@tataId=%@&token=%@&start=0&limit=%d",mOtherStateInfo,self.info_id,mDefineToken,limit];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];// 动画结束
        if (responseObject[@"total"]>0 ) {
            
            //            self.personal = dic[@"personalEntity"];//个人信息
            NSArray *arr = responseObject[@"rows"];//朋友圈状态
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJFriendNeighborStateModel *infoModel = [YJFriendNeighborStateModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.dataSource = mArr;
//            start = self.dataSource.count;
            start = limit;
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
//-----请求活动数据--------
-(void)requestForActivity{
    [SVProgressHUD show];// 动画开始
    NSString *activityUrlStr = [NSString stringWithFormat:@"%@tataId=%@&token=%@&start=0&limit=%d",mOtherActivityInfo,self.info_id,mDefineToken,limit];
    [[HttpClient defaultClient]requestWithPath:activityUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];// 动画结束
        if (responseObject[@"total"]>0 ) {
            NSArray *arr = responseObject[@"rows"];//活动详情
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJActivitiesDetailModel *infoModel = [YJActivitiesDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.dataSource = mArr;
//            start = self.dataSource.count;
            start = limit;
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

-(UIStatusBarStyle)preferredStatusBarStyle{//如果有导航栏必须在导航栏重写- (UIViewController *)childViewControllerForStatusBarStyle{
    //    return self.topViewController;
    //}
    return UIStatusBarStyleLightContent;
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
