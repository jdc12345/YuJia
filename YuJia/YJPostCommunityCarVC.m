//
//  YJPostCommunityCarVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPostCommunityCarVC.h"
#import "UILabel+Addition.h"
#import "YJCreateActivitieTVCell.h"
#import "YJCreateActivitieTVCell.h"

static NSString* tableCellid = @"table_cell";
@interface YJPostCommunityCarVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *driverBtn;
@property(nonatomic,weak)UIButton *passionBtn;

@property(nonatomic,weak)UIButton *displayTimeBtn;
@property(nonatomic,strong)NSArray *minusArr;
@property(nonatomic,strong)NSMutableArray *amPmArr;
@property(nonatomic,strong)NSMutableArray *monthArr;
@property(nonatomic,strong)NSMutableArray *dayArr;
@property(nonatomic,strong)NSArray *hourArr;
@property(nonatomic,strong)NSString *selectTime;
@property(nonatomic,strong)NSString *day;
@property(nonatomic,strong)NSString *amPm;
@property(nonatomic,strong)NSString *minus;
@property(nonatomic,strong)NSString *hour;
@property(nonatomic,weak)UIPickerView *timePickerView;
@end

@implementation YJPostCommunityCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区拼车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加右侧发送按钮
    UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [deleateBtn setTitle:@"发布" forState:UIControlStateNormal];
    deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleateBtn addTarget:self action:@selector(postBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    [self setupUI];
}
-(void)setupUI{
    //添加大tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(5*kiphone6);
    }];
    [tableView registerClass:[YJCreateActivitieTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 235*kiphone6;
    //添加tb头部试图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 142*kiphone6)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [UILabel labelWithText:@"活动发布后暂不支持修改，请认真填写哦" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//提示label
    [headerView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_top).offset(21*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UIView *line1 = [[UIView alloc]init];//添加line
    line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(headerView.mas_top).offset(42*kiphone6);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UILabel *typeLabel = [UILabel labelWithText:@"身    份" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];//发起人类型标题
    [headerView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line1.mas_bottom).offset(25*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UIButton *driverTypeBtn = [[UIButton alloc]init];//司机类型选择
    [driverTypeBtn setImage:[UIImage imageNamed:@"type_Choice"] forState:UIControlStateNormal];
    [driverTypeBtn setImage:[UIImage imageNamed:@"type_Choiced"] forState:UIControlStateSelected];
    driverTypeBtn.tag = 101;
    driverTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    driverTypeBtn.layer.masksToBounds = true;
    driverTypeBtn.layer.cornerRadius = 20*kiphone6;
    [headerView addSubview:driverTypeBtn];
    [driverTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLabel.mas_right).offset(25*kiphone6);
        make.centerY.equalTo(line1.mas_bottom).offset(25*kiphone6);
        make.width.height.offset(40*kiphone6);
    }];
    self.driverBtn = driverTypeBtn;
    [driverTypeBtn addTarget:self action:@selector(typeChioce:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *driveContentLabel = [UILabel labelWithText:@"司机" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//司机
    [headerView addSubview:driveContentLabel];
    [driveContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line1.mas_bottom).offset(25*kiphone6);
        make.left.equalTo(driverTypeBtn.mas_right).offset(5*kiphone6);
    }];
    
    UIButton *passengerTypeBtn = [[UIButton alloc]init];//乘客类型选择
    [passengerTypeBtn setImage:[UIImage imageNamed:@"type_Choice"] forState:UIControlStateNormal];
    [passengerTypeBtn setImage:[UIImage imageNamed:@"type_Choiced"] forState:UIControlStateSelected];
    passengerTypeBtn.tag = 102;
    passengerTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    passengerTypeBtn.layer.masksToBounds = true;
    passengerTypeBtn.layer.cornerRadius = 20*kiphone6;
    [headerView addSubview:passengerTypeBtn];
    [passengerTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driveContentLabel.mas_right).offset(8*kiphone6);
        make.centerY.equalTo(line1.mas_bottom).offset(25*kiphone6);
        make.width.height.offset(40*kiphone6);
    }];
    self.passionBtn = passengerTypeBtn;
    [passengerTypeBtn addTarget:self action:@selector(typeChioce:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *passengerContentLabel = [UILabel labelWithText:@"乘客" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//司机
    [headerView addSubview:passengerContentLabel];
    [passengerContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line1.mas_bottom).offset(25*kiphone6);
        make.left.equalTo(passengerTypeBtn.mas_right).offset(5*kiphone6);
    }];
    UIView *line2 = [[UIView alloc]init];//添加line
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(line1.mas_bottom).offset(50*kiphone6);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UILabel *timeItemLabel = [UILabel labelWithText:@"出发时间" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//时间标题
    [headerView addSubview:timeItemLabel];
    [timeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line2.mas_bottom).offset(25*kiphone6);
    }];
    UIButton *displayTimeBtn = [[UIButton alloc]init];
    [headerView addSubview:displayTimeBtn];
    [displayTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeItemLabel.mas_right).offset(25*kiphone6);
        make.centerY.equalTo(timeItemLabel);
        make.width.offset(140*kiphone6);
    }];
    displayTimeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [displayTimeBtn setTitle:@"0月0日 00:00" forState:UIControlStateNormal];
    [displayTimeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    displayTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    displayTimeBtn.layer.borderWidth = 1.5;
    displayTimeBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    displayTimeBtn.layer.cornerRadius = 3;
    [displayTimeBtn addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    self.displayTimeBtn = displayTimeBtn;
    UIView *line3 = [[UIView alloc]init];//添加line
    line3.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(line2.mas_bottom).offset(50*kiphone6);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];

    tableView.tableHeaderView = headerView;
    self.minusArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    self.hourArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *itemArr = @[@"出 发 地",@"目 的 地",@"联系电话",@"乘坐人数"];
    YJCreateActivitieTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.item = itemArr[indexPath.row];
    if (indexPath.row>1) {
        cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
        [self addToolSender:cell.contentField];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
//    backView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
////    self.backView = backView;
//    
////    UISwitch *switchButton = [[UISwitch alloc]init];
////    switchButton.onTintColor= [UIColor colorWithHexString:@"00bfff"];
////    switchButton.tintColor = [UIColor colorWithHexString:@"cccccc"];
////    // 控件大小，不能设置frame，只能用缩放比例
////    switchButton.transform= CGAffineTransformMakeScale(0.8,0.75);
////    [backView addSubview:switchButton];
////    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerY.equalTo(backView);
////        make.right.offset(-10 *kiphone6);
////    }];
////    [switchButton setOn:NO];
////    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
////    UILabel *itemLabel = [UILabel labelWithText:@"其他小区可看" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];
////    [backView addSubview:itemLabel];
////    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.right.equalTo(switchButton.mas_left).offset(-5*kiphone6);
////        make.centerY.equalTo(switchButton);
////    }];
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
//    [backView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.left.offset(0);
//        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
//    }];
//    return backView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 37*kiphone6;
//}
#pragma mark - BtnClick
- (void)typeChioce:(UIButton*)sender{

    sender.selected = !sender.isSelected;
    if (sender.selected) {
        if (sender.tag == 101) {
            self.passionBtn.selected = false;
        }else if (sender.tag == 102){
            self.driverBtn.selected = false;
        }
    }
}
//- (void)switchAction:(id)sender{
//    
//}
- (void)pickerView:(id)sender{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDate *curDate = [calendar dateFromComponents:dateComponent];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    
    [comps2 setDay:31];
    if (month<11) {
        [comps2 setMonth:month+2];
        [comps2 setYear:year];
    }else if(month==11){
        [comps2 setMonth:1];
        [comps2 setYear:year+1];
    }else{
        [comps2 setMonth:2];
        [comps2 setYear:year+1];
    }
    NSDate *endDate = [calendar dateFromComponents:comps2];
    
    self.dayArr = [NSMutableArray array];
    while([curDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]) //you can also use the earlier-method
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"ee";
        NSString *weekDayStr = [dateFormatter stringFromDate:curDate];
        NSInteger w = [weekDayStr integerValue];
        dateFormatter.dateFormat = @"MM-dd";
        NSString *dayStr = [dateFormatter stringFromDate:curDate];
        switch (w) {
            case 01:
                weekDayStr= @"星期天";
                break;
            case 02:
                weekDayStr= @"星期一";
                break;
            case 03:
                weekDayStr= @"星期二";
                break;
            case 04:
                weekDayStr= @"星期三";
                break;
            case 05:
                weekDayStr= @"星期四";
                break;
            case 06:
                weekDayStr= @"星期五";
                break;
            case 07:
                weekDayStr= @"星期六";
                break;
                
            default:
                break;
        }
        
//        NSString *dayTitle = [NSString stringWithFormat:@"%@ %@",dayStr,weekDayStr];
//        [self.dayArr addObject:dayTitle];//加星期天的格式
        NSString *dayTitle = [NSString stringWithFormat:@"%@",dayStr];
        [self.dayArr addObject:dayTitle];
        curDate = [NSDate dateWithTimeInterval:86400 sinceDate:curDate];
    }
    if (!self.timePickerView) {
        
        UIPickerView *pickView = [[UIPickerView alloc]init];
        [self.view addSubview:pickView];
        [self.view bringSubviewToFront:pickView];
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.displayTimeBtn.mas_bottom);
            make.left.offset(10*kiphone6);
            make.right.offset(-10*kiphone6);
            make.height.offset(120*kiphone6);
        }];
        pickView.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.showsSelectionIndicator = YES;
        self.timePickerView = pickView;
        
        //            设置初始默认值
        [self pickerView:self.timePickerView didSelectRow:0 inComponent:0];
        [self.timePickerView selectRow:0 inComponent:0 animated:true];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        format.dateFormat = @"HH";
        NSString *timeStr = [format stringFromDate:now];
        NSInteger row = [timeStr integerValue];
        [self pickerView:self.timePickerView didSelectRow:row inComponent:1];
        [self.timePickerView selectRow:row inComponent:1 animated:true];
        format.dateFormat = @"mm";
        timeStr = [format stringFromDate:now];
        row = [timeStr integerValue];
        [self pickerView:self.timePickerView didSelectRow:row inComponent:2];
        [self.timePickerView selectRow:row inComponent:2 animated:true];
    }else{
        if (self.timePickerView.hidden) {
            self.timePickerView.hidden = false;
        }else{
            self.timePickerView.hidden = true;
        }
    }
  
}
#pragma mark - pickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dayArr.count;
        //    }else if (component == 1){
        //        return self.amPmArr.count;
    }else if (component == 1){
        return self.hourArr.count;
    }else{
        return self.minusArr.count;
    }
    
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component==0) {
        return pickerView.bounds.size.width*0.5;
    }
    return pickerView.bounds.size.width*0.25;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0*kiphone6;
    
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        self.day = self.dayArr[row];
        
        //    }else if (component == 1){
        //        self.amPm = [NSString stringWithFormat:@"%@",self.amPmArr[row]];
    }else if (component == 1){
        self.hour = [NSString stringWithFormat:@"%@",self.hourArr[row]];
    }else if (component == 2){
        self.minus = [NSString stringWithFormat:@"%@",self.minusArr[row]];
    }
    NSString *selectTime = [NSString stringWithFormat:@"%@ %@:%@",self.day,self.hour,self.minus];
    self.selectTime = selectTime;
    [self.displayTimeBtn setTitle:selectTime forState:UIControlStateNormal];
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        return self.dayArr[row];
        //    } else if (component == 1){
        //        self.amPm = [NSString stringWithFormat:@"%@",self.amPmArr[row]];
        //        return self.amPm;
        
    } else if (component == 1){
        NSString *hou = [NSString stringWithFormat:@"%@时",self.hourArr[row]];
        return hou;
        
    }else {
        NSString *minu = [NSString stringWithFormat:@"%@分",self.minusArr[row]];
        return minu;
        
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    if (component == 0) {
        [label setText:[self.dayArr objectAtIndex:row]];
        //    }else if (component == 1){
        //        [label setText:[self.monthArr objectAtIndex:row]];
    }
    else if (component == 1){
        [label setText:[NSString stringWithFormat:@"%@时",self.hourArr[row]]];
    }
    else if (component == 2){
        [label setText:[NSString stringWithFormat:@"%@分",self.minusArr[row]]];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (void)postBtnClick:(UIButton*)sender {
    
    YJCreateActivitieTVCell *startCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *startAddress = [startCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJCreateActivitieTVCell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *endAddress = [addressCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJCreateActivitieTVCell *numberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *number = [numberCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJCreateActivitieTVCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    //    NSString *telN = [telCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSInteger telNum = [telCell.contentField.text integerValue];
    NSString *timeString = [self.displayTimeBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSInteger type = 0;
    if (self.driverBtn.selected) {
        type = 2;
    }else if (self.passionBtn.selected){
        type = 1;
    }
    
http://localhost:8080/smarthome/mobileapi/carpooling/PublishCarpooling.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &ctype=2
//    &startTime=2017-05-25%2017:20:00
//    &departurePlace=%E6%B6%BF%E5%B7%9E%E5%B9%BF%E5%9C%BA%E8%BF%99%E5%84%BF
//    &end=%E5%8C%97%E4%BA%AC%E5%85%AD%E9%87%8C%E6%A1%A5
//    &cnumber=3
//    &telephone=18909898987
    [SVProgressHUD show];// 动画开始
    NSString *postUrlStr = [NSString stringWithFormat:@"%@/mobileapi/carpooling/PublishCarpooling.do?token=%@&ctype=%ld&startTime=%@&departurePlace=%@&end=%@&cnumber=%@&telephone=%ld",mPrefixUrl,mDefineToken1,type,timeString,startAddress,endAddress,number,telNum];
    [[HttpClient defaultClient]requestWithPath:postUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        return ;
    }];
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
