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
//#import "UIViewController+Cloudox.h"
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
@property(nonatomic,strong)NSMutableArray *secArr;//区域第二个tableview数据源
@property(nonatomic,strong)NSMutableArray *sThirdArr;//区域第三个tableview数据源
@property(nonatomic,strong)NSMutableArray *thirdArr;//区域第三个tableview数据源的汇总
@property(nonatomic,strong)NSArray *priceArr;//租金tableview数据源
@property(nonatomic,strong)NSArray *typeArr;//出租方式tableview数据源
@property(nonatomic,strong)NSArray *moreArr;//更多tableview数据源
@property(nonatomic,strong)NSIndexPath *pricePath;//租金tableview选中的cell的path
@property(nonatomic,strong)NSIndexPath *typePath;//出租房方式tableview选中的cell的path
@property(nonatomic,assign)float tableHeight;//区域条件下的tableview高度
@property(nonatomic,weak)UIView *backGrayView;//半透明背景
@property(nonatomic,weak)UIView *areaBackView;//区域联动列表背景

@property (nonatomic, strong) AMapSearchAPI *search;//搜索实体类
@property (nonatomic, copy)   AMapGeoPoint *location;//中心点坐标。
@property (nonatomic, strong)   NSString *name;//根据名称进行行政区划数据搜索的名称
@property (nonatomic, assign)   BOOL isExchangeCity;//是否更换了城市。
@property(nonatomic,strong)NSString *areaCode;//乡镇一级编码没有，传名字
@property(nonatomic,strong)NSString *codeUpperLevel;//县级市，县，区一级编码
@property(nonatomic,strong)NSString *codeUpperTwo;//市一级编码
@property (nonatomic, assign)   NSInteger rent;//租金。
@property (nonatomic, assign)   NSInteger rentalTyoe;//出租方式1=整租2=合租
@property(nonatomic,strong)NSString *residentialQuarters;//小区名字
@property(nonatomic,strong)NSString *apartmentLayout;//房屋户型
@property(nonatomic,strong)NSString *direction;//朝向

@end

