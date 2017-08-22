//
//  YJHomePageVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomePageVC.h"
#import "UIViewController+Cloudox.h"
//#import "NSArray+Addition.h"
#import "UILabel+Addition.h"
#import "YJHomeSceneFlowLayout.h"
#import "YJHomeSceneCollectionViewCell.h"
#import "YJEquipmentrCollectionVCell.h"
#import "YJHeaderTitleBtn.h"
#import "YJHomepageTVCell.h"
#import "YJRoomSetUpVC.h"
#import "YJSceneSetVC.h"
#import "YJAddEquipmentVC.h"
#import "YJSceneDetailModel.h"
#import "YJRoomDetailModel.h"
#import "YJEquipmentModel.h"
#import <SDWebImageManager.h>

static NSString* eqCellid = @"eq_cell";
static NSString* collectionCellid = @"collection_cell";
static NSString *headerViewIdentifier =@"hederview";
static NSString* tableCellid = @"table_cell";
@interface YJHomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UICollectionView *mysceneColView;//情景collectionView
@property(nonatomic,weak)UICollectionView *equipmentColView;//设备collectionView
@property(nonatomic,weak)UIButton *mysceneBtn;
@property(nonatomic,weak)UIButton *equipmentBtn;
@property(nonatomic,strong)NSArray *imagesURLStrings;
@property (nonatomic, strong) NSMutableArray* mysceneListData;//情景列表
@property (nonatomic, strong) NSMutableArray* equipmentListData;//当前房间设备列表
@property(nonatomic,weak)UIView *clearView;//添加和collectionview之间的透明view
@property(nonatomic,assign)BOOL isMyscene;//判断是否处于我的情景页面,点击编辑按钮时候需要用到
@property(nonatomic,weak)UIView *backGrayView;//半透明背景
@property(nonatomic,weak)UITableView *sceneTableView;//情景tableView
@property(nonatomic,weak)UITableView *roomTableView;//房间tableView
@property(nonatomic,weak)UIView *closeView;//底部取消view
@property (nonatomic, strong) NSMutableArray* roomListData;//房间列表
@property(nonatomic,weak)YJHeaderTitleBtn *roomBtn;//显示当前房间的btn
@property (nonatomic, strong) YJRoomDetailModel* curruntRoomModel;//当前房间数据模型

@end

@implementation YJHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
    [self setUpUI];
}
//请求情景房间数据
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mHomepageInfo,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *roomList = responseObject[@"roomList"];
        NSArray *sceneList = responseObject[@"sceneList"];
