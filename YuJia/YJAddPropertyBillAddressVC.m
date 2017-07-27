//
//  YJAddPropertyBillAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddPropertyBillAddressVC.h"
#import "YJCityTableViewCell.h"
#import "YJBillInfoTableViewCell.h"
#import "YJPropertyBillVC.h"
#import "YJLifepaymentVC.h"
#import "YJCityDetailModel.h"
#import "YJAreaDetailModel.h"
//改
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

static NSString* cityCellid = @"city_cell";
static NSString* detailInfoCellid = @"detailInfo_cell";
@interface YJAddPropertyBillAddressVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,AMapSearchDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIView *selectView;
@property(nonatomic,weak)UIView *selectAreaView;
@property(nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSString *yardName;
@property(nonatomic, strong)NSString *areaCode;
@property(nonatomic, strong)NSString *yardid;
//改
@property(nonatomic, strong)NSArray *firCitys;//可选城市1
@property(nonatomic, strong)NSArray *secCitys;//可选城市2
@property(nonatomic, strong)NSArray *bjCitys;//北京下级行政区域
@property(nonatomic, strong)NSArray *bdCitys;//保定下级行政区域
@property(nonatomic, strong)NSArray *yards;//可选小区
@property(nonatomic,weak)UIView *backGrayView;//时间选择器半透明背景
@property(nonatomic,weak)UIToolbar * topView;//时间选择器工具栏
@property(nonatomic,weak)UIPickerView *cityPickerView;//选择城市的picker
@property(nonatomic,weak)UIPickerView *yardPickerView;//选择小区的picker
//@property (nonatomic, strong) AMapSearchAPI *search;//搜索实体类 (用高德本地请求)
//@property (nonatomic, copy)   AMapGeoPoint *location;//中心点坐标。
//@property (nonatomic, strong)   NSString *name;//根据名称进行行政区划数据搜索的名称
//@property (nonatomic, assign)   BOOL isExchangeCity;//是否更换了城市。

@end

@implementation YJAddPropertyBillAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加地址";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
    
//    //    -------------------------(用高德本地请求)
//    [AMapServices sharedServices].apiKey =@"380748c857866280e77da5bb813e13c5";
//    //设置行政区划查询参数并发起行政区划查询
//    self.search = [[AMapSearchAPI alloc] init];//实例化搜索对象
//    self.search.delegate = self;
    
}
//获取城市列表
-(void)loadCityData{
    http://192.168.1.55:8080/smarthome/mobilepub/baseArea/findList.do 获取城市列表
    [SVProgressHUD show];// 动画开始
    NSString *getCityUrlStr = [NSString stringWithFormat:@"%@/mobilepub/baseArea/findList.do",mPrefixUrl];
    [[HttpClient defaultClient]requestWithPath:getCityUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *bigCitysDic = responseObject[@"baseAreaList"];
            self.firCitys = bigCitysDic.allKeys;//获取城市picker的第一列数据源
            [self.cityPickerView reloadComponent:0];//更新城市picker的第一列数据源
            NSArray *bjArr = bigCitysDic[@"北京市"];
            NSMutableArray *bjCitys = [NSMutableArray array];
            for (NSDictionary *dic in bjArr) {
                YJCityDetailModel *infoModel = [YJCityDetailModel mj_objectWithKeyValues:dic];
                [bjCitys addObject:infoModel];
            }
            self.bjCitys = bjCitys;//解析取的北京城市行政区域
            NSArray *bdArr = bigCitysDic[@"保定市"];
            NSMutableArray *bdCitys = [NSMutableArray array];
            for (NSDictionary *dic in bdArr) {
                YJCityDetailModel *infoModel = [YJCityDetailModel mj_objectWithKeyValues:dic];
                [bdCitys addObject:infoModel];
            }
            self.bdCitys = bdCitys;//解析取的保定城市行政区域
            if ([self.firCitys[0] isEqualToString:@"保定市"]) {//初始化城市picker的第二列数据
                self.secCitys = self.bdCitys;
            }else if ([self.firCitys[0] isEqualToString:@"北京市"]) {
                self.secCitys = self.bjCitys;
            }
            if (self.firCitys.count>0) {
                [self setBackView];
                UIPickerView *pickView = [[UIPickerView alloc]init];
                [self.view.window addSubview:pickView];
                pickView.backgroundColor = [UIColor whiteColor];
                pickView.dataSource = self;
                pickView.delegate = self;
                pickView.showsSelectionIndicator = YES;
                self.cityPickerView = pickView;
                [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.offset(0);
                    make.height.offset(122*kiphone6);
                }];
            }else{
                [self resignFirstResponderText];//去掉透明view
            }
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

}
//获取小区列表
-(void)loadAreaData{
http://192.168.1.55:8080/smarthome/mobilepub/residentialQuarters/findAll.do?AreaCode=130681 获取小区列表
    [SVProgressHUD show];// 动画开始
    if (self.areaCode == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
    NSString *getAreaUrlStr = [NSString stringWithFormat:@"%@/mobilepub/residentialQuarters/findAll.do?AreaCode=%@",mPrefixUrl,self.areaCode];
    [[HttpClient defaultClient]requestWithPath:getAreaUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJAreaDetailModel *infoModel = [YJAreaDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
//            [self selectViewWithAreaNames:mArr and:20];
            self.yards = mArr;
            if (mArr.count>0) {
                [self setBackView];
                UIPickerView *pickView = [[UIPickerView alloc]init];
                [self.view.window addSubview:pickView];
                pickView.backgroundColor = [UIColor whiteColor];
                pickView.dataSource = self;
                pickView.delegate = self;
                pickView.showsSelectionIndicator = YES;
                self.yardPickerView = pickView;
                [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.offset(0);
                    make.height.offset(122*kiphone6);
                }];
            }else{
                [self resignFirstResponderText];//去掉透明view
                [SVProgressHUD showInfoWithStatus:@"本地区暂未提供该服务"];
            }
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
    
}
//大蒙布View
-(void)setBackView{
    //大蒙布View
    if (!self.backGrayView) {
        UIView *backGrayView = [[UIView alloc]init];
        self.backGrayView = backGrayView;
        backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        backGrayView.alpha = 0.2;
        [self.view.window addSubview:backGrayView];
        [backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        backGrayView.userInteractionEnabled = YES;
        //添加tap手势：
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        [backGrayView addGestureRecognizer:tapGesture];
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 39*kiphone6)];
        topView.backgroundColor = [UIColor colorWithHexString:@"#e7e7e7"];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 15;
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(2, 5, 50, 25);
        [closeBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
        UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //        UIButton *middelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        middelBtn.frame = CGRectMake(2, 5, 75, 25);
        //        //        [middelBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        //        [middelBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        //        [middelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        //        UIBarButtonItem *titleBtn = [[UIBarButtonItem alloc]initWithCustomView:middelBtn];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 5, 50, 25);
        [btn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
        UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer1.width = 15;
        NSArray * buttonsArray = [NSArray arrayWithObjects:negativeSpacer,cancleBtn,btnSpace1,btnSpace,doneBtn,negativeSpacer1,nil];
        [topView setItems:buttonsArray];
        [self.view.window addSubview:topView];
        [self.view.window bringSubviewToFront:topView];
        self.topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.offset(-122*kiphone6);
            make.height.offset(39*kiphone6);
        }];
        
    }
}
- (void)setupUI {
    NSMutableArray* rightItemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    [rightItemArr addObject:negativeSpacer];//修正按钮离屏幕边缘位置的UIBarButtonItem应在按钮的前边加入数组
    UIButton *postAddressBtn = [[UIButton alloc]init];
    [postAddressBtn setTitle:@"完成" forState:UIControlStateNormal];
    postAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [postAddressBtn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    [postAddressBtn sizeToFit];
    [postAddressBtn addTarget:self action:@selector(submitAddress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:postAddressBtn];
    [rightItemArr addObject:rightBarItem];
    self.navigationItem.rightBarButtonItems = rightItemArr;//导航栏右侧按钮
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.bottom.left.right.offset(0);
    }];
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCityTableViewCell class] forCellReuseIdentifier:cityCellid];
    [tableView registerClass:[YJBillInfoTableViewCell class] forCellReuseIdentifier:detailInfoCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
  
}
- (void)submitAddress{
    NSString *city = [self.cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (!self.cityName) {
        [SVProgressHUD showInfoWithStatus:@"请选择你所在的城市"];
        return;
    }
    NSString *yard = [self.yardName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (!self.yardName) {
        [SVProgressHUD showInfoWithStatus:@"请选择你所在的小区"];
        return;
    }
    YJBillInfoTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (nameCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写业主姓名"];
        return;
    }
    NSString *name = [nameCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//    NSString *telNum = [telCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *buildCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (buildCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写小区楼号"];
        return;
    }
    NSString *buildNumber = [NSString stringWithFormat:@"%@",buildCell.contentField.text];
    NSString *buildingNumber = [buildNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *floorCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if (floorCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你所在的楼层"];
        return;
    }
     NSString *floorNumber = [NSString stringWithFormat:@"%@",floorCell.contentField.text];
    NSString *floor = [floorNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *unitNumberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (unitNumberCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你所在的单元"];
        return;
    }
    NSString *unit = [NSString stringWithFormat:@"%@",unitNumberCell.contentField.text];
    NSString *unitNumber = [unit stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *roomCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    if (roomCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你所在的房间号"];
        return;
    }
    NSString *room = [NSString stringWithFormat:@"%@",roomCell.contentField.text];
    NSString *roomNumber = [room stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
http://localhost:8080/smarthome/mobileapi/family/addAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC
//    &city=%E5%8C%97%E4%BA%AC
//    &yard=%E5%90%8D%E6%B5%81%E4%B8%80%E5%93%81
//    &yarid=1&ownerName=%E6%B5%81%E5%B0%8F%E8%99%BE
//    &ownerTelephone=18782918821&buildingNumber=1%E5%8F%B7%E6%A5%BC
//    &unitNumber=5
//    &floor=3
//    &roomNumber=301
    //此处接提交地址接口！！！！！
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@/mobileapi/family/addAddress.do?token=%@&city=%@&yard=%@&yardid=%@&ownerName=%@&ownertelephone=%@&buildingNumber=%@&unitNumber=%@&floor=%@&roomNumber=%@&areaCode=%@",mPrefixUrl,mDefineToken1,city,yard,self.yardid,name,telCell.contentField.text,buildingNumber,unitNumber,floor,roomNumber,self.areaCode];
    [[HttpClient defaultClient]requestWithPath:reportUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YJLifepaymentVC class]]) {
                    YJLifepaymentVC *revise =(YJLifepaymentVC *)controller;
                    //            revise.clickBtnBlock(cell.textLabel.text);
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

   
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *itemArr = @[@"城       市",@"小       区",@"业主姓名",@"手  机  号",@"小区楼号",@"楼       层",@"单       元",@"房       号"];
    if (indexPath.row<2) {
        YJCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellid forIndexPath:indexPath];
        cell.item = itemArr[indexPath.row];
        return cell;
    }else{
        YJBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellid forIndexPath:indexPath];
        if (indexPath.row>2) {
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            [self addToolSender:cell.contentField];
        }
        cell.item = itemArr[indexPath.row];
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row==0) {
        if (!self.firCitys) {
            [self loadCityData];
        }else{
            if ([self.firCitys[0] isEqualToString:@"保定市"]) {//初始化城市picker的第二列数据
                self.secCitys = self.bdCitys;
            }else if ([self.firCitys[0] isEqualToString:@"北京市"]) {
                self.secCitys = self.bjCitys;
            }
            [self setBackView];
            UIPickerView *pickView = [[UIPickerView alloc]init];
            [self.view.window addSubview:pickView];
            pickView.backgroundColor = [UIColor whiteColor];
            pickView.dataSource = self;
            pickView.delegate = self;
            pickView.showsSelectionIndicator = YES;
            self.cityPickerView = pickView;
            [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.right.bottom.offset(0);
              make.height.offset(122*kiphone6);
            }];
        }
        
        //            //城市第一列数据(用高德本地请求)
        //            self.firCitys = [NSArray arrayWithObjects:@"北京市",@"保定市", nil];
        //            self.secCitys = [NSMutableArray arrayWithObjects:@"东城区",@"西城区",@"朝阳区",@"丰台区",@"石景山区",@"海淀区",@"门头沟区",@"房山区",@"通州区",@"顺义区",@"昌平区",@"大兴区",@"怀柔区",@"平谷区",@"密云区",@"延庆区",nil];
        //            UIPickerView *pickView = [[UIPickerView alloc]init];
        //            [self.view.window addSubview:pickView];
        //            pickView.backgroundColor = [UIColor whiteColor];
        //            pickView.dataSource = self;
        //            pickView.delegate = self;
        //            pickView.showsSelectionIndicator = YES;
        //            self.cityPickerView = pickView;
        //            [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.left.right.bottom.offset(0);
        //                make.height.offset(122*kiphone6);
        //            }];
        //            设置初始默认值
        
    }else if (indexPath.row==1){
        [self loadAreaData];//根据选取的城市确定小区
        //        self.yards = [NSArray arrayWithObjects:@"名流一品1",@"名流一品2",@"名流一品3",@"名流一品4",nil];(用高德本地请求)
        //        UIPickerView *pickView = [[UIPickerView alloc]init];
        //        [self.view.window addSubview:pickView];
        //        pickView.backgroundColor = [UIColor whiteColor];
        //        pickView.dataSource = self;
        //        pickView.delegate = self;
        //        pickView.showsSelectionIndicator = YES;
        //        self.yardPickerView = pickView;
        //        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.right.bottom.offset(0);
        //            make.height.offset(122*kiphone6);
        //        }];
    }
}
#pragma Mark -- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView==self.cityPickerView) {
      return 2;
    }
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==self.cityPickerView) {
        if (component == 0) {
            return self.firCitys.count;
        }else{
            return self.secCitys.count;
        }

    }else{
        return self.yards.count;
    }
    
    
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (pickerView==self.cityPickerView) {
        return kScreenW*0.5;
    }else{
        return kScreenW;
    }
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40*kiphone6;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==self.cityPickerView) {
        if (component==0) {
            // 数组越界保护
            if (row < self.firCitys.count) {
                YJCityTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.city = self.firCitys[row];
                self.cityName = self.firCitys[row];
                if (row==0) {
                    self.secCitys = self.bdCitys;
                }else if (row==1){
                    self.secCitys = self.bjCitys;
                }
                [pickerView reloadComponent:1];//更新城市picker的第二列数据源
//                AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
//                if ([self.cityName isEqualToString:@"保定市"]) {(用高德本地请求)
//                    dist.keywords = @"0312";
//                }else if ([self.cityName isEqualToString:@"北京市"]){
//                    dist.keywords = @"010";
//                }
//                dist.requireExtension = YES;
//                [self.search AMapDistrictSearch:dist];
            }

        }else if(component==1){
            YJCityTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            YJCityDetailModel *model = self.secCitys[row];
            cell.city = model.areaName;
            self.cityName = model.areaName;
            self.areaCode = model.areaCode;//点击完城市需要更新城还是code，用来请求小区数据
        }
            }else{
                YJCityTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                YJAreaDetailModel *model = self.yards[row];
                cell.city = model.rname;
                self.yardName = model.rname;
                self.yardid = model.info_id;

    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView==self.yearPickerView) {
//        if (row >= self.yearArr.count) {
//            return nil;
//        }else{
//
//            return [self.yearArr objectAtIndex:row];
//        }
//    }else{
//        if (row >= self.monthArr.count) {
//            return nil;
//        }else{
//
//            return [self.monthArr objectAtIndex:row];
//        }
//    }
//
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    if (pickerView==self.cityPickerView) {
        if (component == 0) {
            [label setText:[self.firCitys objectAtIndex:row]];
        }else{
            YJCityDetailModel *model = self.secCitys[row];
            [label setText:model.areaName];
        }
    }
    if (pickerView==self.yardPickerView) {
        
        YJAreaDetailModel *model = self.yards[row];
        [label setText:model.rname];
    }
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:23];
    return label;
}
///* 行政区划数据查询回调. */
//- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
//{
//    
//    if (response == nil)
//    {
//        return;
//    }
//    //当前区域数据
//    NSMutableArray *citys = [NSMutableArray array];//第二个数组
//
//    //解析response获取行政区划，具体解析见 Demo
//    for (AMapDistrict *dist in response.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
//    {
//        [citys addObject:dist.name];//第二个数组
//        
//    }
//    self.secCitys = citys;
//    [self.cityPickerView reloadComponent:1];
//
//}
////当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
//- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//    [SVProgressHUD showErrorWithStatus:error.description];
//}

