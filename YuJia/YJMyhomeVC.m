//
//  YJMyhomeVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/21.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJMyhomeVC.h"
//#import "UIBarButtonItem+Helper.h"
#import "UIViewController+Cloudox.h"
//#import "YJHomeSceneFlowLayout.h"
#import "YJHomeSceneCollectionViewCell.h"
//#import "YJEquipmentrCollectionVCell.h"
#import "PopListTableViewController.h"
#import "ZYAlertSView.h"
#import "UILabel+Addition.h"
#import "YJAddScenePictureVC.h"
#import "YJEquipmentModel.h"
#import "YJAddEquipmentToCurruntSceneOrRoomVC.h"

#import "YJLightSettingVC.h"
#import "YJCurtainSettingVC.h"
#import "YJSocketSettingVC.h"

//#import "LightSettingViewController.h"
#import "AirConditioningViewController.h"
#import "TVSettingViewController.h"
#import "DoorLockViewController.h"

//#import "YYFunctionListFlowLayout.h"
#import "YYFunctionCollectionViewCell.h"
#import "NSArray+Addition.h"
#import "AllHomeModel.h"
#import "YJMyHomeColFlowLayout.h"

#define inputH 60  // 输入框高度
static NSString* collectionCellid = @"collection_cell";
static NSString *headerViewIdentifier =@"hederview";
//static NSString* eqCellid = @"eq_cell";

@interface YJMyhomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,AccountDelegate>
@property (nonatomic, weak) UICollectionView *funCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;//请求回来的家的数据
@property (nonatomic, strong) NSArray* functionListData;//功能列表

@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, assign) CGFloat leftPodding;

/**
 * 当前账号选择框
 */
@property (nonatomic, copy) UIButton *curAccount;
@property (nonatomic, weak) UIButton *openBtn;

/**
 * 当前账号头像
 */
@property (nonatomic, copy) UIImageView *icon;

/**
 *  账号下拉列表
 */
@property (nonatomic, strong) PopListTableViewController *accountList;

/**
 *  下拉列表的frame
 */
@property (nonatomic) CGRect listFrame;
@property (nonatomic, copy) NSArray *selectStart;

@end

@implementation YJMyhomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的家";
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    self.selectStart = @[@"定时启动",@"定位启动"];
    [self httpRequestHomeInfo];
    [self setUPUI];
}
- (void)setUPUI{
    self.functionListData = [self loadFunctionListData];
    //添加设备列表
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJMyHomeColFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
//    self.equipmentColView = collectionView;
    // 注册单元格
    [collectionView registerClass:[YYFunctionCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
//    [collectionView registerClass:[YJHomeSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    //注册头视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    self.funCollectionView = collectionView;
    [self.view addSubview:collectionView];
    
}
// 解析数据
- (NSArray*)loadFunctionListData
{
    return [NSArray objectListWithPlistName:@"YJMyHomeFunctionList.plist" clsName:@"YYPropertyFunctionList"];
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.functionListData.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YYFunctionCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.functionList = self.functionListData[indexPath.row];
    return cell;

}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
        YJEquipmentModel *equipmentModel;
        //        equipmentModel = self.sceneModel.equipmentList[indexPath.row];
//        equipmentModel = self.addedEquipmentListData[indexPath.row];
    
        NSLog(@"点击了第几个%ld",[equipmentModel.iconId integerValue]);
        switch ([equipmentModel.iconId integerValue]) {
            case 2:{
                YJLightSettingVC *sightVC = [[YJLightSettingVC alloc]init];
                //        sightVC.sightModel = self.dataSource[segment.selectedIndex];
                [self.navigationController pushViewController:sightVC animated:YES];
            }
                
                break;
            case 1:{
                YJSocketSettingVC *sightVC = [[YJSocketSettingVC alloc]init];
                //        sightVC.sightModel = self.dataSource[segment.selectedIndex];
                [self.navigationController pushViewController:sightVC animated:YES];
            }
                
                break;
            case 3:{
                TVSettingViewController *sightVC = [[TVSettingViewController alloc]init];
                //        sightVC.sightModel = self.dataSource[segment.selectedIndex];
                [self.navigationController pushViewController:sightVC animated:YES];
            }
                
                break;
            case 4:{
                YJCurtainSettingVC *sightVC = [[YJCurtainSettingVC alloc]init];
                //        sightVC.sightModel = self.dataSource[segment.selectedIndex];
                [self.navigationController pushViewController:sightVC animated:YES];
            }
                
                break;
            case 5:{
                AirConditioningViewController *sightVC = [[AirConditioningViewController alloc]init];
                //        sightVC.sightModel = self.dataSource[segment.selectedIndex];
                [self.navigationController pushViewController:sightVC animated:YES];
            }
                
                break;
            case 6:{
                DoorLockViewController *sightVC = [[DoorLockViewController alloc]init];
                //        sightVC.sightModel = self.dataSource[segment.selectedIndex];
                [self.navigationController pushViewController:sightVC animated:YES];
            }
                break;
                
            default:
                break;
        }
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        //添加头视图的内容
        UIView *headerView = [self personInfomation];
        [header addSubview:headerView];
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //
    //    }
    return nil;
}
//设置宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(kScreenW,70);
    
}
//collectionview的头部试图
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, inputH)];
    [headerView addSubview:_curAccount];
