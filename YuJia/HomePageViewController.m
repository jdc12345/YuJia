//
//  HomePageViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "HomePageViewController.h"
#import "UIColor+Extension.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "EquipmentTableViewCell.h"
#import "SightSettingViewController.h"
#import "AddEquipmentViewController.h"
#import "AddSightViewController.h"
#import "EquipmentViewController.h"
#import "SightViewController.h"
#import "SightModel.h"
#import "EquipmentModel.h"
#import "RoomModel.h"
#import "LogInViewController.h"
#import "PopListTableViewController.h"
#import "AddSightViewController.h"
#import "AddRoomViewController.h"
#import "AddEquipmentViewController.h"



#define inputW 20 // 输入框宽度
#define inputH 50  // 输入框高度

@interface HomePageViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    JXPageView *pageView;
    JXSegment *segment;
    UIImageView *navBarHairlineImageView;
    UIImageView *tabBarHairlineImageView;
}

@property (nonatomic, strong) NSString *modelSetting;
@property (nonatomic, weak) UIView *sightView;
@property (nonatomic, weak) UIView *equipmentView;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray *roomDataSource;
@property (nonatomic, strong) NSMutableArray *sightDataSource;
@property (nonatomic, weak) SightViewController *sightVC;
@property (nonatomic, weak) EquipmentViewController *equipmentVC;


//////////////////////////////////////////////////////／
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

@implementation HomePageViewController
- (NSMutableArray *)roomDataSource{
    if (_roomDataSource == nil) {
        _roomDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _roomDataSource;
}
- (NSMutableArray *)sightDataSource{
    if (_sightDataSource == nil) {
        _sightDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _sightDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self httpRequestHomeInfo];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
    
    
    // Left item
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBtn.frame = CGRectMake(0, 16, 60, 12);
    [leftNavBtn setTitle:@"切换实景" forState:UIControlStateNormal];
    [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationController.navigationBar addSubview:leftNavBtn];
    
    
    // Right item
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(kScreenW -22 -10, 16, 12, 12);
    [rightNavBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [rightNavBtn addTarget:self action:@selector(addEquipment) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationController.navigationBar addSubview:rightNavBtn];
    
    // .TitleVeiw - Segmented Control
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"情景",@"设备",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake((kScreenW -150 -20)/2.0, 7,150, 30.0);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithHexString:@"00bfff"];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引、
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentedControl = segmentedControl;
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"666666"], NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"666666"] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    //    [self.navigationController.navigationBar addSubview:segmentedControl];
    
    [titleView addSubview:leftNavBtn];
    [titleView addSubview:rightNavBtn];
    [titleView addSubview:segmentedControl];
    
    self.navigationItem.titleView = titleView;
    //    titleView.backgroundColor = [UIColor yellowColor];
    NSLog(@"%g___________%g",self.navigationItem.titleView.frame.origin.x,self.navigationItem.titleView.frame.size.width);
    
    
    
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // 改变navBar 下面的线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    UILabel *coverView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    coverView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [navBarHairlineImageView removeFromSuperview];
    [navBarHairlineImageView addSubview:coverView];
    
    
    
    
    
    // Do any additional setup after loading the view.
}
/**
 * PS:navigation  下面的线
 */
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index)
    {
            //        case 0:
            //            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_apple_small.png")]];
            //            break;
            //        case 1:
            //            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_orange_small.png")]];
            //            break;
            //        case 2:
            //            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_banana_small.png")]];
            //            break;
            //        default:
            //            break;
    }
}
- (void)setupSlideBar {
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 40)];
    [segment updateChannels:@[@"首页",@"文章",@"好东西",@"早点与宵夜",@"电子小物",@"苹果",@"收纳集合",@"JBL",@"装b利器",@"测试机啦啦",@"乱七八糟的"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 104, kScreenW, self.view.bounds.size.height - 100)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
    [pageView changeToItemAtIndex:0];
    [self.view addSubview:pageView];
}
#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return 11;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[self randomColor]];
    
    ////////////////////////////
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreenW, kScreenH -148 -5) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [tableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:@"EquipmentTableViewCell"];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    ////////////////////////////
    return tableView;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [segment didChengeToIndex:index];
}


- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SightSettingViewController *sightVC = [[SightSettingViewController alloc]init];
        [self.navigationController pushViewController:sightVC animated:YES];
    }
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    // 图标  情景设置setting  灯light 电视tv 插座socket
    EquipmentTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentTableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        homeTableViewCell.titleLabel.text = @"情景设置";
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"setting"];
        [homeTableViewCell cellMode:NO];
    }else{
        homeTableViewCell.titleLabel.text = @"客厅灯";
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"light"];
        [homeTableViewCell cellMode:YES];
        
    }
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}
- (void)action:(NSString *)actionStr{
    NSLog(@"点什么点");
    [self.navigationController pushViewController:[[LogInViewController alloc]init] animated:YES];
}
- (void)segmentAction:(UISegmentedControl *)action{
    NSLog(@"  %ld",action.selectedSegmentIndex);
    if (action.selectedSegmentIndex == 0) {
        self.equipmentView.hidden = YES;
        self.sightView.hidden = NO;
    }else{
        self.sightView.hidden = YES;
        self.equipmentView.hidden = NO;
    }
}
- (void)addEquipment{
    NSLog(@"  %ld",self.segmentedControl.selectedSegmentIndex);
    //    。。。
    
    //    if (self.segmentedControl.selectedSegmentIndex == 0) {
    //        AddSightViewController *addSightVC  = [[AddSightViewController alloc]init];
    //        [self.navigationController pushViewController:addSightVC animated:YES];
    //    }else{
    //        AddEquipmentViewController *addEquipmentVC  = [[AddEquipmentViewController alloc]init];
    //        [self.navigationController pushViewController:addEquipmentVC animated:YES];
    //    }
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    if (_accountList == nil) {
        _accountList = [[PopListTableViewController alloc] init];
        // 设置弹出菜单的代理为当前这个类
        _accountList.delegate = self;
        // 数据
        self.selectStart = @[@"添加情景",@"添加房间",@"添加设备"];
        _accountList.accountSource = self.selectStart;
        _accountList.isOpen = NO;
        _accountList.isCenter = NO;
        _accountList.cellHigh = 30;
        // 边框
        _accountList.view.layer.cornerRadius = 2.5;
        _accountList.view.clipsToBounds = YES;
        _accountList.view.layer.borderWidth = 1.5;
        _accountList.view.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
        // 初始化frame
        [self updateListH];
        // 隐藏下拉菜单
        _accountList.view.frame = CGRectZero;
        // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
        [self addChildViewController:_accountList];
        [self.view addSubview:_accountList.view];
    }
    [self openAccountList];
}
/**
 *  监听代理更新下拉菜单                                 需要设置高度！！！！！！！！！！！！
 */
- (void)updateListH {
    CGFloat listH;
    // 数据大于3个现实3个半的高度，否则显示完整高度
    //    if (_dataSource.count > 3) {
    //        listH = inputH * 3.5;
    //    }else{
    //        listH = inputH * _dataSource.count;
    //    }
    _listFrame = CGRectMake(kScreenW -90, 64, 80, 90);
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
    
    //    NSString *title = self.selectStart[index];
    //    [_curAccount setTitle:title forState:UIControlStateNormal];
    //    _accountList.accountSource = self.selectStart;
    
    
    //    [_icon setImage:[UIImage imageNamed:@""]];
    
    switch (index) {
        case 0:
        {AddSightViewController *addSightVC  = [[AddSightViewController alloc]init];
            [self.navigationController pushViewController:addSightVC animated:YES];}
            break;
        case 1:
        {AddRoomViewController *addSightVC  = [[AddRoomViewController alloc]init];
            [self.navigationController pushViewController:addSightVC animated:YES];}
            break;
        case 2:
        {AddEquipmentViewController *addEquipmentVC  = [[AddEquipmentViewController alloc]init];
            [self.navigationController pushViewController:addEquipmentVC animated:YES];}
            break;
            
        default:
            break;
    }
    // 关闭菜单
    [self openAccountList];
}

- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mHomepageInfo,mDefineToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *roomList = responseObject[@"roomList"];
        NSArray *sceneList = responseObject[@"sceneList"];
        [self.roomDataSource removeAllObjects];
        [self.sightDataSource removeAllObjects];
        
        for (NSDictionary *roomDict in roomList) {
            RoomModel *roomModel = [RoomModel mj_objectWithKeyValues:roomDict];
            NSMutableArray *equipmentArray = [[NSMutableArray alloc]init];
            for (NSDictionary *equipmentDict in roomModel.equipmentList) {
                EquipmentModel *equipmentModel = [EquipmentModel mj_objectWithKeyValues:equipmentDict];
                [equipmentArray addObject:equipmentModel];
            }
            roomModel.equipmentList = equipmentArray;
            [self.roomDataSource addObject:roomModel];
            
        }
        //        NSLog(@"%@",self.roomDataSource.firstObject);
        
        
        for (NSDictionary *sceneDict in sceneList) {
            SightModel *sceneModel = [SightModel mj_objectWithKeyValues:sceneDict];
            NSMutableArray *equipmentArray = [[NSMutableArray alloc]init];
            for (NSDictionary *equipmentDict in sceneModel.equipmentList) {
                EquipmentModel *equipmentModel = [EquipmentModel mj_objectWithKeyValues:equipmentDict];
                [equipmentArray addObject:equipmentModel];
            }
            sceneModel.equipmentList = equipmentArray;
            [self.sightDataSource addObject:sceneModel];
            
        }
        if (!self.sightVC) {
            SightViewController *sightVC = [[SightViewController alloc]init];
            sightVC.dataSource = self.sightDataSource;
            sightVC.view.frame = CGRectMake(0, 64, kScreenW, kScreenH -64);
            
            self.sightView = sightVC.view;
            self.sightVC = sightVC;
            [self.view addSubview:sightVC.view];
            [self addChildViewController:sightVC];
            
            
            EquipmentViewController *equipmentVC = [[EquipmentViewController alloc]init];
            equipmentVC.dataSource = self.roomDataSource;
            equipmentVC.view.frame = CGRectMake(0, 64, kScreenW, kScreenH -64);
            equipmentVC.view.hidden = YES;
            self.equipmentVC = equipmentVC;
            self.equipmentView = equipmentVC.view;
            [self.view addSubview:equipmentVC.view];
            [self addChildViewController:equipmentVC];
        }else{
            if (self.roomDataSource.count >0) {
                [self.equipmentVC reloadData:self.roomDataSource];
            }
            if (self.sightDataSource.count >0) {
                [self.sightVC reloadData:self.sightDataSource];
            }
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [self httpRequestHomeInfo];
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
