//
//  YJPropertyBillVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPropertyBillVC.h"
#import "UIColor+colorValues.h"
#import "UILabel+Addition.h"
#import "YJAddPropertyBillAddressVC.h"
#import "YJHeaderTitleBtn.h"
#import "YJBillResultTableViewCell.h"
#import "YJModifyAddressVC.h"
#import "YJPropertyAddressModel.h"
#import "YJMonthDetailItemModel.h"
#import "YJMonthDetailSumModel.h"

static NSString* billCellid = @"bill_cell";
@interface YJPropertyBillVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSMutableArray *yearArr;
@property(nonatomic,strong)NSMutableArray *monthArr;
@property(nonatomic,weak)UIPickerView *yearPickerView;
@property(nonatomic,weak)UIPickerView *monthPickerView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)BOOL isBill;
@property(nonatomic,weak)UIButton *yearBtn;
@property(nonatomic,weak)UIButton *monthBtn;
@property(nonatomic,assign)NSInteger nowYear;
@property(nonatomic,assign)NSInteger nowMonth;

@property(nonatomic,strong)NSMutableArray *addresses;
@property(nonatomic,strong)NSString *address;//当前显示的地址
@property(nonatomic,strong)NSMutableArray *months;
@end

@implementation YJPropertyBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业账单";
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self loadData];

}
- (void)loadData {
//    CcUserModel *userModel = [CcUserModel defaultClient];
//    NSString *token = userModel.userToken;
//    http://192.168.1.55:8080/smarthome/mobileapi/family/findFamilyAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC   查询业主地址
    [SVProgressHUD show];// 动画开始
    NSString *addressUrlStr = [NSString stringWithFormat:@"%@/mobileapi/family/findFamilyAddress.do?token=%@",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:addressUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJPropertyAddressModel *infoModel = [YJPropertyAddressModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.addresses = mArr;
            YJPropertyAddressModel *model = self.addresses[0];
            self.address = model.detailAddress;//默认选择第一个地址
            [SVProgressHUD dismiss];// 动画结束
             [self setupBill];
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
             [self addAddress];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
}
- (void)addAddress{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_address"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.offset(109*kiphone6);
    }];
    UILabel *itemLabel = [UILabel labelWithText:@"您还没有小区信息" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [self.view addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom).offset(21*kiphone6);
    }];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"添加地址" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemLabel.mas_bottom).offset(139*kiphone6);
        make.centerX.equalTo(self.view);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(addAddressVC) forControlEvents:UIControlEventTouchUpInside];

}
- (void)addAddressVC{
    YJAddPropertyBillAddressVC *vc = [[YJAddPropertyBillAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setupBill{
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"2017年"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"全部"andTag:102];
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yearBtn.mas_bottom).offset(1*kiphone6);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJBillResultTableViewCell class] forCellReuseIdentifier:billCellid];
    //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;

}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.yearBtn = btn;
    }else{
        self.monthBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    self.nowYear = year;
    NSInteger month =  [dateComponent month];
    self.nowMonth = month;
//    NSInteger day = [dateComponent day];
//    NSInteger hour = [dateComponent hour];
    NSMutableArray *timeArr = [NSMutableArray array];
        if (sender.tag == 101) {
        if (self.yearPickerView) {
            for (NSInteger i = year-9; i<=year; i++) {
                NSString *yearStr = [NSString stringWithFormat: @"%ld年", (long)i];
                [timeArr addObject:yearStr];
            }
            self.yearArr = timeArr;
            if (self.yearPickerView.hidden) {
                self.yearPickerView.hidden = false;
                self.monthPickerView.hidden = true;
            }else{
                self.yearPickerView.hidden = true;
                
            }
            
        }else{
            for (NSInteger i = year-9; i<=year; i++) {
                NSString *yearStr = [NSString stringWithFormat: @"%ld年", (long)i];
                [timeArr addObject:yearStr];
            }
            self.yearArr = timeArr;
            UIPickerView *pickView = [[UIPickerView alloc]init];
            [self.view addSubview:pickView];
            pickView.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
            pickView.dataSource = self;
            pickView.delegate = self;
            pickView.showsSelectionIndicator = YES;
            self.yearPickerView = pickView;
            [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sender.mas_bottom);
                make.left.width.equalTo(sender);
                make.height.offset(220*kiphone6);
            }];
        }
            self.monthPickerView.hidden = true;
        

        self.monthBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.monthBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.monthBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    }else{
        self.yearBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.yearBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.yearBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        if (self.monthPickerView) {
            NSInteger selectYear = [self.yearBtn.titleLabel.text integerValue];
            if (selectYear<year) {
                for (NSInteger i = 1; i<=12; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%ld月", (long)i];
                    [timeArr addObject:yearStr];
                }
            }else{
                for (NSInteger i = 1; i<=month; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%ld月", (long)i];
                    [timeArr addObject:yearStr];
                }
            }
            [timeArr addObject:@"全部"];
            self.monthArr = timeArr;
            if (self.monthPickerView.hidden) {
                self.monthPickerView.hidden = false;
                self.yearPickerView.hidden = true;
            }else{
                self.monthPickerView.hidden = true;
                
            }
            
        }else{
            NSInteger selectYear = [self.yearBtn.titleLabel.text integerValue];
            if (selectYear<year) {
                for (NSInteger i = 1; i<=12; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%ld月", (long)i];
                    [timeArr addObject:yearStr];
                }
            }else{
                for (NSInteger i = 1; i<=month; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%ld月", (long)i];
                    [timeArr addObject:yearStr];
                }
            }
            [timeArr addObject:@"全部"];
            self.monthArr = timeArr;
            UIPickerView *pickView = [[UIPickerView alloc]init];
            [self.view addSubview:pickView];
            pickView.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
            pickView.dataSource = self;
            pickView.delegate = self;
            pickView.showsSelectionIndicator = YES;
            self.monthPickerView = pickView;
            [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sender.mas_bottom);
                make.left.width.equalTo(sender);
                make.height.offset(220*kiphone6);
            }];
            self.yearPickerView.hidden = true;
        }
    }

}
#pragma mark - pickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==self.yearPickerView) {
        return self.yearArr.count;
    }else{
        return self.monthArr.count;
    }
    
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return pickerView.bounds.size.width;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==self.yearPickerView) {
        // 数组越界保护
        if (row < self.yearArr.count) {
            
                [self.yearBtn setTitle:[self.yearArr objectAtIndex:row] forState:UIControlStateNormal];
            NSMutableArray *timeArr = [NSMutableArray array];
            NSInteger selectYear = [self.yearBtn.titleLabel.text integerValue];
            if (selectYear<self.nowYear) {
                for (NSInteger i = 1; i<=12; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%ld月", (long)i];
                    [timeArr addObject:yearStr];
                }
            }else{
                for (NSInteger i = 1; i<=self.nowMonth; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%ld月", (long)i];
                    [timeArr addObject:yearStr];
                }
            }
            [timeArr addObject:@"全部"];
            self.monthArr = timeArr;
            [self.monthPickerView reloadAllComponents];
            }
    }else{
        if (row < self.monthArr.count) {
       [self.monthBtn setTitle:[self.monthArr objectAtIndex:row] forState:UIControlStateNormal];
        }
    }
  //pickerView.hidden = true;
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.yearPickerView) {
        if (row >= self.yearArr.count) {
            return nil;
        }else{
            
            return [self.yearArr objectAtIndex:row];
        }
    }else{
        if (row >= self.monthArr.count) {
            return nil;
        }else{
            
            return [self.monthArr objectAtIndex:row];
        }
    }
  
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.months.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJBillResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:billCellid forIndexPath:indexPath];
    cell.sumModel = self.months[indexPath.row];
    return cell;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 177*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 68*kiphone6)];
    headerBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_info"]];
    [headerBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerBtn);
    }];
    
    UILabel *addressLabel = [UILabel labelWithText:self.address andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    self.address = addressLabel.text;
    [headerBtn addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
    }];
    WS(ws);
    self.clickBtnBlock = ^(NSString *address) {
        addressLabel.text = address;
        ws.address = address;
        //此处需要根据新地址刷新账单
        [ws queryBill];
                
                 };
    YJPropertyAddressModel *model = self.addresses[0];
    UILabel *cityLabel = [UILabel labelWithText:model.city andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [headerBtn addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressLabel.mas_top).offset(-5*kiphone6);
        make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
    }];
    UIImageView *gray_forward = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gray_forward"]];
    [headerBtn addSubview:gray_forward];
    [gray_forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(headerBtn);
    }];
    [headerBtn addTarget:self action:@selector(modifyAddress) forControlEvents:UIControlEventTouchUpInside];
    return headerBtn;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 68*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
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
    [btn addTarget:self action:@selector(queryBill) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100*kiphone6;
}
- (void)queryBill {
    self.yearPickerView.hidden = true;
    self.monthPickerView.hidden = true;
//http://192.168.1.55:8080/smarthome/mobileapi/detail/findBill.do?token=ACDCE729BCE6FABC50881A867CAFC1BC
//    &address=%E5%90%8D%E6%B5%81%E4%B8%80%E5%93%81%E5%B0%8F%E5%8C%BA1%E5%8F%B7%E6%A5%BC%E4%B8%80%E5%8D%95%E5%85%831%E6%A5%BC305%E5%8F%B7
//    &Yeartime=2017
//    &monthtime=13
//
    NSString *Yeartime = [self.yearBtn.titleLabel.text substringToIndex:4];
    NSString *monthtime = [NSString string];
    if ([self.monthBtn.titleLabel.text isEqualToString:@"全部"]) {
        monthtime = @"13";
    }else{
        NSRange range = [self.monthBtn.titleLabel.text rangeOfString:@"月"];
        monthtime = [self.monthBtn.titleLabel.text substringToIndex:range.location];
    }
    NSString *address = [self.address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSString *queryUrlStr = [NSString stringWithFormat:@"%@/mobileapi/detail/findBill.do?token=%@&address=%@&Yeartime=%@&monthtime=%@",mPrefixUrl,mDefineToken1,address,Yeartime,monthtime];
    [SVProgressHUD show];
    [[HttpClient defaultClient]requestWithPath:queryUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"itemsYear"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJMonthDetailSumModel *infoModel = [YJMonthDetailSumModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.months = mArr;
            [self.tableView reloadData];

        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
                
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

}
- (void)modifyAddress{
    YJModifyAddressVC *vc = [[YJModifyAddressVC alloc]init];
    vc.addresses = self.addresses;
    [self.navigationController pushViewController:vc animated:true];
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
