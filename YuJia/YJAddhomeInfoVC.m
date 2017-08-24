//
//  YJAddhomeInfoVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddhomeInfoVC.h"
//#import "YJPropertyBillVC.h"
//#import "YJLifepaymentVC.h"
#import "YJCityDetailModel.h"
#import "YJAreaDetailModel.h"
//改
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YJModifyAddressVC.h"
#import "YJAddHomeAddressPickerTVCell.h"
#import "YJAddHomeAddressTextFieldTVCell.h"
#import "YJPostHouseVillageModel.h"

static NSString* cityCellid = @"city_cell";
static NSString* detailInfoCellid = @"detailInfo_cell";
@interface YJAddhomeInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,AMapSearchDelegate>
@property(nonatomic,weak)UITableView *tableView;
//@property(nonatomic,weak)UIView *selectView;
//@property(nonatomic,weak)UIView *selectAreaView;
//
//@property(nonatomic, strong)NSString *yardid;

@property(nonatomic,weak)UIView *backGrayView;//时间选择器半透明背景
@property(nonatomic,weak)UIToolbar * topView;//时间选择器工具栏
@property (nonatomic, strong) AMapSearchAPI *search;//搜索实体类 (用高德本地请求)
@property (nonatomic, copy)   AMapGeoPoint *location;//中心点坐标。
@property (nonatomic, strong)   NSString *name;//根据名称进行行政区划数据搜索的名称
//@property (nonatomic, assign)   BOOL isExchangeCity;//是否更换了城市。
@property(nonatomic, strong)NSArray *pickerDatas;//可选数据源
@property(nonatomic,weak)UIPickerView *pickerView;//选择街道小区的picker
@property(nonatomic,assign)NSInteger curruntPickerNum;//当前选择的picker序号
@property(nonatomic,assign)NSInteger userType;//用户类型
@property(nonatomic, strong)NSString *areaCode;
@property(nonatomic, strong)NSString *areaName;//乡镇，街道
@property(nonatomic, strong)NSString *yardName;
@property(nonatomic, strong)NSArray *areaNames;//可选街道乡镇数组
@end

