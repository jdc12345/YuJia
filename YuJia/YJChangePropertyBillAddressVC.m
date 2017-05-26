//
//  YJChangePropertyBillAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/26.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJChangePropertyBillAddressVC.h"
#import "YJCityTableViewCell.h"
#import "YJBillInfoTableViewCell.h"
#import "YJPropertyBillVC.h"
#import "YJLifepaymentVC.h"
#import "YJCityDetailModel.h"
#import "YJAreaDetailModel.h"
#import "YJPropertyDetailAddressModel.h"
#import "YJModifyAddressVC.h"

static NSString* cityCellid = @"city_cell";
static NSString* detailInfoCellid = @"detailInfo_cell";
@interface YJChangePropertyBillAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIView *selectView;
@property(nonatomic,weak)UIView *selectAreaView;
@property(nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSString *yardName;
@property(nonatomic, strong)NSString *areaCode;
@property(nonatomic, strong)NSString *yardid;
@property(nonatomic, strong)YJPropertyDetailAddressModel *addressModel;//要修改的地址数据
@end

@implementation YJChangePropertyBillAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改地址";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
}
-(void)setInfo_id:(long)info_id{
    _info_id = info_id;
    [self loadAddressData];
}
-(void)loadAddressData{
 http://localhost:8080/smarthome//mobileapi/detailHome/get.do?token=EC9CDB5177C01F016403DFAAEE3C1182&AddressId=3   
    [SVProgressHUD show];// 动画开始
    NSString *addressUrlStr = [NSString stringWithFormat:@"%@/mobileapi/detailHome/get.do?token=%@&AddressId=%ld",mPrefixUrl,mDefineToken1,self.info_id];
    [[HttpClient defaultClient]requestWithPath:addressUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *dic = responseObject[@"result"];
            YJPropertyDetailAddressModel *addressModel = [YJPropertyDetailAddressModel mj_objectWithKeyValues:dic];
            self.addressModel = addressModel;
            self.areaCode = addressModel.areaCode;
            self.cityName = addressModel.city;
            self.yardName = addressModel.residentialQuarters;
            [self setupUI];
            [SVProgressHUD dismiss];// 动画结束
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
  
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
    
    [self.selectView removeFromSuperview];
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
            if (arr.count>0) {
            for (NSDictionary *dic in arr) {
                YJAreaDetailModel *infoModel = [YJAreaDetailModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
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
    
    for (UIView *subView in self.selectView.subviews) {
        [subView removeFromSuperview];
    }
    [self.selectView removeFromSuperview];
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
    YJPropertyDetailAddressModel *addressModel = [[YJPropertyDetailAddressModel alloc]init];//pop时候回传
    addressModel.info_id = self.info_id;
    YJCityTableViewCell *cityCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *city = [cityCell.city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    addressModel.city = cityCell.city;
    YJCityTableViewCell *yardCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *yard = [yardCell.city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    addressModel.residentialQuarters = yardCell.city;
    YJBillInfoTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *name = [nameCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    addressModel.ownerName = nameCell.contentField.text;
    YJBillInfoTableViewCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    //    NSString *telNum = [telCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *buildCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *buildNumber = [NSString stringWithFormat:@"%@",buildCell.contentField.text];
    addressModel.buildingNumber = [NSString stringWithFormat:@"%@号楼",buildCell.contentField.text];
    NSString *buildingNumber = [buildNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *floorCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *floorNumber = [NSString stringWithFormat:@"%@",floorCell.contentField.text];
    addressModel.floor = [NSString stringWithFormat:@"%@层",floorCell.contentField.text];
    NSString *floor = [floorNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *unitNumberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *unit = [NSString stringWithFormat:@"%@",unitNumberCell.contentField.text];
    addressModel.unitNumber = [NSString stringWithFormat:@"%@单元",unitNumberCell.contentField.text];;
    NSString *unitNumber = [unit stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJBillInfoTableViewCell *roomCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    NSString *room = [NSString stringWithFormat:@"%@",roomCell.contentField.text];
    addressModel.roomNumber = [NSString stringWithFormat:@"%@室",roomCell.contentField.text];
    NSString *roomNumber = [room stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//http://localhost:8080/smarthome/mobileapi/detailHome/UpdateDetailHomeAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC
//    &AddressId=3&city=%E6%B6%BF%E5%B7%9E%E5%B8%82
//    &residentialQuarters=%E5%90%8D%E6%B5%81%E4%B8%80%E5%93%81%E5%B0%8F%E5%8C%BA
//    &ownerName=%E5%88%98%E5%A4%A7%E4%B8%9C
//    &buildingNumber=2
//    &unitNumber=3
//    &floor=5
//    &roomNumber=1502
    //此处接提交地址接口！！！！！
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@/mobileapi/detailHome/UpdateDetailHomeAddress.do?token=%@&AddressId=%ld&city=%@&residentialQuarters=%@&ownerName=%@&buildingNumber=%@&unitNumber=%@&floor=%@&roomNumber=%@&ownertelephone=%@&areaCode=%@",mPrefixUrl,mDefineToken1,self.info_id,city,yard,name,buildingNumber,unitNumber,floor,roomNumber,telCell.contentField.text,self.areaCode];
    [[HttpClient defaultClient]requestWithPath:reportUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[YJModifyAddressVC class]]) {
                            YJModifyAddressVC *revise =(YJModifyAddressVC *)controller;
                            //            revise.clickBtnBlock(cell.textLabel.text);此处可根据新地址请求账单
                            revise.addressModel = addressModel;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                        if ([controller isKindOfClass:[YJLifepaymentVC class]]) {
                            YJLifepaymentVC *revise =(YJLifepaymentVC *)controller;
                            //            revise.clickBtnBlock(cell.textLabel.text);
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
//           self.navigationController pop回去，根据最新内容改变修改cell的内容
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[YJPropertyBillVC class]]) {
//            YJPropertyBillVC *revise =(YJPropertyBillVC *)controller;
//            //            revise.clickBtnBlock(cell.textLabel.text);此处可根据新地址请求账单
//            [self.navigationController popToViewController:revise animated:YES];
//        }
//        if ([controller isKindOfClass:[YJLifepaymentVC class]]) {
//            YJLifepaymentVC *revise =(YJLifepaymentVC *)controller;
//            //            revise.clickBtnBlock(cell.textLabel.text);
//            [self.navigationController popToViewController:revise animated:YES];
//        }
//    }
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
        if (indexPath.row==0) {
            cell.city = self.addressModel.city;
        }
        if (indexPath.row==1) {
            cell.city = self.addressModel.residentialQuarters;
        }
        return cell;
    }else{
        YJBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellid forIndexPath:indexPath];
        
        if (indexPath.row>2) {
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            [self addToolSender:cell.contentField];//添加完成工具栏
        }
        if (indexPath.row==2) {
            cell.contentField.text = self.addressModel.ownerName;
        }
        if (indexPath.row==3) {
            cell.contentField.text = [NSString stringWithFormat:@"%ld",self.addressModel.rqtelephone];
        }
        if (indexPath.row==4) {
            cell.contentField.text = self.addressModel.buildingNumber;
        }
        if (indexPath.row==5) {
            cell.contentField.text = self.addressModel.floor;
        }
        if (indexPath.row==6) {
            cell.contentField.text = self.addressModel.unitNumber;
        }
        if (indexPath.row==7) {
            cell.contentField.text = self.addressModel.roomNumber;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
