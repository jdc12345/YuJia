//
//  YJHouseSearchListVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHouseSearchListVC.h"
#import "YJHouseListTVCell.h"
#import "YJRentalHouseVC.h"
#import "YJHouseDetailVC.h"
#import "YJSearchHourseVC.h"
#import "YJHouseListModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MJRefresh.h>
#import "UIViewController+Cloudox.h"
//改
#import "YJHeaderTitleBtn.h"
#import "YJCitySelectVC.h"
#import "YJSearchHouseConditionTVCell.h"
#import "YJHousePriceTVCell.h"
#import "YJHouseSearchMoreTVCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

static NSInteger start = 0;
static NSString* tableCellid = @"table_cell";
@interface YJHouseSearchListVC ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *houseArr;
@property(nonatomic,weak)YJHeaderTitleBtn *LocationBtn;//定位按钮
@property (nonatomic, strong) AMapLocationManager *locationManager;//定位实体类
//@property(nonatomic,strong)NSString *currentCity;//当前城市
//改
@property(nonatomic,weak)UIView *headerView;//头部视图
@property(nonatomic,weak)YJHeaderTitleBtn *areaBtn;//区域选择按钮
@property(nonatomic,weak)YJHeaderTitleBtn *priceBtn;//租金选择按钮
@property(nonatomic,weak)YJHeaderTitleBtn *typeBtn;//方式选择按钮
@property(nonatomic,weak)YJHeaderTitleBtn *moreBtn;//更多选择按钮

@property(nonatomic,weak)UITableView *firTableView;//区域第一个tableview
@property(nonatomic,weak)UITableView *secTableView;//区域第二个tableview
@property(nonatomic,weak)UITableView *thirdTableView;//区域第三个tableview
@property(nonatomic,weak)UITableView *priceTableView;//租金tableview
@property(nonatomic,weak)UITableView *typeTableView;//出租方式tableview
@property(nonatomic,weak)UITableView *moreTableView;//更多tableview
@property(nonatomic,strong)NSArray *firArr;//区域第一个tableview数据源
@property(nonatomic,strong)NSArray *secArr;//区域第二个tableview数据源
@property(nonatomic,strong)NSArray *thirdArr;//区域第三个tableview数据源
@property(nonatomic,strong)NSArray *priceArr;//租金tableview数据源
@property(nonatomic,strong)NSArray *typeArr;//出租方式tableview数据源
@property(nonatomic,strong)NSArray *moreArr;//更多tableview数据源
@property(nonatomic,strong)NSIndexPath *pricePath;//租金tableview选中的cell的path
@property(nonatomic,strong)NSIndexPath *typePath;//出租房方式tableview选中的cell的path
@property(nonatomic,assign)float tableHeight;//区域条件下的tableview高度
@property(nonatomic,weak)UIView *backGrayView;//半透明背景
@property(nonatomic,weak)UIView *areaBackView;//区域联动列表背景

@end