//        [self.roomDataSource removeAllObjects];
//        [self.sightDataSource removeAllObjects];
//
        for (NSDictionary *sceneDict in sceneList) {
            YJSceneDetailModel *sceneModel = [YJSceneDetailModel mj_objectWithKeyValues:sceneDict];
            NSMutableArray *equipmentArray = [[NSMutableArray alloc]init];
            for (NSDictionary *equipmentDict in sceneModel.equipmentList) {
                YJEquipmentModel *equipmentModel = [YJEquipmentModel mj_objectWithKeyValues:equipmentDict];
                [equipmentArray addObject:equipmentModel];
            }
            sceneModel.equipmentList = equipmentArray;
            [self.mysceneListData addObject:sceneModel];
        }
        [self.mysceneColView reloadData];//刷新情景开关列表
        if (self.sceneTableView) {
            [self.sceneTableView reloadData];//刷新情景名字列表
        }
        for (NSDictionary *roomDict in roomList) {
            YJRoomDetailModel *roomModel = [YJRoomDetailModel mj_objectWithKeyValues:roomDict];
            NSMutableArray *equipmentArray = [[NSMutableArray alloc]init];
            for (NSDictionary *equipmentDict in roomModel.equipmentList) {
                YJEquipmentModel *equipmentModel = [YJEquipmentModel mj_objectWithKeyValues:equipmentDict];
                [equipmentArray addObject:equipmentModel];
            }
            roomModel.equipmentList = equipmentArray;
            if ([roomModel.info_id isEqualToString:self.curruntRoomModel.info_id]) {//如果修改了当前房间要更换当前房间数据源
                self.curruntRoomModel = roomModel;
            }
            [self.roomListData addObject:roomModel];
        }
        if (!self.isMyscene) {//进入页面时候当前页面处于房间页面时候需要根据当前房间更换房间背景
            if (self.curruntRoomModel.pictures.length>0) {//把控制器背景设为当前房间背景图片
                if ([self.curruntRoomModel.pictures isEqualToString:@"1"]) {
                    [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
                }else if ([self.curruntRoomModel.pictures isEqualToString:@"2"]){
                    [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[1]]];
                }else{
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.curruntRoomModel.pictures];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        NSLog(@"当前进度%ld",receivedSize/expectedSize);
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        NSLog(@"下载完成");
                        if (image) {
                            [self setBackGroundColorWithImage:image];
                        }else{
                            [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
                        }
                    }];
                }
            }else{
                [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
            }
        }
        if (self.roomListData.count>0&&!self.curruntRoomModel) {//第一次请求数据
            self.curruntRoomModel = self.roomListData[0];
        }
        if (self.roomBtn) {
            [self.roomBtn setTitle:self.curruntRoomModel.roomName forState:UIControlStateNormal];//给房间切换按钮赋值
            [self.roomTableView reloadData];//刷新房间列表
        }
        self.equipmentListData = [NSMutableArray arrayWithArray:self.curruntRoomModel.equipmentList];//当前房间设备列表
        [self.equipmentColView reloadData];//刷新当前房间设备列表
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//把控制器背景设为图片
- (void)setBackGroundColorWithImage:(UIImage *)image
{
    UIImage *oldImage = image;
    
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
    UIView *backGrayView = [[UIView alloc]init];//添加模糊视图
    backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    backGrayView.alpha = 0.5;
    [self.view addSubview:backGrayView];
    [backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    backGrayView.userInteractionEnabled = YES;
    NSMutableArray* rightItemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    [rightItemArr addObject:negativeSpacer];//修正按钮离屏幕边缘位置的UIBarButtonItem应在按钮的前边加入数组
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60*kiphone6, 25*kiphone6)];//编辑按钮
    [self setBtn:editBtn WithTitle:@"编辑" font:13 titleColor:@"#333333"];
    editBtn.backgroundColor = [UIColor whiteColor];
    editBtn.layer.cornerRadius = 12;
    editBtn.layer.masksToBounds = true;
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.isMyscene = true;//开始是在情景页面
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [rightItemArr addObject:rightBarItem];
    self.navigationItem.rightBarButtonItems = rightItemArr;//导航栏右侧按钮
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
    UILabel *noticeLabel = [UILabel labelWithText:@"添加我的常用设备，创建我的智能家庭" andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:13];
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
    [addBtn addTarget:self action:@selector(addEquipmentBtn) forControlEvents:UIControlEventTouchUpInside];
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
    // 用来接收情景数据 方便设置数据源
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJHomeSceneFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-self.tabBarController.tabBar.bounds.size.height);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.mysceneColView = collectionView;
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
        if ((self.clearView.bounds.size.height+p.y)<30*kiphone6) {
            make.height.offset(30*kiphone6);
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
        [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];//把控制器背景设为情景背景图片
        self.isMyscene = true;
        [self.equipmentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mysceneBtn.mas_right).offset(18);
            make.bottom.equalTo(self.mysceneBtn);
        }];
        self.equipmentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //加载我的情景数据
        self.equipmentColView.hidden = true;
        self.mysceneColView.hidden = false;
        [self.mysceneColView reloadData];
        
    }else{
        if (self.curruntRoomModel.pictures.length>0) {//把控制器背景设为当前房间背景图片
            if ([self.curruntRoomModel.pictures isEqualToString:@"1"]) {
                [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
            }else if ([self.curruntRoomModel.pictures isEqualToString:@"2"]){
                [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[1]]];
            }else{
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.curruntRoomModel.pictures];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    NSLog(@"当前进度%ld",receivedSize/expectedSize);
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    NSLog(@"下载完成");
                    if (image) {
                        [self setBackGroundColorWithImage:image];
                    }else{
                        [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
                    }
                }];
            }
        }else{
            [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
        }
        self.isMyscene = false;
        [self.mysceneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.equipmentBtn.mas_right).offset(18);
            make.bottom.equalTo(self.equipmentBtn);
        }];
        self.mysceneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //加载我的设备数据
        self.mysceneColView.hidden = true;
        if (self.equipmentColView) {
            self.equipmentColView.hidden = false;
            [self.equipmentColView reloadData];
        }else{
            // 用来接收设备数据 方便设置数据源
//            self.equipmentListData = [NSArray objectListWithPlistName:@"YJEquipmentList.plist" clsName:@"YJEquipmentListModel"];
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJHomeSceneFlowLayout alloc]init]];
            collectionView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:collectionView];
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.clearView.mas_bottom).offset(-30*kiphone6);
                make.left.right.offset(0);
                make.bottom.offset(-self.tabBarController.tabBar.bounds.size.height);
            }];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            self.equipmentColView = collectionView;
            // 注册单元格
            [collectionView registerClass:[YJEquipmentrCollectionVCell class] forCellWithReuseIdentifier:eqCellid];
            //注册头视图
            [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
            collectionView.showsHorizontalScrollIndicator = false;
            collectionView.showsVerticalScrollIndicator = false;
        }
    }
}
//添加设备按钮点击事件
-(void)addEquipmentBtn{
    YJAddEquipmentVC *addVc = [[YJAddEquipmentVC alloc]init];
    [self.navigationController pushViewController:addVc animated:true];
}
//// 解析数据
//- (NSArray*)loadFunctionListData
//{
//    return [NSArray objectListWithPlistName:@"YJHomeSceneList.plist" clsName:@"YYPropertyFunctionList"];
//}
//编辑按钮点击事件
- (void)editBtnClick:(UIButton*)sender{
    if (self.isMyscene) {//处于我的情景页面
        //大蒙布View
        if (!self.backGrayView) {
            [self addGrayView];
        }else{
            self.backGrayView.hidden = false;
            self.closeView.hidden = false;
        }
        //大蒙布View
        if (!self.sceneTableView) {
            //处于我的情景页面
            //情景选择tableView，cell+组尾视图+底部取消view
            //添加tableView
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
            tableView.backgroundColor = [UIColor clearColor];
            self.sceneTableView = tableView;
            [self.view.window addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10*kiphone6);
                make.right.offset(-10*kiphone6);
                make.height.offset(240*kiphone6);
                make.bottom.equalTo(self.closeView.mas_top);
            }];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[YJHomepageTVCell class] forCellReuseIdentifier:tableCellid];
            tableView.delegate =self;
            tableView.dataSource = self;
            tableView.layer.cornerRadius = 5;
            tableView.layer.masksToBounds = true;
            tableView.bounces = false;
        }else{
            self.sceneTableView.hidden = false;
            }
    }else{//处于我的设备页面
        YJRoomSetUpVC *setVC = [[YJRoomSetUpVC alloc]init];
//        setVC.roomName = self.roomBtn.titleLabel.text;
        setVC.roomModel = self.curruntRoomModel;
        [self.navigationController pushViewController:setVC animated:true];
    }
}
//切换添加房屋
-(void)roomBtnClick{
    //大蒙布View
    if (!self.backGrayView) {
        [self addGrayView];
    }else{
        self.backGrayView.hidden = false;
        self.closeView.hidden = false;
        }
    if (!self.roomTableView) {
        //情景选择tableView，cell+组尾视图+底部取消view
        //添加tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        self.roomTableView = tableView;
        [self.view.window addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10*kiphone6);
            make.right.offset(-10*kiphone6);
            make.height.offset(240*kiphone6);
            make.bottom.equalTo(self.closeView.mas_top);
        }];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[YJHomepageTVCell class] forCellReuseIdentifier:tableCellid];
        tableView.delegate =self;
        tableView.dataSource = self;
        tableView.layer.cornerRadius = 5;
        tableView.layer.masksToBounds = true;
        tableView.bounces = false;
    }else{
        self.roomTableView.hidden = false;
    }
}
-(void)addGrayView{
    UIView *backGrayView = [[UIView alloc]init];
    self.backGrayView = backGrayView;
    backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    backGrayView.alpha = 0.3;
    [self.view.window addSubview:backGrayView];
    [backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    backGrayView.userInteractionEnabled = YES;
    //添加tap手势：
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    //将手势添加至需要相应的view中
    [backGrayView addGestureRecognizer:tapGesture];
    //取消view
    UIView *closeView = [[UIView alloc]init];
    closeView.backgroundColor = [UIColor clearColor];
    [self.view.window addSubview:closeView];
    self.closeView = closeView;
    [closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(80*kiphone6);
        make.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.bottom.offset(0);
    }];
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setBackgroundColor:[UIColor whiteColor]];
    [self setBtn:closeBtn WithTitle:@"取消" font:18 titleColor:@"#999999"];
    closeBtn.layer.cornerRadius = 5;
    closeBtn.layer.masksToBounds = true;
    [closeView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(60*kiphone6);
        make.centerY.offset(0);
    }];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    [self closeBtnClick];
}
- (void)closeBtnClick{
    self.backGrayView.hidden = true;
    self.sceneTableView.hidden = true;
    self.closeView.hidden = true;
    self.roomTableView.hidden = true;
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.sceneTableView) {
        return self.mysceneListData.count;
    }else{
        return self.roomListData.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJHomepageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    if (tableView==self.sceneTableView) {
        cell.sceneDetailModel = self.mysceneListData[indexPath.row];
    }else{
       cell.roomDetailModel = self.roomListData[indexPath.row];
    }
  return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45*kiphone6)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    if (tableView==self.sceneTableView) {
        [self setBtn:addBtn WithTitle:@"添加新情景" font:18 titleColor:@"#0ddcbc"];
    }else{
        [self setBtn:addBtn WithTitle:@"添加新房间" font:18 titleColor:@"#0ddcbc"];
    }
    [view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [addBtn addTarget:self action:@selector(addSceneOrNewHouseClick) forControlEvents:UIControlEventTouchUpInside];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60*kiphone6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    YJHomepageTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView==self.sceneTableView) {
        //跳转情景设置页面
        YJSceneSetVC *vc = [[YJSceneSetVC alloc]init];
//        SightSettingViewController *vc = [[SightSettingViewController alloc]init];
//        vc.sceneName = cell.itemLabel.text;
//        vc.equipmentListData = self.equipmentListData;
        YJSceneDetailModel *sceneModel = self.mysceneListData[indexPath.row];
        vc.sceneModel = sceneModel;//当前选中情景模型数据
        [self.navigationController pushViewController:vc animated:true];
    }else{
        self.curruntRoomModel = cell.roomDetailModel;//更换当前房间
        if (self.curruntRoomModel.pictures.length>0) {//把控制器背景设为当前房间背景图片
            if ([self.curruntRoomModel.pictures isEqualToString:@"1"]) {
                [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
            }else if ([self.curruntRoomModel.pictures isEqualToString:@"2"]){
                [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[1]]];
            }else{
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.curruntRoomModel.pictures];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    NSLog(@"当前进度%ld",receivedSize/expectedSize);
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    NSLog(@"下载完成");
                    if (image) {
                        [self setBackGroundColorWithImage:image];
                    }else{
                        [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
                    }
                }];
            }
        }else{
            [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
        }
        self.equipmentListData = [NSMutableArray arrayWithArray:cell.roomDetailModel.equipmentList];
        [self.equipmentColView reloadData];//更换不同房间的设备数据源
//        [self.roomBtn setTitle:cell.roomDetailModel.roomName forState:UIControlStateNormal];//更换切换房间按钮名字
    }
    [self closeBtnClick];//隐藏房间列表
}
-(void)addSceneOrNewHouseClick{
    if (self.isMyscene) {
        //跳转情景设置页面
        YJSceneSetVC *vc = [[YJSceneSetVC alloc]init];
        //        SightSettingViewController *vc = [[SightSettingViewController alloc]init];
//        vc.sceneName = cell.itemLabel.text;
//        vc.equipmentListData = [NSArray array];
        vc.sceneModel = [[YJSceneDetailModel alloc]init];
        [self closeBtnClick];
        [self.navigationController pushViewController:vc animated:true];
    }else{//处于我的设备页面
        YJRoomSetUpVC *setVC = [[YJRoomSetUpVC alloc]init];
//        setVC.roomName = self.roomBtn.titleLabel.text;
        setVC.roomModel = [[YJRoomDetailModel alloc]init];
        [self closeBtnClick];
        [self.navigationController pushViewController:setVC animated:true];
    }
}