//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    //移除view
    [gesture.view removeFromSuperview];
    [self.cityPickerView removeFromSuperview];
    [self.yardPickerView removeFromSuperview];
    [self.topView removeFromSuperview];
}
-(void)resignFirstResponderText {
    [self.view endEditing:true];
    [self.cityPickerView removeFromSuperview];
    [self.yardPickerView removeFromSuperview];
    [self.backGrayView removeFromSuperview];
    [self.topView removeFromSuperview];
    [self.view endEditing:true];
}
-(void)addToolSender:(UITextField*)textField{
    
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
    
    textField.inputAccessoryView = topView;
}
//-(void)resignFirstResponderText {
//    [self.view endEditing:true];
//    
//}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat height = rect.size.height;
    if (height <667.f) {//判断设备型号是6以下情况(此处是因为固定了屏幕方向，其他情况要判定屏幕方向)
        NSIndexPath *index5 = [NSIndexPath indexPathForRow:5 inSection:0];
        NSIndexPath *index6 = [NSIndexPath indexPathForRow:6 inSection:0];
        NSIndexPath *index7 = [NSIndexPath indexPathForRow:7 inSection:0];
        YJBillInfoTableViewCell *cell5 = [self.tableView cellForRowAtIndexPath:index5];
        YJBillInfoTableViewCell *cell6 = [self.tableView cellForRowAtIndexPath:index6];
        YJBillInfoTableViewCell *cell7 = [self.tableView cellForRowAtIndexPath:index7];
        if (cell5.contentField.isFirstResponder||cell6.contentField.isFirstResponder||cell7.contentField.isFirstResponder) {
            //将视图上移计算好的偏移
            [UIView animateWithDuration:duration animations:^{
                self.tableView.frame = CGRectMake(0.0f, -100, self.tableView.frame.size.width, self.tableView.frame.size.height);
            }];
        }
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame = CGRectMake(0, 5*kiphone6, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //注册键盘通知
    [self addNoticeForKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除键盘监听
    //移除键盘监听 直接按照通知名字去移除键盘通知, 这是正确方式
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