@implementation YJHouseSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租房信息";
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    NSMutableArray* itemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer1.width = -10;
    [itemArr addObject:negativeSpacer1];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20*kiphone6, 30)];
    backBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [itemArr addObject:leftItem1];
    self.navigationItem.leftBarButtonItems = itemArr;//导航栏左侧按钮
    NSMutableArray* rightItemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    [rightItemArr addObject:negativeSpacer];//修正按钮离屏幕边缘位置的UIBarButtonItem应在按钮的前边加入数组
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [postBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    //    postBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [postBtn addTarget:self action:@selector(postBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    [rightItemArr addObject:rightBarItem];
    self.navigationItem.rightBarButtonItems = rightItemArr;//导航栏右侧按钮
    //头部视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 88.5*kiphone6)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    YJHeaderTitleBtn *localBtn = [[YJHeaderTitleBtn alloc]init];//定位按钮
    [headerView addSubview:localBtn];
    [localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerView.mas_top).offset(20.5*kiphone6);
        make.width.offset(80*kiphone6);
        make.height.offset(30*kiphone6);
    }];
    self.LocationBtn = localBtn;
    localBtn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [localBtn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
    [localBtn setTitle:@"定位中" forState:UIControlStateNormal];
    localBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [localBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    localBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    localBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    localBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    //    -------------------------先用locationKit定位，再根据定位的坐标用searchKit查询
    [AMapServices sharedServices].apiKey =@"380748c857866280e77da5bb813e13c5";
    
    self.locationManager = [[AMapLocationManager alloc]init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"location:%@", location);
        //定位结果
        NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
        if (regeocode)//定位只返回到城市级别的信息，此处刚好只需要城市的名字
        {
            NSLog(@"reGeocode:%@", regeocode.district);
            if(!regeocode.district){
                [localBtn setTitle:@"无定位" forState:UIControlStateNormal];
            }else{
                [localBtn setTitle:regeocode.district forState:UIControlStateNormal];
                //                        self.currentCity = localBtn.titleLabel.text;
//                //当前区域数据
//                self.firArr = @[@{@"secArr":@[@"不限",@"1000米内",@"1500米内",@"2000米内"],@"name":@"附近"},@{@"secArr":@[@"全保定",@"北市",@"南市",@"涿州",@"高开"],@"name":@"区域"}];
//                self.secArr = @[@"全保定",@"北市",@"南市",@"涿州",@"高开"];
//                self.thirdArr = @[];
//                self.tableHeight = 0;
//                for (int i=0; i<self.firArr.count; i++) {
//                   NSArray *secArr = self.firArr[i][@"secArr"];
//                   self.tableHeight = self.tableHeight<secArr.count*45*kiphone6?secArr.count*45*kiphone6:self.tableHeight;//取出最大值作为区域按钮下tableview所在背景的高度
//                }
                [self loadData];
            }
        }
    }];
    [localBtn addTarget:self action:@selector(localBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //当前区域数据
    self.firArr = @[@{@"secArr":@[@"不限",@"1000米内",@"1500米内",@"2000米内"],@"name":@"附近"},@{@"secArr":@[@"全保定",@"北市",@"南市",@"涿州",@"高开"],@"name":@"区域"}];
    self.secArr = @[@"全保定",@"北市",@"南市",@"涿州",@"高开"];
    self.thirdArr = @[];
    self.tableHeight = 0;
    for (int i=0; i<self.firArr.count; i++) {
        NSArray *secArr = self.firArr[i][@"secArr"];
        self.tableHeight = self.tableHeight<secArr.count*45*kiphone6?secArr.count*45*kiphone6:self.tableHeight;//取出最大值作为区域按钮下tableview所在背景的高度
    }
    
    UIButton *searchBtn = [[UIButton alloc]init];//搜索按钮
    [headerView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(localBtn.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(headerView.mas_top).offset(20.5*kiphone6);
        make.right.offset(-10*kiphone6);
        make.height.offset(30*kiphone6);
    }];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"请输入小区名、户型" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    searchBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    localBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line1 = [[UIView alloc]init];//分割线1
    line1.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [headerView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(41*kiphone6);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UIView *line2 = [[UIView alloc]init];//分割线1
    line2.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [headerView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    NSArray *conditionArr = @[@"区域",@"租金",@"出租方式",@"更多"];
    for (int i=0; i<conditionArr.count; i++) {
        YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]init];
        btn.tag = 1+i;
        switch (btn.tag) {
            case 1:
                self.areaBtn = btn;
                break;
            case 2:
                self.priceBtn = btn;
                break;
            case 3:
                self.typeBtn = btn;
                break;
            case 4:
                self.moreBtn = btn;
                break;
            default:
                break;
        }
        [btn setTitle:conditionArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"click-Triangle"] forState:UIControlStateSelected];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [headerView addSubview:btn];
        CGFloat width = kScreenW*0.25;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(i*width);
            make.centerY.equalTo(headerView.mas_bottom).offset(-24*kiphone6);
            make.width.offset(width);
            make.height.offset(48*kiphone6);
        }];
        [btn addTarget:self action:@selector(choiceCondition:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)choiceCondition:(UIButton*)sender{//搜索房源的条件
    sender.selected = !sender.selected;
    //大蒙布View
    if (!self.backGrayView) {
        UIView *backGrayView = [[UIView alloc]init];
        self.backGrayView = backGrayView;
        backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        backGrayView.alpha = 0.2;
        [self.view addSubview:backGrayView];
        [backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sender.mas_bottom);
            make.left.bottom.right.offset(0);
        }];
        backGrayView.userInteractionEnabled = YES;
//        //添加tap手势：
//        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
//        //将手势添加至需要相应的view中
//        [backGrayView addGestureRecognizer:tapGesture];
        UIView *backView = [[UIView alloc]init];//背景view
        self.areaBackView = backView;
        backView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [self.view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sender.mas_bottom);
            make.height.offset(self.tableHeight);
            make.left.right.offset(0);
        }];
        
    }
    switch (sender.tag) {
        case 1:
            self.priceBtn.selected = false;
            self.typeBtn.selected = false;
            self.moreBtn.selected = false;
            break;
        case 2:
            self.areaBtn.selected = false;
            self.typeBtn.selected = false;
            self.moreBtn.selected = false;
            break;
        case 3:
            self.areaBtn.selected = false;
            self.priceBtn.selected = false;
            self.moreBtn.selected = false;
            break;
        case 4:
            self.areaBtn.selected = false;
            self.priceBtn.selected = false;
            self.typeBtn.selected = false;
            break;
        default:
            break;
    }

    if (sender.selected) {
        self.backGrayView.hidden = false;
        switch (sender.tag) {
            case 1:
                self.areaBackView.hidden = false;
                self.priceTableView.hidden=true;
                self.typeTableView.hidden=true;
                self.moreTableView.hidden = true;
                if (!self.firTableView) {
                    UITableView *firTableView = [[UITableView alloc] init];
                    firTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    self.firTableView = firTableView;
                    firTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                    [self.areaBackView addSubview:self.firTableView];
                    self.firTableView.delegate=self;
                    self.firTableView.dataSource=self;
                    self.firTableView.tag=1000;
                    
                    UITableView *secTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    secTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    secTableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
                    [self.areaBackView addSubview:secTableView];
                    self.secTableView = secTableView;
                    self.secTableView.delegate=self;
                    self.secTableView.dataSource=self;
                 
                    UITableView *thirdTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    secTableView.backgroundColor = [UIColor colorWithHexString:@"#f8f9fa"];
                    thirdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    [self.areaBackView addSubview:thirdTableView];
                    self.thirdTableView = thirdTableView;
                    self.thirdTableView.delegate=self;
                    self.thirdTableView.dataSource=self;
                    
                    if (self.thirdArr.count>0) {
                        firTableView.frame = CGRectMake(0, 0, kScreenW/3, self.tableHeight);
                        secTableView.frame = CGRectMake(kScreenW/3, 0, kScreenW/3, self.tableHeight);
                        thirdTableView.frame = CGRectMake(kScreenW/3*2, 0, kScreenW/3, self.tableHeight);
                    }else{
                        firTableView.frame = CGRectMake(0, 0, 112*kiphone6, self.tableHeight);
                        secTableView.frame = CGRectMake(112*kiphone6, 0, kScreenW-112*kiphone6, self.tableHeight);
                        thirdTableView.frame = CGRectMake(kScreenW/3*2, 0, 0, self.tableHeight);
                    }
                    //开始默认选择cell
                    NSIndexPath* path1 = [NSIndexPath indexPathForRow:1 inSection:0];
                    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.firTableView selectRowAtIndexPath:path1 animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self.secTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self.thirdTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                break;
            case 2:
                self.areaBackView.hidden = true;
                self.priceTableView.hidden=false;
                self.typeTableView.hidden=true;
                self.moreTableView.hidden = true;
                if (!self.priceTableView) {
                    NSArray *priceArr = @[@"不限",@"1500元以下",@"1500-2500元以下",@"2500-4000元以下",@"4000-5500元以下",@"5500-7000元以下",@"7000元以上"];
                    self.priceArr = priceArr;
                    UITableView *priceTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    priceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    priceTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                    [self.view addSubview:priceTableView];
                    [self.view bringSubviewToFront:priceTableView];
                    [priceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.offset(0);
                        make.top.equalTo(self.headerView.mas_bottom);
                        make.height.offset(330*kiphone6);
                    }];
                    self.priceTableView = priceTableView;
                    self.priceTableView.delegate=self;
                    self.priceTableView.dataSource=self;
                    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.priceTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                break;
            case 3:
                self.areaBackView.hidden = true;
                self.priceTableView.hidden = true;
                self.typeTableView.hidden = false;
                self.moreTableView.hidden = true;
                if (!self.typeTableView) {
                    NSArray *typeArr = @[@"不限",@"整租",@"合租"];
                    self.typeArr = typeArr;
                    UITableView *typeTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    typeTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                    [self.view addSubview:typeTableView];
                    [self.view bringSubviewToFront:typeTableView];
                    [typeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.offset(0);
                        make.top.equalTo(self.headerView.mas_bottom);
                        make.height.offset(150*kiphone6);
                    }];
                    self.typeTableView = typeTableView;
                    self.typeTableView.delegate=self;
                    self.typeTableView.dataSource=self;
                    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.typeTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                }

                break;
            case 4:
                self.areaBackView.hidden = true;
                self.priceTableView.hidden = true;
                self.typeTableView.hidden = true;
                self.moreTableView.hidden = false;
                if (!self.moreTableView) {
                    NSArray *moreArr = @[@{@"typeArr":@[@"1居",@"2居",@"3居",@"4居",@"4居以上"],@"item":@"户型"},@{@"typeArr":@[@"东",@"南",@"西",@"北",@"南北"],@"item":@"朝向"}];
                    self.moreArr = moreArr;
                    UITableView *moreTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    moreTableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                    [self.view addSubview:moreTableView];
                    [self.view bringSubviewToFront:moreTableView];
                    [moreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.offset(0);
                        make.top.equalTo(self.headerView.mas_bottom);
                        make.height.offset(340*kiphone6);
                    }];
                    self.moreTableView = moreTableView;
                    self.moreTableView.delegate=self;
                    self.moreTableView.dataSource=self;
                    self.moreTableView.rowHeight = UITableViewAutomaticDimension;
                    self.moreTableView.estimatedRowHeight = 140*kiphone6;
                    //尾部视图
                    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 75*kiphone6)];
                    UIButton *clearBtn = [[UIButton alloc]init];//搜索按钮
                    [footView addSubview:clearBtn];
                    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(20*kiphone6);
                        make.centerY.equalTo(footView);
                        make.width.offset((kScreenW-91*kiphone6)*0.5);
                        make.height.offset(44*kiphone6);
                    }];
                    clearBtn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
                    [clearBtn setTitle:@"清空条件" forState:UIControlStateNormal];
                    clearBtn.titleLabel.font = [UIFont systemFontOfSize:17];
                    [clearBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    [clearBtn addTarget:self action:@selector(moreTableViewClearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    UIButton *determineBtn = [[UIButton alloc]init];//确定按钮
                    [footView addSubview:determineBtn];
                    [determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(clearBtn.mas_right).offset(51*kiphone6);
                        make.centerY.equalTo(footView);
                        make.width.offset((kScreenW-91*kiphone6)*0.5);
                        make.height.offset(44*kiphone6);
                    }];
                    determineBtn.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
                    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
                    determineBtn.titleLabel.font = [UIFont systemFontOfSize:17];
                    [determineBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                    [determineBtn addTarget:self action:@selector(moreTableViewDetermineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    footView.backgroundColor =[UIColor colorWithHexString:@"#ffffff"];
                    self.moreTableView.tableFooterView = footView;    
                }
                break;
            default:
                break;
        }
    }else{
        self.backGrayView.hidden = true;
        self.areaBackView.hidden = true;
        self.typeTableView.hidden = true;
        self.priceTableView.hidden = true;
        self.moreTableView.hidden = true;
    }
}
//moreTableView按钮点击事件
- (void)moreTableViewClearBtnClick:(UIButton*)sender {
    YJHouseSearchMoreTVCell *cell1 = [self.moreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    for (UIButton *btn in cell1.contentView.subviews) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
    YJHouseSearchMoreTVCell *cell2 = [self.moreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    for (UIButton *btn in cell2.contentView.subviews) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
}
- (void)moreTableViewDetermineBtnClick:(UIButton*)sender {
    //根据筛选条件发起请求搜索房源
}

- (void)loadData{
//http://localhost:8080/smarthome/mobileapi/rental/findPage.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &cyty=%E6%B6%BF%E5%B7%9E
//    &residentialQuarters=%E5%90%8D%E6%B5%81%E4%B8%80%E5%93%81%E5%B0%8F%E5%8C%BA  小区可不传,此处不传
//    &lstart=0
//    &limit=1
    [SVProgressHUD show];// 动画开始
    NSString *rname = self.LocationBtn.titleLabel.text;
    rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=0&limit=10",mPrefixUrl,mDefineToken1,rname];
    [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"]isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            if (arr.count>0) {
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                self.houseArr = mArr;
                start = self.houseArr.count;
                [self setupUI];
            }else{
                [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
  
}
- (void)backBtnClick:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (void)localBtnClick:(UIButton*)sender {
    YJCitySelectVC *vc = [[YJCitySelectVC alloc]init];
    vc.cityName = sender.titleLabel.text;
//    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
//    vc.searchCayegory = 0;
//    vc.city = self.currentCity;
    vc.popVCBlock = ^(NSString *cityName){
        [self.LocationBtn setTitle:cityName forState:UIControlStateNormal];
        [SVProgressHUD show];// 动画开始
        cityName = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=0&limit=10",mPrefixUrl,mDefineToken1,cityName];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                if (arr.count>0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    self.houseArr = mArr;
                    start = self.houseArr.count;
//                    [self setupUI];
                    [self.tableView reloadData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            return ;
        }];
    };
    [self.navigationController pushViewController:vc animated:true];
}
- (void)searchBtnClick:(UIButton*)sender {
    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
    vc.searchCayegory = 1;
    vc.city = self.LocationBtn.titleLabel.text;
    [self.navigationController pushViewController:vc animated:true];
}
- (void)setupUI {
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    //    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJHouseListTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight =  107*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSString *rname = self.LocationBtn.titleLabel.text;
        rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=0&limit=10",mPrefixUrl,mDefineToken1,rname];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                if (arr.count>0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    self.houseArr = mArr;
                    start = self.houseArr.count;
                [self.tableView reloadData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
                }
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
        if (self.houseArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        NSString *rname = self.LocationBtn.titleLabel.text;
        rname = [rname stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findPage.do?token=%@&cyty=%@&start=%ld&limit=5",mPrefixUrl,mDefineToken1,rname,start];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"]isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                if (arr.count>0) {
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                        [mArr addObject:infoModel];
                    }
                    [self.houseArr addObjectsFromArray:mArr];
                    start = self.houseArr.count;
                [self.tableView reloadData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
                }
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
}
- (void)postBtn:(UIButton*)sender {
    YJRentalHouseVC *vc = [[YJRentalHouseVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma UItableViewDelegate+datesource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.firTableView==tableView) {
        return  self.firArr.count;
    }else if(self.secTableView == tableView){
        return self.secArr.count;
    }else if(self.thirdTableView == tableView){
        return self.thirdArr.count;
    }else if (self.priceTableView==tableView){
        return self.priceArr.count;
    }else if (self.typeTableView==tableView){
        return self.typeArr.count;
    }else if (self.moreTableView==tableView){
        return self.moreArr.count;
    }
    return self.houseArr.count;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.firTableView==tableView) {
        static NSString *proReuse=@"proReuse";
        YJSearchHouseConditionTVCell *cell=[tableView dequeueReusableCellWithIdentifier:proReuse];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        if (!cell) {
            cell=[[YJSearchHouseConditionTVCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:proReuse];
        }
        cell.textLabel.text=self.firArr[indexPath.row][@"name"];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(1/[UIScreen mainScreen].scale);
        }];
        return cell;
    }else if (self.secTableView==tableView){
        static NSString *cityReuse=@"cityReuse";
        YJSearchHouseConditionTVCell *cell=[tableView dequeueReusableCellWithIdentifier:cityReuse];
        if (!cell) {
            cell=[[YJSearchHouseConditionTVCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cityReuse];
        }
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f8f9fa"];
        cell.textLabel.text=self.secArr[indexPath.row];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(1/[UIScreen mainScreen].scale);
        }];

        return cell;
        
    }else if (self.thirdTableView==tableView){
        static NSString *zoneReuse=@"zoneReuse";
        YJSearchHouseConditionTVCell *cell=[tableView dequeueReusableCellWithIdentifier:zoneReuse];
        if (!cell) {
            cell=[[YJSearchHouseConditionTVCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:zoneReuse];
        }
        if (self.thirdArr.count>0) {
            cell.textLabel.text=self.thirdArr[indexPath.row];
        }
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(1/[UIScreen mainScreen].scale);
        }];
        return cell;
    }else if (self.priceTableView==tableView){
        YJHousePriceTVCell *cell = [[YJHousePriceTVCell alloc]init];
        cell.price = self.priceArr[indexPath.row];
        NSInteger row = [indexPath row];
        NSInteger oldRow = [self.pricePath row];
        if (row == oldRow && self.pricePath!=nil) {
            //这个是系统中对勾的那种选择框
            cell.itemLabel.textColor = [UIColor colorWithHexString:@"#00eac6"];
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.itemLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//            cell.accessoryType = UITableViewCellAccessoryNone;
        }//cell单选
        
    return cell;
    }else if (self.typeTableView==tableView){
        YJHousePriceTVCell *cell = [[YJHousePriceTVCell alloc]init];
        cell.price = self.typeArr[indexPath.row];
        NSInteger row = [indexPath row];
        NSInteger oldRow = [self.typePath row];
        if (row == oldRow && self.typePath!=nil) {
            //这个是系统中对勾的那种选择框
            cell.itemLabel.textColor = [UIColor colorWithHexString:@"#00eac6"];
            //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.itemLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            //            cell.accessoryType = UITableViewCellAccessoryNone;
        }//cell单选
        
        return cell;
    }
    else if (self.moreTableView==tableView){
        YJHouseSearchMoreTVCell *cell = [[YJHouseSearchMoreTVCell alloc]init];
        cell.baseTag = indexPath.row+10;
        cell.dic = self.moreArr[indexPath.row];
        
        return cell;
    }
    YJHouseListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.houseArr[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.moreTableView) {
        return[YJHouseSearchMoreTVCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
//            YJHouseSearchMoreTVCell *cell = (YJHouseSearchMoreTVCell *)sourceCell;
            // 配置数据
//            [cell configCellWithModel:nil indexPath:indexPath];
        }];
    }
    if (tableView == self.tableView) {
        return 110*kiphone6;
    }
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.firTableView==tableView){
        self.secArr=self.firArr[indexPath.row][@"secArr"];
        [self.secTableView reloadData];
        NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.secTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else if(self.secTableView ==tableView){
        if (self.thirdArr.count>0) {
            self.thirdArr=self.secArr[indexPath.row][@"thirdArr"];
            [self.thirdTableView reloadData];
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.thirdTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        [self.areaBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
        
    }
    if (self.priceTableView==tableView){
        NSInteger newRow = [indexPath row];
        NSInteger oldRow = (self.pricePath !=nil)?[self.pricePath row]:-1;
        if (newRow != oldRow) {
            YJHousePriceTVCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.itemLabel.textColor = [UIColor colorWithHexString:@"#00eac6"];
//            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            YJHousePriceTVCell *oldCell = [tableView cellForRowAtIndexPath:self.pricePath];
//            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldCell.itemLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self .pricePath = indexPath;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//cell单选

        YJHousePriceTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.priceBtn setTitle:cell.price forState:UIControlStateNormal];
    }
    if (self.typeTableView==tableView){
        NSInteger newRow = [indexPath row];
        NSInteger oldRow = (self.typePath !=nil)?[self.typePath row]:-1;
        if (newRow != oldRow) {
            YJHousePriceTVCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.itemLabel.textColor = [UIColor colorWithHexString:@"#00eac6"];
            //            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            YJHousePriceTVCell *oldCell = [tableView cellForRowAtIndexPath:self.typePath];
            //            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldCell.itemLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self .typePath = indexPath;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//cell单选
        
        YJHousePriceTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.typeBtn setTitle:cell.price forState:UIControlStateNormal];
    }
    if (tableView == self.tableView) {//匹配的房源cell
        YJHouseDetailVC *detailVc = [[YJHouseDetailVC alloc]init];
        YJHouseListTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        detailVc.info_id = cell.model.info_id;
        [self.navigationController pushViewController:detailVc animated:true];
    }
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