#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==self.mysceneColView) {
        return self.mysceneListData.count;
    }else{
        return self.equipmentListData.count;
    }
    
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (collectionView==self.mysceneColView) {
        // 去缓存池找
        YJHomeSceneCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
        cell.sceneDetailModel = self.mysceneListData[indexPath.row];
//        cell.selected = false;
        return cell;
    }else{
        YJEquipmentrCollectionVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:eqCellid forIndexPath:indexPath];
        cell.equipmentModel = self.equipmentListData[indexPath.row];
//        cell.alpha = 0.7;
        return cell;
    }
    
    
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
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (collectionView==self.mysceneColView) {
            return nil;
        }
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        //添加头视图的内容
        YJHeaderTitleBtn *roomBtn = [[YJHeaderTitleBtn alloc]init];
        if (self.roomListData.count>0) {
            [roomBtn setTitle:self.curruntRoomModel.roomName forState:UIControlStateNormal];//给房间切换按钮赋值
        }else{
            [roomBtn setTitle:@"请添加房间" forState:UIControlStateNormal];
        }
        [roomBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        roomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [roomBtn setImage:[UIImage imageNamed:@"more_room"] forState:UIControlStateNormal];
//        roomBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        //    localBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
//        roomBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        [header addSubview:roomBtn];
        [roomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20*kiphone6);
            make.top.offset(0);
        }];
        [roomBtn addTarget:self action:@selector(roomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.roomBtn = roomBtn;
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
    if (collectionView==self.mysceneColView) {
        return CGSizeMake(kScreenW,0);
    }
    return CGSizeMake(kScreenW,30*kiphone6);
    
}
//懒加载
-(NSMutableArray *)mysceneListData{
    if (_mysceneListData == nil) {
        _mysceneListData = [NSMutableArray array];
    }
    return _mysceneListData;
}
-(NSMutableArray *)roomListData{
    if (_roomListData == nil) {
        _roomListData = [NSMutableArray array];
    }
    return _roomListData;
}
-(NSMutableArray *)equipmentListData{
    if (_equipmentListData == nil) {
        _equipmentListData = [NSMutableArray array];
    }
    return _equipmentListData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBarBgAlpha = @"0.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
    self.navigationController.navigationBar.translucent = true;
    if (self.mysceneListData.count>0) {
        [self.mysceneListData removeAllObjects];
    }
    if (self.equipmentListData.count>0) {
        [self.equipmentListData removeAllObjects];
    }
    if (self.roomListData.count>0) {
        [self.roomListData removeAllObjects];
    }
    [self httpRequestHomeInfo];//请求刷新数据
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
