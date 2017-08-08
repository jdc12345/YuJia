//
//  YJRentalHouseVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRentalHouseVC.h"
#import "YJBackView.h"
#import "UILabel+Addition.h"
#import "YJSelectView.h"
#import "YJRentPersonInfoTVCell.h"
#import "YJPhotoFlowLayout.h"
#import "YJPhotoAddBtnCollectionViewCell.h"
#import <HUImagePickerViewController.h>
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import <AFNetworking.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YJPostHouseVillageModel.h"

static NSString* tableCell = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJRentalHouseVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AMapSearchDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)YJBackView *backView;
@property(nonatomic,weak)YJSelectView *selectView;
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,weak)UIButton *allBtn;
@property(nonatomic,weak)UIButton *shareBtn;
@property(nonatomic,weak)UIView *line2;
@property(nonatomic,weak)UIView *shareView;
@property(nonatomic,weak)UIButton *roomType;//合租类型的户型选择Btn
@property (nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *coverView;
@property(nonatomic,weak)UIPickerView *onePickerView;
@property(nonatomic,strong)NSArray *oneArr;
@property(nonatomic,strong)NSDictionary *areaDic;
@property(nonatomic,strong)NSArray *oneLevelArr;
@property(nonatomic,strong)NSMutableArray *twoLevelArr;//区域选择pickerview二级数据
@property(nonatomic,strong)NSMutableArray *threeLevelArr;//区域选择pickerview三级级数据
@property(nonatomic,strong)NSString *oneLevelArea;
@property(nonatomic,strong)NSString *twoLevelArea;
@property(nonatomic,strong)NSString *threeLevelArea;
@property(nonatomic,strong)NSString *areaCode;//乡镇一级没有编码，直接传名字
@property(nonatomic,strong)NSString *codeUpperLevel;//县级市，县，区一级编码
@property(nonatomic,strong)NSString *codeUpperTwo;//市一级编码
@property(nonatomic,strong)NSArray *yards;//选中城市对应的小区
@property(nonatomic,assign)NSInteger pickFlag;
@property(nonatomic,weak)UIToolbar * topView;
@property (nonatomic, strong)NSString *houseAllocation;//房屋配置
@property(nonatomic,weak)UILabel *noticeLabel;//本月可发布房源label
@property(nonatomic,assign)NSInteger number;//本月已发布房源次数

@property (nonatomic, strong) AMapSearchAPI *search;//搜索实体类
@property (nonatomic, copy)   AMapGeoPoint *location;//中心点坐标。
@property (nonatomic, strong)   NSString *name;//根据名称进行行政区划数据搜索的名称
@property (nonatomic, assign)   BOOL isExchangeCity;//是否更换了一级城市。
@end

@implementation YJRentalHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.title = @"租房信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
    [self loadPostLimiteNumber];
    //设置行政区划查询参数并发起行政区划查询
    self.isExchangeCity = true;
//    self.areaDic = @{@"保定市":@[@"涿州市",@"易县",@"固安市"],@"北京市":@[@"顺义区",@"海淀区",@"崇文区"]};
    self.oneLevelArr = @[@"保定市",@"北京市"];
//    self.twoLevelArr = self.areaDic[@"北京市"];
    self.search = [[AMapSearchAPI alloc] init];//实例化搜索对象
    self.search.delegate = self;
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
//    if ([cityName isEqualToString:@"保定市"]) {
//        dist.keywords = @"0312";
//    }else if ([cityName isEqualToString:@"北京市"]){
//        dist.keywords = @"110100";
//    }
    dist.keywords = @"0312";
    dist.requireExtension = YES;
    [self.search AMapDistrictSearch:dist];
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
        self.threeLevelArr = [NSMutableArray array];//此时三级数据源是空的
        //        NSLog(@"%@,name:%@ 下级行政区域数：%ld ///返回数目%ld",dist.level,dist.name,dist.districts.count,response.count);
        if (self.isExchangeCity) {//改变了城市一级区域才要更新secTableview数据源
//            self.twoLevelArr = [NSMutableArray arrayWithObject:dist];//第二个数组第一个元素
            self.twoLevelArr = [NSMutableArray array];
            // sub(二级)
            for (AMapDistrict *subdist in dist.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
            {
                //                NSLog(@"区域编号：%@,区域名字：%@ 下级行政区域数：%ld",subdist.adcode,subdist.name,subdist.districts.count);
                [self.twoLevelArr addObject:subdist];//第二个数组的第一个元素之后元素
                
            }
            [self.onePickerView reloadComponent:1];
            self.isExchangeCity = false;//每次查询之后必须设为false，只有在改变了一级城市之后才会改为true
            
        }else{//两种执行情况：1.执行更新secTableview数据源之后，选取第一个下级行政区域数据源作为thirdTableView数据源 2.点击了secTableview的cell需要更新对应的thirdTableView数据源
            self.threeLevelArr = [NSMutableArray arrayWithObject:dist];//第三个数组第一个元素
            // sub(三级)
            for (AMapDistrict *subdist in dist.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
            {
                //                NSLog(@"区域编号：%@,区域名字：%@ 下级行政区域数：%ld",subdist.adcode,subdist.name,subdist.districts.count);
                [self.threeLevelArr addObject:subdist];//第三个数组的第一个元素之后元素
            }
        }
        [self.onePickerView reloadComponent:2];
//        self.firArr = @[@{@"secArr":@[@"不限",@"1000米内",@"1500米内",@"2000米内"],@"name":@"附近"},@{@"secArr":self.secArr,@"name":@"区域"}];
//        self.tableHeight = 0;
//        for (int i=0; i<self.firArr.count; i++) {
//            NSArray *secArr = self.firArr[i][@"secArr"];
//            self.tableHeight = self.tableHeight<(secArr.count*45*kiphone6)?(secArr.count*45*kiphone6):self.tableHeight;//取出最大值作为区域按钮下tableview所在背景的高度
//        }
//        self.tableHeight = self.tableHeight<(self.thirdArr.count*45*kiphone6)?(self.thirdArr.count*45*kiphone6):self.tableHeight;//取出最大值作为区域按钮下tableview所在背景的高度
//        self.tableHeight = self.tableHeight>(kScreenH-88.5*kiphone6-64*kiphone6)?(kScreenH-88.5*kiphone6-64*kiphone6):self.tableHeight;//如果超出屏幕可视区域需要把可视区域的高度作为区域按钮下tableview所在背景的高度，否则有可能无法完全scrollw整个tableview
        break;//大for循环只执行一次
    }
    
}
//当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [SVProgressHUD showErrorWithStatus:error.description];
}
-(void)loadPostLimiteNumber{
//    http://192.168.1.55:8080/smarthome/mobileapi/rental/findNumber.do?token=C4D5B4E19A6D642DAEB38130C7D8A68A 带number的借口不能发起请求？？？
//    http://192.168.1.55:8080/smarthome/mobileapi/rental/findcount.do?token=C4D5B4E19A6D642DAEB38130C7D8A68A
//    [SVProgressHUD show];// 动画开始
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/findcount.do?token=%@",mPrefixUrl,mDefineToken1];
    
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //            [SVProgressHUD dismiss];// 动画结束
        
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *number = responseObject[@"number"];
            self.number = [number integerValue];
            if (self.number<8) {
                self.noticeLabel.text = [NSString stringWithFormat:@"您本月可发帖8条，当前还可以免费发帖%ld条",8-self.number];
            }else{
                self.noticeLabel.text = @"您本月可发帖8条，当前免费发帖次数已用完";
            }
        }else{
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.description);
        return ;
    }]; 
}
- (void)setupUI {
    self.flag = 1;
        //
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    YJBackView *backView = [[YJBackView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1100)];
    [scrollView addSubview:backView];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [UILabel labelWithText:@"您本月可发帖8条" andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:14];
    [backView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(backView.mas_top).offset(22.5*kiphone6);
    }];//
    self.noticeLabel = noticeLabel;
    UIView *grayView1 = [[UIView alloc]init];
    grayView1.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [backView addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(45*kiphone6);
        make.height.offset(5*kiphone6);
    }];//
    UILabel *leaseLabel = [UILabel labelWithText:@"出租方式" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];
    [backView addSubview:leaseLabel];
    [leaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noticeLabel);
        make.centerY.equalTo(grayView1.mas_bottom).offset(27.5*kiphone6);
    }];//
    UIButton *allRentBtn = [[UIButton alloc]init];
    allRentBtn.tag = 101;
    [allRentBtn setImage:[UIImage imageNamed:@"type_Choice"] forState:UIControlStateNormal];
    [allRentBtn setImage:[UIImage imageNamed:@"type_Choiced"] forState:UIControlStateSelected];
    [allRentBtn setTitle:@"整租" forState:UIControlStateNormal];
    [allRentBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    allRentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:allRentBtn];
    [allRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leaseLabel);
        make.left.equalTo(leaseLabel.mas_right).offset(15*kiphone6);
    }];
    UIButton *shareRentBtn = [[UIButton alloc]init];
    shareRentBtn.tag = 102;
    [shareRentBtn setImage:[UIImage imageNamed:@"type_Choice"] forState:UIControlStateNormal];
    [shareRentBtn setImage:[UIImage imageNamed:@"type_Choiced"] forState:UIControlStateSelected];
    [shareRentBtn setTitle:@"合租" forState:UIControlStateNormal];
    [shareRentBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    shareRentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:shareRentBtn];
    [shareRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leaseLabel);
        make.left.equalTo(allRentBtn.mas_right).offset(15*kiphone6);
    }];
    [allRentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5*kiphone6, 0.0, 0.0)];
    [shareRentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5*kiphone6, 0.0, 0.0)];
    self.allBtn = allRentBtn;
    self.shareBtn = shareRentBtn;
    [shareRentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allRentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];//
    UIView *grayView2 = [[UIView alloc]init];
    grayView2.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [backView addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(grayView1.mas_bottom).offset(55*kiphone6);
        make.height.offset(5*kiphone6);
    }];//
        //拿出xib视图
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"YJSelectView" owner:nil options:nil];
//    UIView *appview=[apparray firstObject];
        YJSelectView  *selectView=[apparray firstObject];
    //加载视图
        [backView addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(grayView2.mas_bottom);
            make.left.right.offset(0);
            make.height.offset(460);
        }];
        [selectView layoutIfNeeded];
        UIView *line2=(UIView *)[selectView viewWithTag:13];
        self.line2 = line2;
    self.selectView = selectView;
    [selectView.directionBtn addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    [selectView.areaBtn addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *payType=(UIButton *)[selectView viewWithTag:24];
    [payType addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *villageBtn=(UIButton *)[selectView viewWithTag:189];
    [villageBtn addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    //房屋配置按钮点击事件

    //添加大tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [backView addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(selectView.mas_bottom);
        make.height.offset(450);
    }];
    [tableView registerClass:[YJRentPersonInfoTVCell class] forCellReuseIdentifier:tableCell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = 55;
//    [backView layoutSubviews];CGRectGetMaxY(tableView.frame)
    [tableView layoutIfNeeded];
    scrollView.contentSize = CGSizeMake(kScreenW, 1100);
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(submitAddress:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    tableView.tableFooterView = footerView;

}
-(void)pickerView:(UIButton*)sender{
    if (sender.tag==101) {
        self.pickFlag = 101;
        if (!self.oneLevelArea) {//初次显示暂定显示保定市
            self.oneLevelArea = @"保定市";
        }
//        self.twoLevelArr = [NSMutableArray array];
        self.threeLevelArr = [NSMutableArray array];
        if ([self.oneLevelArea isEqualToString:@"保定市"]) {
            [self.onePickerView selectRow:0 inComponent:0 animated:YES];
        }else if ([self.oneLevelArea isEqualToString:@"北京市"]){
            [self.onePickerView selectRow:1 inComponent:0 animated:YES];
        }
    }else if (sender.tag==102){
        self.pickFlag = 102;
        self.oneArr = @[@"东",@"南",@"西",@"北",@"东西",@"南北"];
    }else if (sender.tag==103){
        self.pickFlag = 103;
        self.oneArr = @[@"主卧",@"次卧",@"隔断"];
    }else if (sender.tag==24){
        self.pickFlag = 24;
        self.oneArr = @[@"押一付一",@"押一付三",@"半年付",@"年付"];
    }
    if (sender.tag==189){
        self.pickFlag = 189;
        if (!self.areaCode) {
            [SVProgressHUD showErrorWithStatus:@"请选择你要发布房源所在的地区"];
            return;
        }
//    http://localhost:8080/smarthome/mobilepub/residentialQuarters/findResidentialQuarters.do?areaCode=130681
//        参数：       参数名    参数类型    备注
//        areaCode    String      城市编码
//        返回值：
//        propertyId    Long      物业单位ID
//        id      Long      该条小区记录ID
//        areaCode    String      城市编码
//        city    String      城市名称
//        rname    String      小区名称

        //    [SVProgressHUD show];// 动画开始
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobilepub/residentialQuarters/findResidentialQuarters.do?areaCode=%@",mPrefixUrl,self.areaCode];
         urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            //            [SVProgressHUD dismiss];// 动画结束
            
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJPostHouseVillageModel *infoModel = [YJPostHouseVillageModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                if (mArr.count==0) {
                    [SVProgressHUD showInfoWithStatus:@"你所选地区暂未开放该功能"];
                    return ;
                }
                self.oneArr = mArr;
                [self addOnePicker];
                [self.onePickerView reloadAllComponents];
            }else{
                [SVProgressHUD showInfoWithStatus:@"你所选地区暂未开放该功能"];
                return;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.description);
            return ;
        }]; 

    }else{
        [self addOnePicker];
    }
}
-(void)addOnePicker{
    if (self.coverView) {
        
        [self.onePickerView reloadAllComponents];
        [self.view endEditing:true];
        self.topView.hidden = false;
        self.onePickerView.hidden = false;
        self.coverView.hidden = false;
    }else{
        //大蒙布View
        UIView *coverView = [[UIView alloc]init];
        coverView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        coverView.alpha = 0.3;
        [self.view addSubview:coverView];
        self.coverView = coverView;
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        coverView.userInteractionEnabled = YES;
        //添加tap手势：
        //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        //    [backView addGestureRecognizer:tapGesture];
        
        UIPickerView *pickView = [[UIPickerView alloc]init];
        [self.view addSubview:pickView];
        [self.view bringSubviewToFront:pickView];
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(200*kiphone6);
        }];
        pickView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.showsSelectionIndicator = YES;
        self.onePickerView = pickView;
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 5, 50, 25);
        [btn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
        [topView setItems:buttonsArray];
        [self.view addSubview:topView];
        [self.view bringSubviewToFront:topView];
        self.topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.equalTo(pickView.mas_top);
            //            make.height.offset(200*kiphone6);
        }];
        
    }
  
}
#pragma mark - pickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.pickFlag == 101) {
        return 3;
    }
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickFlag == 101) {
        if (component==0) {
            return self.oneLevelArr.count;
        }if (component==1) {
            return self.twoLevelArr.count;
        }if (component==2) {
            return self.threeLevelArr.count;
        }
    }
    return self.oneArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    if (component==0) {
//        return pickerView.bounds.size.width*0.5;
//    }
    if (self.pickFlag == 101) {
        return pickerView.bounds.size.width*0.33;
    }
    return 160;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0*kiphone6;
    
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickFlag==101) {
        
        if (component==0) {
            self.isExchangeCity = true;
                //把点击区域的acode改变，并发起行政区域查询
                //设置行政区划查询参数并发起行政区划查询
            AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
                if ([self.oneLevelArr[row] isEqualToString:@"保定市"]) {
                    dist.keywords = @"0312";
                    self.codeUpperTwo = @"0312";
                }else if ([self.oneLevelArr[row] isEqualToString:@"北京市"]){
                    dist.keywords = @"110100";
                    self.codeUpperTwo = @"110100";
                }
            dist.requireExtension = YES;
            [self.search AMapDistrictSearch:dist];
            self.oneLevelArea = self.oneLevelArr[row];
            self.twoLevelArea = @"";//改变了一级城市，二三级都要从新选择,同时改变的还有区域编码
            self.codeUpperLevel = @"";
            self.threeLevelArea = @"";
            self.areaCode = @"";
        }else if (component==1) {
            AMapDistrict *cellDist = self.twoLevelArr[row];
            //把点击区域的acode改变，并发起行政区域查询
            //设置行政区划查询参数并发起行政区划查询
            AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
            dist.requireExtension = YES;
            dist.keywords = cellDist.adcode;
            [self.search AMapDistrictSearch:dist];
            self.twoLevelArea = cellDist.name;
            self.codeUpperLevel = cellDist.adcode;
            self.threeLevelArea = @"";//改变了二级城市，三级要从新选择,同时改变的还有区域编码
            self.areaCode = @"";
        }
        else if (component==2) {
            AMapDistrict *cellDist = self.threeLevelArr[row];
            if (row==0) {
                self.threeLevelArea = @"城区";
                self.areaCode = cellDist.adcode;//选中的地区编码,必须选到第三级
            }else{
                self.threeLevelArea = cellDist.name;
                self.areaCode = cellDist.name;//选中的地区编码,必须选到第三级
            }
            
        }
    NSString *allArea = [NSString stringWithFormat:@"%@%@%@",self.oneLevelArea,self.twoLevelArea,self.threeLevelArea];
        [self.selectView.areaBtn setTitle:allArea forState:UIControlStateNormal];
        [self.selectView.villageBtn setTitle:@"请选择所在小区" forState:UIControlStateNormal];
    }else if (self.pickFlag==102) {
        [self.selectView.directionBtn setTitle:[NSString stringWithFormat:@"%@",self.oneArr[row]] forState:UIControlStateNormal];
    }else if (self.pickFlag==103) {
        UIButton *roomType=(UIButton *)[self.shareView viewWithTag:103];
        [roomType setTitle:[NSString stringWithFormat:@"%@",self.oneArr[row]] forState:UIControlStateNormal];
    }else if (self.pickFlag==24) {
        UIButton *payType=(UIButton *)[self.selectView viewWithTag:24];
        [payType setTitle:[NSString stringWithFormat:@"%@",self.oneArr[row]] forState:UIControlStateNormal];
    }else if (self.pickFlag==189) {
        YJPostHouseVillageModel *infoModel = self.oneArr[row];
        [self.selectView.villageBtn setTitle:infoModel.rname forState:UIControlStateNormal];
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickFlag==101) {
        
        if (component==0) {
            return self.oneLevelArr[row];
        }else if (component==1) {
            AMapDistrict *cellDist = self.twoLevelArr[row];
            return cellDist.name;
            
        }
        else if (component==2) {
            AMapDistrict *cellDist = self.threeLevelArr[row];
            if (row==0) {
                return [NSString stringWithFormat:@"%@城区",cellDist.name];
            }
            
            return cellDist.name;
        }
    }
    if (self.pickFlag==189) {
        YJPostHouseVillageModel *infoModel = self.oneArr[row];
        return infoModel.rname;
    }
    return self.oneArr[row];
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
//    if (component == 0) {
//        [label setText:[self.dayArr objectAtIndex:row]];
//        //    }else if (component == 1){
//        //        [label setText:[self.monthArr objectAtIndex:row]];
//    }
//    else if (component == 1){
//        [label setText:[NSString stringWithFormat:@"%@时",self.hourArr[row]]];
//    }
//    else if (component == 2){
//        [label setText:[NSString stringWithFormat:@"%@分",self.minusArr[row]]];
//    }
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    return label;
//}

