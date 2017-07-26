//
//  YJHomePageVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomePageVC.h"
#import "UIViewController+Cloudox.h"
#import "NSArray+Addition.h"
#import "UILabel+Addition.h"
#import "YJHomeSceneFlowLayout.h"
#import "YJHomeSceneCollectionViewCell.h"

//static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
@interface YJHomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,weak)UICollectionView *colllectionView;
@property(nonatomic,weak)UIButton *mysceneBtn;
@property(nonatomic,weak)UIButton *equipmentBtn;
@property(nonatomic,strong)NSArray *imagesURLStrings;
@property (nonatomic, strong) NSArray* functionListData;//功能列表
@property(nonatomic,weak)UIView *clearView;

@end

@implementation YJHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imageBg];
    [self loadFunctionListData];
    [self setUpUI];
}
- (void)imageBg//把控制器背景设为图片
{
    UIImage *oldImage = [UIImage imageNamed:@"home_back"];
    
    UIGraphicsBeginImageContextWithOptions((CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-self.tabBarController.tabBar.bounds.size.height)), NO, 0.0);
    [oldImage drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tabBarController.tabBar.bounds.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}
-(UIStatusBarStyle)preferredStatusBarStyle{//如果有导航栏必须在导航栏重写- (UIViewController *)childViewControllerForStatusBarStyle{
    //    return self.topViewController;
    //}
    return UIStatusBarStyleLightContent;
}
- (void)setUpUI {
    UIButton *editBtn = [[UIButton alloc]init];//编辑按钮
    [self setBtn:editBtn WithTitle:@"编辑" font:13 titleColor:@"#333333"];
    editBtn.backgroundColor = [UIColor whiteColor];
    editBtn.layer.cornerRadius = 12;
    editBtn.layer.masksToBounds = true;
    [self.view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_top).offset(42*kiphone6);
        make.right.offset(-15*kiphone6);
        make.width.offset(60*kiphone6);
        make.height.offset(25*kiphone6);
    }];
    UIButton *mySceneBtn = [[UIButton alloc]init];;//我的情景
    mySceneBtn.tag = 31;
    self.mysceneBtn = mySceneBtn;
    [self setBtn:mySceneBtn WithTitle:@"我的情景" font:24 titleColor:@"#ffffff"];
    [self.view addSubview:mySceneBtn];
    [mySceneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(74*kiphone6);
        make.left.offset(15*kiphone6);
    }];
    UILabel *septemperLabel = [UILabel labelWithText:@"/" andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:20];
    [self.view addSubview:septemperLabel];
    [septemperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(120);
        make.top.offset(84*kiphone6);
    }];
    UIButton *equipmentBtn = [[UIButton alloc]init];;//我的设备
    equipmentBtn.tag = 32;
    self.equipmentBtn = equipmentBtn;
    [self setBtn:equipmentBtn WithTitle:@"我的设备" font:16 titleColor:@"#ffffff"];
    [self.view addSubview:equipmentBtn];
    [equipmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(septemperLabel.mas_right).offset(10);
        make.bottom.equalTo(mySceneBtn);
    }];
    [mySceneBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [equipmentBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *noticeLabel = [UILabel labelWithText:@"添加我的常用情景，创建我的智能家庭" andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:13];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kiphone6);
        make.top.equalTo(mySceneBtn.mas_bottom).offset(25*kiphone6);
    }];
    UIButton *addBtn = [[UIButton alloc]init];
    [self setBtn:addBtn WithTitle:@"添加" font:13 titleColor:@"#333333"];
    addBtn.backgroundColor = [UIColor whiteColor];
    addBtn.layer.cornerRadius = 12;
    addBtn.layer.masksToBounds = true;
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kiphone6);
        make.top.equalTo(noticeLabel.mas_bottom).offset(10*kiphone6);
        make.width.offset(60*kiphone6);
        make.height.offset(25*kiphone6);
    }];
    //添加中间透明view，用于滑动情景view
    UIView *clearView = [[UIView alloc]init];
    clearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearView];
    [clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(addBtn.mas_bottom);
        make.height.offset(165*kiphone6);
    }];
    self.clearView = clearView;
    // 用来接收数据 方便设置数据源
    self.functionListData = [self loadFunctionListData];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJHomeSceneFlowLayout alloc]init]];
