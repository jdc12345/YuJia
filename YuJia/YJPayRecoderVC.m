//
//  YJPayRecoderVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/24.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPayRecoderVC.h"
#import "UILabel+Addition.h"
#import "YJInputPayNumberVC.h"
#import "YJPayRecoderTVCell.h"

#import "YJLifePayRecoderModel.h"
#import "YJLifePayRecoderDetailVC.h"

static NSString* payCellid = @"pay_cell";
@interface YJPayRecoderVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,weak)UITableView *payTableView;
@property(nonatomic,strong)NSArray *recoderArr;//记录数据源
@property(nonatomic,strong)NSMutableArray *yearArr;
@property(nonatomic,strong)NSMutableArray *monthArr;
@property(nonatomic,weak)UIPickerView *timePickerView;
//@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,assign)NSInteger nowYear;
@property(nonatomic,assign)NSInteger nowMonth;
@property(nonatomic,weak)UIView *backGrayView;//时间选择器半透明背景
@property(nonatomic,weak)UILabel *timeLabel;//时间label
@property(nonatomic,strong)NSString *selectYear;//当前选中的年份
@property(nonatomic,strong)NSString *selectMonth;//当前选中的月份
@property(nonatomic,weak)UIToolbar * topView;//时间选择器工具栏

@end

