//
//  AirTimingViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AirTimingViewController.h"
#import "YYPersonalTableViewCell.h"
#import "AirModelTableViewCell.h"
@interface AirTimingViewController ()<UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) NSArray *proHourTimeList;
@property (nonatomic, copy) NSArray *proMinuteTimeList;
@property (nonatomic, strong) NSString *currentHour;
@property (nonatomic, strong) NSString *currentMinute;
@property (nonatomic, weak) UILabel *promptLabel;
@end

@implementation AirTimingViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10 , kScreenW, kScreenH -352.25) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        
        [_tableView registerClass:[AirModelTableViewCell class] forCellReuseIdentifier:@"AirModelTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
//        [self.view sendSubviewToBack:_tableView];
        
        _tableView.tableHeaderView = [self personInfomation];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self tableView];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)personInfomation{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -352.25)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    headerView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"定时关闭";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(10);
        make.left.equalTo(headerView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50 ,12));
    }];
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [headerView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.top.equalTo(titleLabel).with.offset(10);;
        make.size.mas_equalTo(CGSizeMake(kScreenW ,150));
    }];
    
    _proHourTimeList = [[NSArray alloc]initWithObjects:@"0时",@"1时",@"2时",@"3时",@"4时",@"5时",@"6时",@"7时",@"8时",@"9时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时",nil];
    
    NSMutableArray *minute = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0 ; i<60 ; i++) {
        NSString *minuteStr = [NSString stringWithFormat:@"%d分",i];
        [minute addObject:minuteStr];
    }
    _proMinuteTimeList = minute;
    
//    // 中间灰条
//    UILabel *grayLabelBottom = [[UILabel alloc]init];
//    grayLabelBottom.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
//    
//    [headerView addSubview:grayLabelBottom];
//    
//    [grayLabelBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headerView).with.offset(32);
//        make.centerX.equalTo(headerView).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenW ,1));
    
    

    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, kScreenW, 44);
    [sureBtn setTitle:@"确定添加" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 44));
    }];
    
    if (kScreenW >320) {
        UILabel *promptLabel = [[UILabel alloc]init];
        promptLabel.text = @"0小时0分钟后 将关闭该空调";
        promptLabel.textColor = [UIColor colorWithHexString:@"999999"];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.font = [UIFont systemFontOfSize:11];
        
        [self.view addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(sureBtn.mas_top).with.offset(-20);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenW, 11));
        }];
        self.promptLabel = promptLabel;
        
    }

//    }];
    
    return headerView;
}
#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_proHourTimeList count];
    }
    
    return [_proMinuteTimeList count];
}
#pragma Mark -- UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    //    if (component == 1) {
    //        return 40;
    //    }
    return 80;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString  *_proNameStr = [_proHourTimeList objectAtIndex:row];
        self.currentHour = _proNameStr;
        
        NSLog(@"nameStr=%@",_proNameStr);
    } else {
        NSString  *_proTimeStr = [_proMinuteTimeList objectAtIndex:row];
        self.currentMinute = _proTimeStr;
        NSLog(@"_proTimeStr=%@",_proTimeStr);
    }
    if (kScreenW > 320) {
        self.promptLabel.text = [NSString stringWithFormat:@"%@小时%@分钟后 将关闭该空调",self.currentHour,self.currentMinute];
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_proHourTimeList objectAtIndex:row];
    } else {
        return [_proMinuteTimeList objectAtIndex:row];
        
    }
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