-(void)resignFirstResponderText {
    self.topView.hidden = true;
    self.onePickerView.hidden = true;
    self.coverView.hidden = true;
    
}
-(void)submitAddress:(UIButton*)sender{

//    47.发布租房信息接口
//localhost:8080/smarthome/mobileapi/rental/PublishRental.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    
//    参数：       参数名    参数类型    备注
//    token         String    令牌
//    rentalTyoe        Integer    出租方式1=整租2=合租
//    cyty        String    城市
//    residentialQuarters     String    小区
//    apartmentLayout       String    户型（格式如：1室1厅1厨1卫，带上单位）
//    housingArea   Integer    面积
//    floor        String    楼层（第几层）
//    floord        String    楼层（共几层）
//    direction       String    朝向
//    houseAllocation      String    房屋配置（格式：电视；冰箱；宽带；分号隔
//    开）
//    rent         Double    租金
//    paymentMethod      String    付款方式
//    contacts       String    联系人姓名
//    telephone       Long      联系人电话
//    areaCode        String    乡镇一级编码
//    codeUpperLevel  String              县级市，县，区一级编码（上一级）
//    codeUpperTwo   String      市一级编码 （上两级）
//    返回值：  返回值名称          返回值类型    备注
//    code           0添加成功-1表示添加失败
//    
//    
//    注：新增areaCode（乡镇一级编码）、codeUpperLevel（县级市，县，区一级编码）、codeUpperTwo（市一级编码）
//    1、上传乡、镇一级编码时需要必传上一级编码和上两级编码
//    2、上传县级市、县、区一级编码时，必需要传市一级编码，下一级编码传“0”
//    3、上传市一级编码时，下一级和下两级编码传“0”
    //此处接提交地址接口！！！！！
    [SVProgressHUD show];// 动画开始
    NSString *cyty = [self.selectView.areaBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//小区所在地区
    NSString *residentialQuarters = [self.selectView.villageBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//小区
    if (residentialQuarters.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你发布房源的小区"];
        return;
    }
    NSString *apartmentLayout = [NSString string];
    if (self.flag==1) {
        apartmentLayout = [NSString stringWithFormat:@"%@室%@厅%@卫",self.selectView.roomField.text,self.selectView.hallField.text,self.selectView.guardsField.text];
        apartmentLayout = [apartmentLayout stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//户型
        
    }else if (self.flag==2){
        apartmentLayout = [self.roomType.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//户型
    }
    if (apartmentLayout.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你发布房源的户型"];
        return;
    }
    NSString *direction = [self.selectView.directionBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//方向
    if (apartmentLayout.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你发布房源的朝向"];
        return;
    }
    NSString *houseAllocation = [NSString string];//房屋配置
    if (self.selectView.tvBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.tvBtn.titleLabel.text];
    }
    if (self.selectView.broadbandBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.broadbandBtn.titleLabel.text];
    }
    if (self.selectView.AirConditioningBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.AirConditioningBtn.titleLabel.text];
    }
    if (self.selectView.waterBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.waterBtn.titleLabel.text];
    }
    if (self.selectView.bedBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.bedBtn.titleLabel.text];
    }
    if (self.selectView.supHeatingBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.supHeatingBtn.titleLabel.text];
    }
    if (self.selectView.washerBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.washerBtn.titleLabel.text];
    }
    if (self.selectView.iceBoxBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.iceBoxBtn.titleLabel.text];
    }
    if (self.selectView.boxBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.boxBtn.titleLabel.text];
    }
    if (self.selectView.sofaBtn.selected) {
        houseAllocation = [NSString stringWithFormat:@"%@；%@",houseAllocation,self.selectView.sofaBtn.titleLabel.text];
    }
     houseAllocation = [houseAllocation stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//房屋配置
    if (houseAllocation.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你发布房源的配置"];
        return;
    }
   NSString *paymentMethod = [self.selectView.conditionBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//房屋配置
    if (paymentMethod.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你发布房源的支付方式"];
        return;
    }
    YJRentPersonInfoTVCell *contactsCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *contacts = [contactsCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//联系人
    if (contacts.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你发布房源的联系人"];
        return;
    }
    YJRentPersonInfoTVCell *telephoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSString *telephone = [telephoneCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//联系电话
    if (telephone.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你发布房源的联系电话"];
        return;
    }
    NSString *areaCode = [self.areaCode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//乡镇一级编码
    NSString *codeUpperLevel = [self.codeUpperLevel stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//县级市，县，区一级编码
    NSString *codeUpperTwo = [self.codeUpperTwo stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//市一级编码
    
    NSString *postUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/PublishRental.do?token=%@&rentalTyoe=%ld&cyty=%@&residentialQuarters=%@&apartmentLayout=%@&housingArea=%@&floor=%@&floord=%@&direction=%@&houseAllocation=%@&rent=%@&paymentMethod=%@&contacts=%@&telephone=%@&areaCode=%@&codeUpperLevel=%@&codeUpperTwo=%@",mPrefixUrl,mDefineToken1,self.flag,cyty,residentialQuarters,apartmentLayout,self.selectView.houseArea.text,self.selectView.floor.text,self.selectView.allFloor.text,direction,houseAllocation,self.selectView.rentMoney.text,paymentMethod,contacts,telephone,areaCode,codeUpperLevel,codeUpperTwo];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:postUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //  图片上传
        for (NSInteger i = 0; i < self.imageArr.count; i ++) {
            UIImage *images = self.imageArr[i];
            NSData *picData = UIImageJPEGRepresentation(images, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
            [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"uploadFile%ld",(long)i] fileName:fileName mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSString *message = responseObject[@"message"];
        [message stringByRemovingPercentEncoding];
        NSLog(@"宝宝头像上传== %@,%@", responseObject,message);
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功!"];
            sender.enabled = true;
            self.number+=1;
            if (self.number<8) {
                self.noticeLabel.text = [NSString stringWithFormat:@"您本月可发帖8条，当前还可以免费发帖%ld条",8-self.number];
            }else{
                self.noticeLabel.text = @"您本月可发帖8条，当前免费发帖次数已用完";
            }
        }else{
            [SVProgressHUD showErrorWithStatus:message];
            sender.enabled = true;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息=====%@", error.description);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"发布失败!"];
        sender.enabled = true;
    }];

 
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 2;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJRentPersonInfoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
    NSArray *arr = @[@"联 系 人",@"联系电话"];
    cell.item = arr[indexPath.row];
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 354*kiphone6, 5*kiphone6)];
    if (section == 0) {
        headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        UILabel *itemLabel = [UILabel labelWithText:@"添加照片" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];
        [headerView addSubview:itemLabel];
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(15);
        }];
        //photoCollectionView
        UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJPhotoFlowLayout alloc]init]];
        [headerView addSubview:photoCollectionView];
        self.collectionView = photoCollectionView;
        photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemLabel.mas_bottom).offset(15);
            make.left.bottom.offset(0);
            make.width.offset(216*kiphone6);
        }];
        photoCollectionView.dataSource = self;
        photoCollectionView.delegate = self;
        // 注册单元格
        [photoCollectionView registerClass:[YJPhotoAddBtnCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
        [photoCollectionView registerClass:[YJPhotoDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
        photoCollectionView.showsHorizontalScrollIndicator = false;
        photoCollectionView.showsVerticalScrollIndicator = false;

        
    }else{
        headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.imageArr.count<4) {
           return 128;
        }
        return 198;
    }
    return 5;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArr.count<8&&self.imageArr.count>0) {
        return self.imageArr.count+1;
    }else if(self.imageArr.count==8){
        return self.imageArr.count;
    }else{
        return 1;
    }
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.imageArr.count==0) {
        // 去缓存池找
        YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
        cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
            HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
            picker.delegate = self;
            picker.maxAllowedCount = 8-self.imageArr.count;
            picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
            [self presentViewController:picker animated:YES completion:nil];
        };
        return cell;
    }else if (self.imageArr.count<8&&self.imageArr.count>0){
        if (indexPath.row==self.imageArr.count) {
            // 去缓存池找
            YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
            cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                picker.delegate = self;
                picker.maxAllowedCount = 8-self.imageArr.count;
                picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                [self presentViewController:picker animated:YES completion:nil];
            };
            return cell;
        }else{
            // 去缓存池找
            YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
            cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                [self.imageArr removeObjectAtIndex:indexPath.row];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//                self.titleView.text = self.content;//刷新后保存报修内容
                [self.collectionView reloadData];
            };
            cell.photo = self.imageArr[indexPath.row];
            return cell;
        }
    }
    // 去缓存池找
    YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
        [self.imageArr removeObjectAtIndex:indexPath.row];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//        self.titleView.text = self.content;//刷新后保存报修内容
        [self.collectionView reloadData];
    };
    cell.photo = self.imageArr[indexPath.row];
    return cell;
}