//    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 218*kiphone6, kScreenW, kScreenH-self.tabBarController.tabBar.bounds.size.height-218*kiphone6) collectionViewLayout:[[YJHomeSceneFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-self.tabBarController.tabBar.bounds.size.height);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册单元格
    [collectionView registerClass:[YJHomeSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    //添加滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
#pragma UIgestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
//设置手势
-(void)panGesture:(UIPanGestureRecognizer*)sender{
    //
    //    if ([self.shopDetailView isTracking]) {
    //        return;
    //    }
    //
    CGPoint p = [sender translationInView:sender.view];
    //手势要归零
    [sender setTranslation:CGPointZero inView:sender.view];
    //用绝对值把左右滑动情况排除
    if (ABS(p.x)>ABS(p.y)) {
        return;
    }
    //
    [self.clearView mas_updateConstraints:^(MASConstraintMaker *make) {
        //设置高度的下限
        if ((self.clearView.bounds.size.height+p.y)<25*kiphone6) {
            make.height.offset(25*kiphone6);
            return ;
        }
        //设置高度的上限
        if ((self.clearView.bounds.size.height+p.y)>165*kiphone6) {
            make.height.offset(165*kiphone6);
            return;
        }
        make.height.offset(self.clearView.bounds.size.height + p.y);
    }];
    //
    [self.view layoutIfNeeded];
}
-(void)setBtn:(UIButton*)btn WithTitle:(NSString*)title font:(CGFloat)font titleColor:(NSString*)color{
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
}
//我的情景和我的设备按钮切换
- (void)selectedBtn:(UIButton*)sender{
    sender.titleLabel.font = [UIFont systemFontOfSize:24];
    [sender mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*kiphone6);
        make.top.offset(74*kiphone6);
    }];
    if (sender.tag == 31) {
        [self.equipmentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mysceneBtn.mas_right).offset(18);
            make.bottom.equalTo(self.mysceneBtn);
        }];
        self.equipmentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //加载我的情景数据
        
        
    }else{
        [self.mysceneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.equipmentBtn.mas_right).offset(18);
            make.bottom.equalTo(self.equipmentBtn);
        }];
        self.mysceneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //加载我的设备数据
    }
}
// 解析数据
- (NSArray*)loadFunctionListData
{
    return [NSArray objectListWithPlistName:@"YJHomeSceneList.plist" clsName:@"YYPropertyFunctionList"];
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
    YJHomeSceneCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.functionList = self.functionListData[indexPath.row];
    cell.selected = false;
    return cell;
}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
//    switch (indexPath.row) {
//        case 0:{
//            YJPropertyBillVC *vc = [[YJPropertyBillVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 1:{
//            YJLifepaymentVC *vc = [[YJLifepaymentVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 2:{
//            YJReportRepairVC *vc = [[YJReportRepairVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 3:{
//            YJExpressDeliveryVC *vc = [[YJExpressDeliveryVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 4:{
//            YJNearbyShopViewController *vc = [[YJNearbyShopViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 5:{
//            YJRenovationViewController *vc = [[YJRenovationViewController alloc] init];
//            vc.title = @"家政服务";
//            vc.businessId = 11;
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 6:{
//            YJHouseSearchListVC *vc = [[YJHouseSearchListVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 7:{
//            YJRenovationViewController *vc = [[YJRenovationViewController alloc] init];
//            vc.title = @"装修服务";
//            vc.businessId = 12;
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//            
//            break;
    
//        default:
//            break;
//    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBarBgAlpha = @"0.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
    self.navigationController.navigationBar.translucent = true;
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