//    [_curAccount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(headerView);
//        make.left.right.equalTo(headerView);
//    }];
    [self setPopMenu];
    return headerView;
}
/**
 * 设置下拉菜单
 */
- (void)setPopMenu {
    
    // 1.1帐号选择框
    
    //    _curAccount.center = CGPointMake(self.view.center.x, 200);
    // 默认当前账号为已有账号的第一个
    //    Account *acc = _dataSource[0];
    [_curAccount setTitle:@"我创建的家" forState:UIControlStateNormal];
    
    _curAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _curAccount.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    // 字体
    [_curAccount setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _curAccount.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    // 边框
//    _curAccount.layer.cornerRadius = 2.5;
//    _curAccount.clipsToBounds = YES;
//    _curAccount.layer.borderWidth = 0.5;
//    _curAccount.layer.borderColor = [UIColor colorWithHexString:@"#e9e9e9"].CGColor;
//    // 显示框背景色
//    [_curAccount setBackgroundColor:[UIColor whiteColor]];
//    [_curAccount addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
//    //    [self.view addSubview:_curAccount];
//    // 1.2图标
//    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, inputH-10, inputH-10)];
//    _icon.layer.cornerRadius = (inputH-10)/2;
//    [_icon setImage:[UIImage imageNamed:@""]];
    //    [_curAccount addSubview:_icon];
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn = [[UIButton alloc]init];
    [openBtn setImage:[UIImage imageNamed:@"v"] forState:UIControlStateNormal];
    [openBtn setImage:[UIImage imageNamed:@"^"] forState:UIControlStateSelected];
    [openBtn addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [openBtn sizeToFit];
    [_curAccount addSubview:openBtn];
    self.openBtn = openBtn;
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_curAccount.mas_centerY).with.offset(0);
        make.right.offset(-20);
    }];
    
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList.delegate = self;
    // 数据
    _accountList.accountSource = self.selectStart;
    _accountList.isOpen = NO;
    _accountList.isCenter = YES;
    _accountList.cellHigh = 60;
    
    // 初始化frame
    [self updateListH];
    // 隐藏下拉菜单
    _accountList.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList];
    [self.view addSubview:_accountList.view];
}
/**
 *  监听代理更新下拉菜单                                 需要设置高度！！！！！！！！！！！！
 */
- (void)updateListH {
    CGFloat listH;
    // 数据大于3个现实3个半的高度，否则显示完整高度
    if (_dataSource.count > 3) {
        listH = inputH * 3.5;
    }else{
        listH = inputH * _dataSource.count;
    }
    _listFrame = CGRectMake(0, 50, kScreenW, listH);
    _accountList.view.frame = _listFrame;
}
/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList {
    NSLog(@"123123");
    [self.view bringSubviewToFront:_accountList.view];
    _accountList.isOpen = !_accountList.isOpen;
    self.openBtn.selected = _accountList.isOpen;
    if (_accountList.isOpen) {
        _accountList.view.frame = _listFrame;
    }
    else {
        _accountList.view.frame = CGRectZero;
    }
}
/**
 * 监听代理选定cell获取选中账号
 */
- (void)selectedCell:(NSInteger)index {
    // 更新当前选中账号
    //    Account *acc = _dataSource[index];
    
    NSString *title = self.selectStart[index];
    [_curAccount setTitle:title forState:UIControlStateNormal];
    _accountList.accountSource = self.selectStart;
    //    [_accountList reloadDataSource];
    //    if (index == 0) {
    //        [self back_click];
    //    }else{
    //        [self back_click_location];
    //    }
    
    
    [_icon setImage:[UIImage imageNamed:@""]];
    // 关闭菜单
    [self openAccountList];
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mAllHome,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *allHome = responseObject[@"mapList"];
        NSMutableArray *nameList = [[NSMutableArray alloc]initWithCapacity:2];
        for (NSDictionary *dict in allHome) {
            AllHomeModel *homeModel = [AllHomeModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:homeModel];//请求回来的家的数据
            [nameList addObject:homeModel.familyName];
        }
        
        self.selectStart = nameList;
//        _tableView.tableHeaderView = [self personInfomation];
        [self.funCollectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//懒加载家的列表
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
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