@implementation YJHouseSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租房信息";
//    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    //初始化搜索各个参数
    self.areaCode = @"0";
    self.codeUpperLevel = @"0";
    self.codeUpperTwo = @"0";
    self.residentialQuarters = @"0";
    self.apartmentLayout = @"0";
    self.direction = @"0";
    self.rent = 0;
    self.rentalTyoe = 0;
    //初始化更多按钮下的条件数据
    NSArray *moreArr = @[@{@"typeArr":@[@"1室",@"2室",@"3室",@"4室",@"4室以上"],@"item":@"户型"},@{@"typeArr":@[@"东",@"南",@"西",@"北",@"南北"],@"item":@"朝向"}];
    self.moreArr = moreArr;
    //头部视图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 88.5*kiphone6)];
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
                self.codeUpperLevel = regeocode.adcode;//定位之后查的是定位地的房源数据，所以显示adcode
                //                        self.currentCity = localBtn.titleLabel.text;
                [self loadData];//先根据定位的城市搜索并显示房源，再根据城市编码确定行政区划数据
                [self setupUI];
                self.isExchangeCity=true;//第一次城市初次定位，需要确定下级行政区域，所以为true
                //设置行政区划查询参数并发起行政区划查询
                self.search = [[AMapSearchAPI alloc] init];//实例化搜索对象
                self.search.delegate = self;
                AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
                dist.keywords = regeocode.citycode;//查询行政数据，所以传citycode
                dist.requireExtension = YES;
                [self.search AMapDistrictSearch:dist];                
            }
        }
    }];
    [localBtn addTarget:self action:@selector(localBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
#pragma AMapSearchDelegate
/* 行政区划数据查询回调. */
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    //当前区域数据
    
    //解析response获取行政区划，具体解析见 Demo
    for (AMapDistrict *dist in response.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
    {
        
//        NSLog(@"%@,name:%@ 下级行政区域数：%ld ///返回数目%ld",dist.level,dist.name,dist.districts.count,response.count);
        if (self.isExchangeCity) {//改变了城市一级区域才要更新secTableview数据源
            self.secArr = [NSMutableArray arrayWithObject:dist];//第二个数组第一个元素
            // sub(二级)
            for (AMapDistrict *subdist in dist.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
            {
//                NSLog(@"区域编号：%@,区域名字：%@ 下级行政区域数：%ld",subdist.adcode,subdist.name,subdist.districts.count);
                [self.secArr addObject:subdist];//第二个数组的第一个元素之后元素
            }
            [self.secTableView reloadData];
            self.isExchangeCity = false;//每次查询之后必须设为false，只有在改变了城市之后才会改为true
            self.thirdArr = [NSMutableArray array];//此时三级数据源是空的
        }else{//两种执行情况：1.执行更新secTableview数据源之后，选取第一个下级行政区域数据源作为thirdTableView数据源 2.点击了secTableview的cell需要更新对应的thirdTableView数据源
            self.thirdArr = [NSMutableArray arrayWithObject:dist];//第三个数组第一个元素
            // sub(三级)
            for (AMapDistrict *subdist in dist.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
            {
                //                NSLog(@"区域编号：%@,区域名字：%@ 下级行政区域数：%ld",subdist.adcode,subdist.name,subdist.districts.count);
                [self.thirdArr addObject:subdist];//第三个数组的第一个元素之后元素
            }
        }
        [self.thirdTableView reloadData];
        self.firArr = @[@{@"secArr":@[@"不限",@"1000米内",@"1500米内",@"2000米内"],@"name":@"附近"},@{@"secArr":self.secArr,@"name":@"区域"}];
        self.tableHeight = 0;
        for (int i=0; i<self.firArr.count; i++) {
            NSArray *secArr = self.firArr[i][@"secArr"];
            self.tableHeight = self.tableHeight<(secArr.count*45*kiphone6)?(secArr.count*45*kiphone6):self.tableHeight;//取出最大值作为区域按钮下tableview所在背景的高度
        }
        self.tableHeight = self.tableHeight<(self.thirdArr.count*45*kiphone6)?(self.thirdArr.count*45*kiphone6):self.tableHeight;//取出最大值作为区域按钮下tableview所在背景的高度
        self.tableHeight = self.tableHeight>(kScreenH-88.5*kiphone6-64*kiphone6)?(kScreenH-88.5*kiphone6-64*kiphone6):self.tableHeight;//如果超出屏幕可视区域需要把可视区域的高度作为区域按钮下tableview所在背景的高度，否则有可能无法完全scrollw整个tableview
        break;//大for循环只执行一次
    }
    
}
//当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [SVProgressHUD showErrorWithStatus:error.description];
}

- (void)choiceCondition:(UIButton*)sender{//搜索房源的条件
    if (self.firArr.count==0) {
        [SVProgressHUD showInfoWithStatus:@"正在请求该区域的下级行政区域数据，请稍后再试"];
        return;
    }
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
                    secTableView.backgroundColor = [UIColor colorWithHexString:@"#f8f9fa"];
                    [self.areaBackView addSubview:secTableView];
                    self.secTableView = secTableView;
                    self.secTableView.delegate=self;
                    self.secTableView.dataSource=self;
                 
                    UITableView *thirdTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                    thirdTableView.backgroundColor = [UIColor colorWithHexString:@"#f8f9fa"];
                    thirdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    [self.areaBackView addSubview:thirdTableView];
                    self.thirdTableView = thirdTableView;
                    self.thirdTableView.delegate=self;
                    self.thirdTableView.dataSource=self;
                    
                    
                    firTableView.frame = CGRectMake(0, 0, kScreenW/3, self.tableHeight);
                    secTableView.frame = CGRectMake(kScreenW/3, 0, kScreenW/3, self.tableHeight);
                    thirdTableView.frame = CGRectMake(kScreenW/3*2, 0, kScreenW/3, self.tableHeight);
//                    if (self.thirdArr.count>0) {
//                        firTableView.frame = CGRectMake(0, 0, kScreenW/3, self.tableHeight);
//                        secTableView.frame = CGRectMake(kScreenW/3, 0, kScreenW/3, self.tableHeight);
//                        thirdTableView.frame = CGRectMake(kScreenW/3*2, 0, kScreenW/3, self.tableHeight);
//                    }else{
//                        firTableView.frame = CGRectMake(0, 0, 112*kiphone6, self.tableHeight);
//                        secTableView.frame = CGRectMake(112*kiphone6, 0, kScreenW-112*kiphone6, self.tableHeight);
//                        thirdTableView.frame = CGRectMake(kScreenW/3*2, 0, 0, self.tableHeight);
//                    }
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
                    NSArray *priceArr = @[@"不限",@"1500元以下",@"1500-2500元",@"2500-4000元",@"4000-5500元",@"5500-7000元",@"7000元以上"];
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
                    [clearBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
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
//moreTableView清除条件按钮点击事件
- (void)moreTableViewClearBtnClick:(UIButton*)sender {
    YJHouseSearchMoreTVCell *cell1 = [self.moreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    for (UIButton *btn in cell1.contentView.subviews) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
    YJHouseSearchMoreTVCell *cell2 = [self.moreTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    for (UIButton *btn in cell2.contentView.subviews) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    }
    self.apartmentLayout = @"0";
    self.direction = @"0";
}
//根据更多按钮下筛选条件发起请求搜索房源
- (void)moreTableViewDetermineBtnClick:(UIButton*)sender {
    
    [self loadData];
}
//搜索匹配条件的房源请求
- (void)loadData{
http://localhost:8080/smarthome/mobileapi/rental/findconditionAll.do?token=49491B920A9DD107E146D961F4BDA50E
//    &start=0
//    &limit=20
//    &codeUpperTwo=110000
//    &areaCode=0
//    &codeUpperLevel=0
//    &residentialQuarters=0
//    &apartmentLayout=0
//    &direction=0
//    &rent=0
//    &rentalTyoe=0
//    参数：       参数名                 参数类型                 备注
//    areaCode                   String      乡镇一级编码
//    codeUpperLevel        String      县级市，县，区一级编码
//    codeUpperTwo        String      市一级的编码
//    residentialQuarters      String      小区名字
//    apartmentLayout        String      房屋户型
//    direction              String      朝向
//    rent            Integer      租金
//    rentalTyoe              Integer      出租方式1=整租2=合租
//    token                  令牌
//    start              起始页数
//    limit              每页总数
    [SVProgressHUD show];// 动画开始
//    areaCode = [areaCode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *houseUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findconditionAll.do?token=%@&areaCode=%@&codeUpperLevel=%@&codeUpperTwo=%@&residentialQuarters=%@&apartmentLayout=%@&direction=%@&rent=%ld&rentalTyoe=%ld&start=%ld&limit=10",mPrefixUrl,mDefineToken1,self.areaCode,self.codeUpperLevel,self.codeUpperTwo,self.residentialQuarters,self.apartmentLayout,self.direction,self.rent,self.rentalTyoe,start];
    houseUrlStr = [houseUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HttpClient defaultClient]requestWithPath:houseUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        NSString *total = responseObject[@"total"];
         NSMutableArray *mArr = [NSMutableArray array];
        if ([total integerValue]>0) {
            NSArray *arr = responseObject[@"rows"];
            
                for (NSDictionary *dic in arr) {
                    YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
            
        }else{
//            [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
        }
        if (start==0) {//根据条件发起请求或者下拉刷新
            self.houseArr = mArr;
        }else{//上拉加载
            [self.houseArr addObjectsFromArray:mArr];
        }
        start = self.houseArr.count;
        [self.tableView reloadData];
        if ([responseObject[@"code"]isEqualToString:@"-1"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

}
//返回按钮点击事件
- (void)backBtnClick:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:true];
}
//定位按钮点击事件
- (void)localBtnClick:(UIButton*)sender {
    YJCitySelectVC *vc = [[YJCitySelectVC alloc]init];
    vc.cityName = sender.titleLabel.text;
//    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
//    vc.searchCayegory = 0;
//    vc.city = self.currentCity;
    vc.popVCBlock = ^(NSString *cityName){//选择城市之后的返回事件
        if (![cityName isEqualToString:self.LocationBtn.titleLabel.text]) {
            self.isExchangeCity = true;//改变了城市
        }
        [self.LocationBtn setTitle:cityName forState:UIControlStateNormal];
        //设置行政区划查询参数并发起行政区划查询
        AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
        if ([cityName isEqualToString:@"保定市"]) {
            dist.keywords = @"130600";
            self.codeUpperTwo = @"130600";
        }else if ([cityName isEqualToString:@"北京市"]){
            dist.keywords = @"110100";
            self.codeUpperTwo = @"110100";
        }
        dist.requireExtension = YES;
        [self.search AMapDistrictSearch:dist];
        //初始化切换城市返回该页面之后搜索各个参数
        self.areaCode = @"0";
        self.codeUpperLevel = @"0";
//        self.codeUpperTwo = @"0";
        self.residentialQuarters = @"0";
        self.apartmentLayout = @"0";
        self.direction = @"0";
        self.rent = 0;
        self.rentalTyoe = 0;
        [self loadData];
    };
    [self.navigationController pushViewController:vc animated:true];
}
//搜索按钮点击事件
- (void)searchBtnClick:(UIButton*)sender {
    YJSearchHourseVC *vc = [[YJSearchHourseVC alloc]init];
    vc.searchCayegory = 1;
    vc.city = self.LocationBtn.titleLabel.text;
    vc.areaCode = self.areaCode;
    vc.codeUpperTwo = self.codeUpperTwo;
    vc.codeUpperLevel = self.codeUpperLevel;
    [self.navigationController pushViewController:vc animated:true];
}
//大tableview
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
        start=0;
        [weakSelf loadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入加载状态后会自动调用这个block
        if (weakSelf.houseArr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        [weakSelf loadData];
        [weakSelf.tableView.mj_footer endRefreshing];
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
        if ([self.secArr[indexPath.row] isKindOfClass:[NSString class]]) {//点“附近按钮”时候
            cell.textLabel.text=self.secArr[indexPath.row];
        }else{
            AMapDistrict *dist = self.secArr[indexPath.row];
            if (indexPath.row==0) {
                cell.textLabel.text= [NSString stringWithFormat:@"全%@",dist.name];
            }else{
                cell.textLabel.text=dist.name;
            }
        }
        
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
            AMapDistrict *dist = self.thirdArr[indexPath.row];
            if (indexPath.row==0) {
                cell.textLabel.text= [NSString stringWithFormat:@"全%@",dist.name];
            }else{
                cell.textLabel.text=dist.name;
            }
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
        cell.dic = self.moreArr[indexPath.row];
        cell.baseTag = (indexPath.row*10)+10;//因为每个cell上有多个btn，必须区分开cell
        cell.clickBtnBlock = ^(NSString *title){
            if (indexPath.row==0) {
                if ([title isEqualToString:@"不限"]) {//不限户型传0
                    self.apartmentLayout = @"0";
                }else{
                    self.apartmentLayout = title;
                }
            }else{
                self.direction = title;
            }
        };
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
        if ([self.secArr[indexPath.row] isKindOfClass:[NSString class]]) {//点“附近按钮”时候
            self.thirdArr = [NSMutableArray array];
            [self.thirdTableView reloadData];
        }
        //第一级不需要发起数据请求
        return;
    }
    else if(self.secTableView ==tableView){
        if (![self.secArr[indexPath.row] isKindOfClass:[NSString class]]) {
            AMapDistrict *cellDist = self.secArr[indexPath.row];
            if (indexPath.row>0) {
                //把点击区域的acode改变，并发起行政区域查询
                //设置行政区划查询参数并发起行政区划查询
                AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
                dist.keywords = cellDist.adcode;
                dist.requireExtension = YES;
                [self.search AMapDistrictSearch:dist];
                self.codeUpperLevel = cellDist.adcode;
                self.areaCode = @"0";
            }else{
                self.codeUpperTwo = cellDist.adcode;//row等于0时候为“全xx市”
                self.codeUpperLevel = @"0";
                self.areaCode = @"0";
                self.thirdArr = [NSMutableArray array];
                [self.thirdTableView reloadData];//选择“全xx市”时候第三级没有数据
            }
        }else{//点“附近按钮”时候
            
        }
        [self.areaBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
        
    }
    else if(self.thirdTableView ==tableView){
        AMapDistrict *dist = self.thirdArr[indexPath.row];
        if (indexPath.row>0) {
            self.areaCode = dist.name;//三级没有编码，直接传名字
        }else{
            self.codeUpperLevel = dist.adcode;//row等于0时候为“全xx区(县)”
            self.areaCode = @"0";
        }
//        if (self.thirdArr.count>0) {
//            self.sThirdArr=self.thirdArr[indexPath.row];//设计thirdTableView数据源对应secTableView对应位置区域的下级行政区域
//            [self.thirdTableView reloadData];
//            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.thirdTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
//            
//        }
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
        
        self.rent = indexPath.row;//租金条件：刚好对应(0表示全部 1=0--1500 2= 1500--2500  3=2500--4000 4=4000--5500 5=5500--7000 6=7000 以上)
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
        self.rentalTyoe = indexPath.row;//租赁方式条件：刚好对应(0表示不限 1=整租2=合租)
        switch (self.rentalTyoe) {//租赁方式条件改变，户型选择也要改变
            case 0:
                self.moreArr = @[@{@"typeArr":@[@"不限"],@"item":@"户型"},@{@"typeArr":@[@"东",@"南",@"西",@"北",@"南北"],@"item":@"朝向"}];
                break;
            case 1:
                self.moreArr = @[@{@"typeArr":@[@"1室",@"2室",@"3室",@"4室",@"4室以上"],@"item":@"户型"},@{@"typeArr":@[@"东",@"南",@"西",@"北",@"南北"],@"item":@"朝向"}];
                break;
            case 2:
                self.moreArr = @[@{@"typeArr":@[@"主卧",@"次卧",@"隔断"],@"item":@"户型"},@{@"typeArr":@[@"东",@"南",@"西",@"北",@"南北"],@"item":@"朝向"}];
                break;
            default:
                break;
        }
        [self.moreTableView reloadData];//更换了数据源需要刷新数据
        YJHousePriceTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.typeBtn setTitle:cell.price forState:UIControlStateNormal];
    }
    start = 0;
    [self loadData];//根据条件筛选
    if (tableView == self.tableView) {//匹配的房源cell
        YJHouseDetailVC *detailVc = [[YJHouseDetailVC alloc]init];
        YJHouseListTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        detailVc.info_id = cell.model.info_id;
        [self.navigationController pushViewController:detailVc animated:true];
    }
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