@implementation YJPayRecoderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费记录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self setupUI];
}
//一开始先查当前月份的记录
-(void)setCurrentAddressModel:(YJLifePayAddressModel *)currentAddressModel{
    _currentAddressModel = currentAddressModel;
    _currentAddressModel.info_id = 12;//因为目前只有地址id为12的地址有记录，需要删除此行代码
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    self.nowYear = year;
    NSInteger month =  [dateComponent month];
    self.nowMonth = month;
    self.selectYear = [NSString stringWithFormat:@"%ld",self.nowYear];
    self.selectMonth = [NSString stringWithFormat:@"%02ld",self.nowMonth];
    [self queryRecord];
}
- (void)setupUI {
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.payTableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJPayRecoderTVCell class] forCellReuseIdentifier:payCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recoderArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJPayRecoderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:payCellid forIndexPath:indexPath];
    YJLifePayRecoderModel *infoModel = self.recoderArr[indexPath.row];
    infoModel.detailAddress = self.currentAddressModel.detailAddress;//给记录添加一条地址的属性
    cell.model = infoModel;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45*kiphone6)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    NSString *text = [NSString stringWithFormat:@"%ld月",[self.selectMonth integerValue]];
    NSString *time = [NSString stringWithFormat:@"%@年%@",self.selectYear,text];
    UILabel *timeLabel = [UILabel labelWithText:time andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.offset(10*kiphone6);
    }];
    self.timeLabel = timeLabel;//显示时间的label
    UIButton *timeBtn = [[UIButton alloc]init];
    [timeBtn setImage:[UIImage imageNamed:@"calendar_payed"] forState:UIControlStateNormal];
    [view addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.offset(-10*kiphone6);
    }];
    [timeBtn addTarget:self action:@selector(selectTime) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45*kiphone6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    YJLifePayRecoderModel *infoModel = self.recoderArr[indexPath.row];//创过去的单条记录详情
    YJLifePayRecoderDetailVC *vc = [[YJLifePayRecoderDetailVC alloc]init];
    vc.infoModel = infoModel;
    [self.navigationController pushViewController:vc animated:true];
}
//选择时间按钮点击事件
- (void)selectTime{
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
        //时间选择器
            for (NSInteger i = year-9; i<=year; i++) {
                NSString *yearStr = [NSString stringWithFormat: @"%ld", (long)i];
                [timeArr addObject:yearStr];
            }
            self.yearArr = timeArr;
        NSMutableArray *monthArr = [NSMutableArray array];
        for (NSInteger i = 1; i<=12; i++) {
            NSString *monthStr = [NSString stringWithFormat: @"%02ld", (long)i];
            [monthArr addObject:monthStr];
        }
        self.monthArr = monthArr;

            UIPickerView *pickView = [[UIPickerView alloc]init];
            [self.view.window addSubview:pickView];
            pickView.backgroundColor = [UIColor whiteColor];
            pickView.dataSource = self;
            pickView.delegate = self;
            pickView.showsSelectionIndicator = YES;
            self.timePickerView = pickView;
            [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.height.offset(165*kiphone6);
            }];
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 15;
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(2, 5, 50, 25);
        [closeBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
        UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *middelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        middelBtn.frame = CGRectMake(2, 5, 75, 25);
        //        [middelBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [middelBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        [middelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        UIBarButtonItem *titleBtn = [[UIBarButtonItem alloc]initWithCustomView:middelBtn];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 5, 50, 25);
        [btn addTarget:self action:@selector(queryRecord) forControlEvents:UIControlEventTouchUpInside];//点击完成开始查询记录
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
        UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer1.width = 15;
        NSArray * buttonsArray = [NSArray arrayWithObjects:negativeSpacer,cancleBtn,btnSpace1,titleBtn,btnSpace,doneBtn,negativeSpacer1,nil];
        [topView setItems:buttonsArray];
        [self.view.window addSubview:topView];
        [self.view.window bringSubviewToFront:topView];
        self.topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.equalTo(pickView.mas_top);
            //            make.height.offset(200*kiphone6);
        }];
        //            设置初始默认值
        [self pickerView:self.timePickerView didSelectRow:self.yearArr.count-1 inComponent:0];
        [self pickerView:self.timePickerView didSelectRow:self.nowMonth-1 inComponent:1];
        [self.timePickerView selectRow:self.yearArr.count-1 inComponent:0 animated:true];
        [self.timePickerView selectRow:self.nowMonth-1 inComponent:1 animated:true];

    }else{
        self.backGrayView.hidden = false;
        self.timePickerView.hidden = false;
        self.topView.hidden = false;
    }
}
//查询记录
-(void)queryRecord{
    [self resignFirstResponderText];
//    七：查询生活缴费缴费记录接口
http://localhost:8080/smarthome/mobileapi/detailrecord/findDetailRecord.do?token=49491B920A9DD107E146D961F4BDA50E
//    &detailHomeId=12
//    &year=2017
//    &month=07
//    参数：  参数名                     参数类型                             备注
//    token              String         令牌
//    detailHomeId             Long        缴费地址ID
//    year               String         年份
//    month              String      月份（格式01，02两位数）
    [SVProgressHUD show];// 动画开始
    NSString *queryRecordUrlStr = [NSString stringWithFormat:@"%@/mobileapi/detailrecord/findDetailRecord.do?token=%@&detailHomeId=%ld&year=%@&month=%@",mPrefixUrl,mDefineToken1,self.currentAddressModel.info_id,self.selectYear,self.selectMonth];
    [[HttpClient defaultClient]requestWithPath:queryRecordUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJLifePayRecoderModel *infoModel = [YJLifePayRecoderModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.recoderArr = mArr;
            if (mArr.count>0) {
                [self.payTableView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:@"本月没有记录"];
            }
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }
        [SVProgressHUD dismiss];// 动画结束
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];

}
#pragma Mark -- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArr.count;
    }
    
    return self.monthArr.count;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return kScreenW*0.5;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 55*kiphone6;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        // 数组越界保护
        if (row < self.yearArr.count) {
            self.timeLabel.text = [self.yearArr objectAtIndex:row];
            self.selectYear = self.timeLabel.text;
            NSMutableArray *timeArr = [NSMutableArray array];
            NSInteger selectYear = [self.timeLabel.text integerValue];
            if (selectYear<self.nowYear) {
                for (NSInteger i = 1; i<=12; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%02ld", (long)i];
                    [timeArr addObject:yearStr];
                }
            }else{
                for (NSInteger i = 1; i<=self.nowMonth; i++) {
                    NSString *yearStr = [NSString stringWithFormat: @"%02ld", (long)i];
                    [timeArr addObject:yearStr];
                }
            }
            self.monthArr = timeArr;
            [self.timePickerView reloadComponent:1];
        }
    }else{
        if (row < self.monthArr.count) {
            self.selectMonth = [self.monthArr objectAtIndex:row];
            NSString *month = [self.monthArr objectAtIndex:row];
            NSString *text = [NSString stringWithFormat:@"%ld月",[month integerValue]];
            self.timeLabel.text = [NSString stringWithFormat:@"%@年%@",self.selectYear,text];

        }
    }
    //pickerView.hidden = true;
    
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
        if (component == 0) {
            [label setText:[self.yearArr objectAtIndex:row]];
        }else{
            NSString *month = [self.monthArr objectAtIndex:row];
            NSString *text = [NSString stringWithFormat:@"%ld月",[month integerValue]];
            [label setText:text];
        }
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:23];
    return label;
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    self.backGrayView.hidden = true;
    self.timePickerView.hidden = true;
    self.topView.hidden = true;

}
-(void)resignFirstResponderText {
    [self.view endEditing:true];
    self.backGrayView.hidden = true;
    self.timePickerView.hidden = true;
    self.topView.hidden = true;

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
