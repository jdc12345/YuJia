//
//  MMHomeInfoViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/6/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MMHomeInfoViewController.h"
#import "YJCityTableViewCell.h"
#import "YJBillInfoTableViewCell.h"
#import "YJPropertyBillVC.h"
#import "YJLifepaymentVC.h"
#import "YJCityDetailModel.h"
#import "YJAreaDetailModel.h"
#import "UIBarButtonItem+Helper.h"

static NSString* cityCellid = @"city_cell";
static NSString* detailInfoCellid = @"detailInfo_cell";

@interface MMHomeInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIView *selectView;
@property(nonatomic,weak)UIView *selectAreaView;
@property(nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSString *yardName;
@property(nonatomic, strong)NSString *areaCode;
@property(nonatomic, strong)NSString *yardid;

@end

@implementation MMHomeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的房屋信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" normalColor:[UIColor colorWithHexString:@"00bfff"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(httpRequestSaveHomeInfo)];
    [self setupUI];
}
-(void)loadCityData{
http://192.168.1.55:8080/smarthome/mobilepub/baseArea/findList.do 获取城市列表
    [SVProgressHUD show];// 动画开始
    NSString *getCityUrlStr = [NSString stringWithFormat:@"%@/mobilepub/baseArea/findList.do",mPrefixUrl];
    [[HttpClient defaultClient]requestWithPath:getCityUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"baseAreaList"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJCityDetailModel *infoModel = [YJCityDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            [self selectViewWithNames:mArr and:10];
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
    
}
-(void)selectViewWithNames:(NSArray*)names and:(NSInteger)tag{
    if (self.selectView) {
        if (self.selectView.hidden==false) {
            self.selectView.hidden=true;
        }else{
            self.selectView.hidden=false;
        }
        
    }else{
        UIView *selectView = [[UIView alloc]init];
        selectView.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];
        selectView.layer.borderColor = [UIColor colorWithHexString:@"#cccaca"].CGColor;
        selectView.layer.borderWidth =1*kiphone6/[UIScreen mainScreen].scale;
        [self.view addSubview:selectView];
        [self.view bringSubviewToFront:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5*kiphone6);
            make.right.offset(-5*kiphone6);
            make.width.offset(130*kiphone6);
            make.height.offset(28*kiphone6*names.count);
        }];
        self.selectView =selectView;
        for (int i=0; i<names.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*28*kiphone6, 130*kiphone6, 28*kiphone6)];
            YJCityDetailModel *infoModel = names[i];
            btn.tag = tag+[infoModel.areaCode integerValue];
            [btn setTitle:infoModel.areaName forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [selectView addSubview:btn];
            [btn addTarget:self action:@selector(updateCity:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
-(void)updateCity:(UIButton*)sender{
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#cccaca"]];
    self.areaCode = [NSString stringWithFormat:@"%ld",sender.tag-10];
    self.selectView.hidden = true;
    YJCityTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.city = sender.titleLabel.text;
    self.cityName = sender.titleLabel.text;
}
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
            [self selectViewWithAreaNames:mArr and:20];
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
    
}
-(void)selectViewWithAreaNames:(NSArray*)names and:(NSInteger)tag{
    if (self.selectAreaView) {
        if (self.selectAreaView.hidden==false) {
            self.selectAreaView.hidden=true;
        }else{
            self.selectAreaView.hidden=false;
        }
        
    }else{
        UIView *selectAreaView = [[UIView alloc]init];
        selectAreaView.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];
        selectAreaView.layer.borderColor = [UIColor colorWithHexString:@"#cccaca"].CGColor;
        selectAreaView.layer.borderWidth =1*kiphone6/[UIScreen mainScreen].scale;
        [self.view addSubview:selectAreaView];
        [self.view bringSubviewToFront:selectAreaView];
        [selectAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5*kiphone6);
            make.right.offset(-5*kiphone6);
            make.width.offset(130*kiphone6);
            make.height.offset(28*kiphone6*names.count);
        }];
        self.selectAreaView =selectAreaView;
        for (int i=0; i<names.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*28*kiphone6, 130*kiphone6, 28*kiphone6)];
            YJAreaDetailModel *infoModel = names[i];
            btn.tag = tag+[infoModel.info_id integerValue];
            [btn setTitle:infoModel.rname forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [selectAreaView addSubview:btn];
            [btn addTarget:self action:@selector(updateArea:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
-(void)updateArea:(UIButton*)sender{
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#cccaca"]];
    self.yardid = [NSString stringWithFormat:@"%ld",sender.tag-20];
    self.selectAreaView.hidden = true;
    YJCityTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.city = sender.titleLabel.text;
    self.yardName = sender.titleLabel.text;
}
- (void)setupUI {
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
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(submitAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    tableView.tableFooterView = footerView;
    
}
- (void)submitAddress{
    NSString *city = [self.cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *yard = [self.yardName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *name = [nameCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    //    NSString *telNum = [telCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *buildCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *buildNumber = [NSString stringWithFormat:@"%@",buildCell.contentField.text];
    NSString *buildingNumber = [buildNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *floorCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *floorNumber = [NSString stringWithFormat:@"%@",floorCell.contentField.text];
    NSString *floor = [floorNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *unitNumberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *unit = [NSString stringWithFormat:@"%@",unitNumberCell.contentField.text];
    NSString *unitNumber = [unit stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *roomCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
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
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@/mobileapi/family/addAddress.do?token=%@&city=%@&yard=%@&yarid=%@&ownerName=%@&ownertelephone=%@&buildingNumber=%@&unitNumber=%@&floor=%@&roomNumber=%@&areaCode=%@",mPrefixUrl,mDefineToken1,city,yard,self.yardid,name,telCell.contentField.text,buildingNumber,unitNumber,floor,roomNumber,self.areaCode];
    [[HttpClient defaultClient]requestWithPath:reportUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YJPropertyBillVC class]]) {
            YJPropertyBillVC *revise =(YJPropertyBillVC *)controller;
            //            revise.clickBtnBlock(cell.textLabel.text);此处可根据新地址请求账单
            [self.navigationController popToViewController:revise animated:YES];
        }
        if ([controller isKindOfClass:[YJLifepaymentVC class]]) {
            YJLifepaymentVC *revise =(YJLifepaymentVC *)controller;
            //            revise.clickBtnBlock(cell.textLabel.text);
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
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
        [self loadCityData];
    }else if (indexPath.row==1){
        [self loadAreaData];
    }
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
-(void)resignFirstResponderText {
    [self.view endEditing:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpRequestSaveHomeInfo{
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:2];
//    // userType
//    NSString *userType;
//    if ([self.myIsLabel.text isEqualToString:@"业主"]) {
//        userType = @"0";
//    }else  if ([self.myIsLabel.text isEqualToString:@"租户"]){
//        userType = @"1";
//    }else{
//        userType = @"2";
//    }
//    [dict setValue:mDefineToken forKey:@"token"];
//    [dict setValue:self.nameField.text forKey:@"ownerName"];
//    [dict setValue:self.phoneField.text forKey:@"ownerTelephone"];
//    [dict setValue:self.myIsLabel.text forKey:@"userType"];
//    [dict setValue:self.adressLabel.text forKey:@"areaName"];
//    [dict setValue:self.detailAdressTextView.text forKey:@"address"];
//    
//    NSLog(@"%@",dict);
//    
//    
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mSaveMyHomeInfo,mDefineToken] method:1 parameters:dict prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mMyHomeInfo,mDefineToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
//        NSDictionary *dict = responseObject[@"Family"];
//        self.myRoomInfoModel = [MyRoomInfoModel mj_objectWithKeyValues:dict];
//        
//        NSString *userType;
//        switch ([self.myRoomInfoModel.userType integerValue]) {
//            case 0:
//                userType = @"业主";
//                break;
//            case 1:
//                userType = @"租客";
//                break;
//            case 2:
//                userType = @"访客";
//                break;
//            default:
//                userType = @"啥玩意";
//                break;
//        }
//        
//        self.nameField.text = self.myRoomInfoModel.ownerName;
//        self.phoneField.text = self.myRoomInfoModel.ownerTelephone;
//        self.myIsLabel.text = userType;
//        self.adressLabel.text = self.myRoomInfoModel.areaName;
//        self.detailAdressTextView.text = self.myRoomInfoModel.address;
//        if (self.myRoomInfoModel.address.length >0) {
//            self.placeHolderLabel.hidden = YES;
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
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