@implementation YJAddhomeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加房屋信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
//    [self loadCityData];
    
        //    -------------------------(用高德本地请求)
        [AMapServices sharedServices].apiKey =@"380748c857866280e77da5bb813e13c5";
        //设置行政区划查询参数并发起行政区划查询
        self.search = [[AMapSearchAPI alloc] init];//实例化搜索对象
        self.search.delegate = self;
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    self.areaCode = @"130681";
    dist.keywords = self.areaCode;//(用高德本地请求)
    dist.requireExtension = YES;
    [self.search AMapDistrictSearch:dist];

    
}
//获取小区列表,在小区cell的选择按钮的点击block回调中会使用
-(void)loadAreaData{
    if (self.areaCode.length==0||[self.areaCode isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择你要发布房源详细地址"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobilepub/residentialQuarters/findResidentialQuarters.do?areaCode=%@&codeUpperLevel=%@&codeUpperTwo=0",mPrefixUrl,self.areaName,self.areaCode];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[HttpClient defaultClient]requestWithPath:urlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //            [SVProgressHUD dismiss];// 动画结束
        
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJPostHouseVillageModel *infoModel = [YJPostHouseVillageModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel.rname];
            }
            if (mArr.count==0) {
                [SVProgressHUD showInfoWithStatus:@"你所选地区暂未开放该功能"];
                return ;
            }
            self.pickerDatas = mArr;
            [self setBackView];
            [self.pickerView reloadAllComponents];
        }else{
            [SVProgressHUD showInfoWithStatus:@"你所选地区暂未开放该功能"];
            return;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.description);
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
        [btn setTitleColor:[UIColor colorWithHexString:@"#0ddcbc"] forState:UIControlStateNormal];
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
            make.bottom.offset(-150*kiphone6);
            make.height.offset(50*kiphone6);
        }];
        
        UIPickerView *pickView = [[UIPickerView alloc]init];
        [self.view.window addSubview:pickView];
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.showsSelectionIndicator = YES;
        self.pickerView = pickView;
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(150*kiphone6);
        }];
        
    }else{
        self.backGrayView.hidden = false;
        self.topView.hidden = false;
        self.pickerView.hidden = false;
    }
}
- (void)setupUI {
    NSMutableArray* rightItemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    [rightItemArr addObject:negativeSpacer];//修正按钮离屏幕边缘位置的UIBarButtonItem应在按钮的前边加入数组
    UIButton *postAddressBtn = [[UIButton alloc]init];
    [postAddressBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    postAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [postAddressBtn setTitleColor:[UIColor colorWithHexString:@"#0ddcbc"] forState:UIControlStateNormal];
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
        make.top.offset(10*kiphone6);
        make.bottom.left.right.offset(0);
    }];
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJAddHomeAddressPickerTVCell class] forCellReuseIdentifier:cityCellid];
    [tableView registerClass:[YJAddHomeAddressTextFieldTVCell class] forCellReuseIdentifier:detailInfoCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    
}
//提交审核
- (void)submitAddress{
    YJAddHomeAddressTextFieldTVCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (nameCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写业主姓名"];
        return;
    }
    NSString *ownerName = nameCell.contentField.text;
    YJAddHomeAddressTextFieldTVCell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (addressCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写具体地址"];
        return;
    }
    NSString *address = addressCell.contentField.text;
    YJAddHomeAddressTextFieldTVCell *telNumberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (telNumberCell.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你所在的单元"];
        return;
    }
    NSString *ownerTelephone = telNumberCell.contentField.text;

//    参数列表:
//    |参数名          |类型      |必需  |描述
//    |-----          |----     |---- |----
//    |token          |String   |Y    |令牌
//    |id             |Long     |N    |编号
//    |familyName     |String   |N    |家名称
//    |createTime     |java.sql.Timestamp|N    |家创建时间
//    |address        |String   |N    |家的地址所属省市区县，街道，小区；楼号，几单元，几层，几室；
//    |familyState    |Integer  |N    |审核状态"0=家与地址不符合，不能用1=地址符合，正常使用"
//    |residentialQuartersId|Long     |N    |小区编号--外键--小区表
//    |areaCode       |Long     |N    |地区编码省市区县三级
//    |areaName       |String   |N    |地区名称
//    |buildingNumber |String   |N    |楼号
//    |unitNumber     |String   |N    |单元号
//    |roomNumber     |String   |N    |房间号
//    |lng            |Double   |N    |经度值
//    |lat            |Double   |N    |纬度值
//    |ownerName      |String   |N    |业主姓名
//    |ownerTelephone |Long     |N    |业主电话
//    |city           |String   |N    |城市
//    |floor          |String   |N    |楼层
//    |residentialQuartersName|String   |N    |小区名称
//    |userType       |Integer  |N    |业主身份；0=业主，1=租客，2=访客
//    //此处接提交地址接口！！！！！
//    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@token=%@&address=%@&ownerName=%@&ownerTelephone=%@&areaCode=%@&areaName=%@&userType=%ld&residentialQuartersName=%@",mSaveMyHomeInfo,mDefineToken2,address,ownerName,ownerTelephone,self.areaCode,self.areaName,(long)self.userType,self.yardName];
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[HttpClient defaultClient]requestWithPath:reportUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if ([controller isKindOfClass:[YJModifyAddressVC class]]) {
//                    YJModifyAddressVC *revise =(YJModifyAddressVC *)controller;
//                    [revise loadData];//更新新添加的数据
//                    [self.navigationController popToViewController:revise animated:YES];
//                }
//            }
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
//
//    
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *itemArr = @[@"我的姓名",@"联系电话",@"我       是",@"选择地区",@"选择街道",@"选择小区",@"详细地址"];
    if (indexPath.row<2||indexPath.row==6) {
        YJAddHomeAddressTextFieldTVCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellid forIndexPath:indexPath];
        if (indexPath.row==1) {
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            [self addToolSender:cell.contentField];
        }else{
            cell.contentField.keyboardType = UIKeyboardTypeDefault;
        }
        if (indexPath.row==6) {
            cell.contentField.placeholder = @"请填写详细地址，如：*号楼 *单元 ***";
//            [self addToolSender:cell.contentField];
        }
        cell.item = itemArr[indexPath.row];
        return cell;
        
    }else{
        YJAddHomeAddressPickerTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellid forIndexPath:indexPath];
        cell.item = itemArr[indexPath.row];
        cell.selectBtn.tag = 20+indexPath.row;
        if (indexPath.row==3) {
            cell.imageName = @"gray_address";
        }else{
            cell.imageName = @"";
        }
        WS(ws);
        cell.clickSelectBtnBlock = ^(NSInteger currentIndex) {//cell上选择按钮的点击事件
            ws.curruntPickerNum = indexPath.row;//记录选中的cell
            switch (currentIndex-20) {
                case 2://业主类型
                    ws.pickerDatas = @[@"访客",@"业主",@"租户"];
                    [ws setBackView];
                    [ws.pickerView reloadAllComponents];
                    break;
                case 3://地区
                    [SVProgressHUD showInfoWithStatus:@"该功能暂未开放其他地区"];
                    break;
                case 4://街道
                    ws.pickerDatas = [self.areaNames copy];
                    [ws setBackView];
                    [ws.pickerView reloadAllComponents];
                    break;
                case 5://小区
                    [self loadAreaData];
//                    ws.pickerDatas = @[@"水岸花城",@"名流一品小区",@"名流一品小区2"];//需要根据街道请求数据
//                    [ws setBackView];
//                    [ws.pickerView reloadAllComponents];
                    break;
                    
                default:
                    break;
            }
        };
        if (indexPath.row==3) {
            cell.contentLabel.text = @"河北省 保定市 涿州市";
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
        return self.pickerDatas.count;
 
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
        return kScreenW;
  
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50*kiphone6;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    YJAddHomeAddressPickerTVCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.curruntPickerNum inSection:0]];
    
    cell.contentLabel.text = self.pickerDatas[row];
    switch (self.curruntPickerNum) {
        case 2:
            self.userType = row;//对应业主身份；0=业主，1=租客，2=访客
            break;
        case 4:
            self.areaName = cell.contentLabel.text;//地区名称
            break;
        case 5:
            self.yardName = cell.contentLabel.text;//小区名称
            break;
        default:
            break;
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
    [label setText:self.pickerDatas[row]];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:23];
    return label;
}
/* 行政区划数据查询回调. */
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{

    if (response == nil)
    {
        return;
    }
    //当前区域数据
    NSMutableArray *citys = [NSMutableArray array];//第二个数组

    //解析response获取行政区划，具体解析见 Demo
    for (AMapDistrict *dist in response.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
    {
        for (AMapDistrict *subDist in dist.districts)//NSArray<AMapDistrict *> *districts下级行政区域数组
        {
            [citys addObject:subDist.name];//第二个数组
            
        }

    }
    self.areaNames = citys;

}
////当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
//- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//    [SVProgressHUD showErrorWithStatus:error.description];
//}

//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    self.pickerView.hidden = true;
    self.topView.hidden = true;
    self.backGrayView.hidden = true;
}
-(void)resignFirstResponderText {
    self.pickerView.hidden = true;
    self.topView.hidden = true;
    self.backGrayView.hidden = true;
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
        YJAddHomeAddressTextFieldTVCell *cell5 = [self.tableView cellForRowAtIndexPath:index5];
        YJAddHomeAddressTextFieldTVCell *cell6 = [self.tableView cellForRowAtIndexPath:index6];
        YJAddHomeAddressTextFieldTVCell *cell7 = [self.tableView cellForRowAtIndexPath:index7];
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