//当选择一张图片后进入这里
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    //    self.imageArr = info[kHUImagePickerThumbnailImage];//缩小图
    NSMutableArray *arr = info[kHUImagePickerOriginalImage];//源图
    for (int i = 0; i<arr.count; i++) {
        [self.imageArr addObject:arr[i]];
    }
    //    self.imageArr = [NSMutableArray arrayWithArray:arr];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    self.titleView.text = self.content;//刷新后保存报修内容
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJPhotoDisplayCollectionViewCell *cell = (YJPhotoDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.imageArr atIndex:indexPath.row];
    
}
-(NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}

//- (void)keyboardWillChangeFrame:(NSNotification *)noti{
//    
//    //从userInfo里面取出来键盘最终的位置
//    NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect rect = [rectValue CGRectValue];
//    [self.fieldBackView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_top).offset(rect.origin.y);
//    }];
//    
//}

-(void)btnClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        if (sender.tag == 101) {
            self.flag = 1;
            self.shareBtn.selected = false;
            self.shareView.hidden = true;
        }else{
            self.flag = 2;
            self.allBtn.selected = false;
            if (self.shareView) {
                self.shareView.hidden = false;
            }else{
                //拿出xib视图
                NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"YJShareRentView" owner:nil options:nil];
                UIView *shareView=[apparray firstObject];
                //加载视图
                [self.backView addSubview:shareView];
                [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.line2.mas_bottom);
                    make.left.right.offset(0);
                    make.height.offset(55);
                }];
                self.shareView = shareView;
 
            }
            UIButton *roomType = (UIButton *)[self.shareView viewWithTag:103];
            self.roomType = roomType;
            [roomType addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
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
