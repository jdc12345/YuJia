//
//  YJCreatActivitiesVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCreatActivitiesVC.h"
#import "UILabel+Addition.h"
#import "YJCreateActivitieTVCell.h"
#import "BRPlaceholderTextView.h"


static NSString* tableCellid = @"table_cell";
@interface YJCreatActivitiesVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,weak)UIButton *begainTimeBtn;
@property(nonatomic,weak)UIButton *endTimeBtn;
@property(nonatomic,weak)UIView *headerView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)BRPlaceholderTextView *contentView;

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
@property(nonatomic,assign)BOOL flagB;
@property(nonatomic,assign)BOOL flagE;
@end

@implementation YJCreatActivitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布活动";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加右侧发送按钮
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [postBtn setTitle:@"发布" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    postBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    postBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [postBtn addTarget:self action:@selector(postBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 104*kiphone6)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.headerView = headerView;
    [self setBtnWithFrame:CGRectMake(10*kiphone6, 15*kiphone6, (kScreenW-42*kiphone6)*0.5, 46*kiphone6) WithTitle:@"开始时间"andTag:101];
    [self setBtnWithFrame:CGRectMake((kScreenW-42*kiphone6)*0.5+32*kiphone6, 15*kiphone6, (kScreenW-42*kiphone6)*0.5, 46*kiphone6) WithTitle:@"结束时间"andTag:102];
    UILabel *promptLabel = [UILabel labelWithText:@"活动发布后暂不支持修改，请认真填写哦" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];
    [headerView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(self.begainTimeBtn.mas_bottom).offset(20*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCreateActivitieTVCell class] forCellReuseIdentifier:tableCellid];
//    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.estimatedRowHeight =  50*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.scrollEnabled = false;
    tableView.tableHeaderView = headerView;

    self.minusArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    self.hourArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
//    self.amPmArr = [NSMutableArray arrayWithObjects:@"上午",@"下午", nil];
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [self.headerView addSubview:btn];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
    btn.layer.cornerRadius = 3;
    btn.tag = tag;
    if (btn.tag==101) {
        self.begainTimeBtn = btn;
    }else{
        self.endTimeBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{

    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.endTimeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.endTimeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.flagE = false;
        if (self.flagB) {
            self.flagB=false;
        }else{
            self.flagB=true;
        }
        if (self.timePickerView) {
            if (self.timePickerView.hidden) {
                if (self.flagB) {
                    self.timePickerView.hidden = false;
                }
            }else{
                if (!self.flagB) {
                    self.timePickerView.hidden = true;
                }
            }
        }
        
    }else{
        self.begainTimeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.begainTimeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.flagB = false;
        if (self.flagE) {
            self.flagE=false;
        }else{
            self.flagE=true;
        }
        if (self.timePickerView) {
            if (self.timePickerView.hidden) {
                if (self.flagE) {
                    self.timePickerView.hidden = false;
                }
            }else{
                if (!self.flagE) {
                    self.timePickerView.hidden = true;
                }
            }
        }
    }
   
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
        NSString *dayTitle = [NSString stringWithFormat:@"%@ ",dayStr];
        [self.dayArr addObject:dayTitle];
        curDate = [NSDate dateWithTimeInterval:86400 sinceDate:curDate];
    }
    if (!self.timePickerView) {
        
        UIPickerView *pickView = [[UIPickerView alloc]init];
        [self.view addSubview:pickView];
        [self.view bringSubviewToFront:pickView];
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(66*kiphone6);
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
        
        //        format.AMSymbol = @"上午";
        //        format.PMSymbol = @"下午";
        //        format.dateFormat = @"aaa";
        //        NSString *timeStr = [format stringFromDate:now];
        //        if ([timeStr isEqualToString:@"上午"]) {
        //            [self pickerView:self.timePickerView didSelectRow:0 inComponent:1];
        //        }else{
        //            [self pickerView:self.timePickerView didSelectRow:1 inComponent:1];
        //
        //        }
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
    NSString *selectTime = [NSString stringWithFormat:@"%@%@:%@",self.day,self.hour,self.minus];
    self.selectTime = selectTime;
    if (self.flagB) {
        [self.begainTimeBtn setTitle:selectTime forState:UIControlStateNormal];
    }else if (self.flagE){
        [self.endTimeBtn setTitle:selectTime forState:UIControlStateNormal];
    }
    
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

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *itemArr = @[@"活动标题",@"活动地址",@"人       数",@"电       话"];
    YJCreateActivitieTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        cell.item = itemArr[indexPath.row];
        return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backView = backView;
    //输入框
    BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
    [backView addSubview:titleView];
    self.contentView = titleView;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(120*kiphone6);
    }];
    [titleView layoutIfNeeded];
    titleView.delegate = self;
    titleView.placeholder = @"活动内容...";
    //        titleView.imagePlaceholder = @"title";
    titleView.font=[UIFont boldSystemFontOfSize:13];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [titleView setPlaceholderFont:[UIFont systemFontOfSize:13]];
    [titleView setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
    //    titleField.borderStyle = UITextBorderStyleNone;
    //    //边框宽度
    //    [titleField.layer setBorderWidth:0.01f];
    [titleView setPlaceholderOpacity:0.6];
    [titleView addMaxTextLengthWithMaxLength:500 andEvent:^(BRPlaceholderTextView *text) {
        //            [self.titleView endEditing:YES];
        
        NSLog(@"----------");
    }];
    
    [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    
    [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
//        self.content = self.contentView.text;
        NSLog(@"end");
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.bottom.equalTo(titleView.mas_bottom);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
//    UISwitch *switchButton = [[UISwitch alloc]init];
//    switchButton.onTintColor= [UIColor colorWithHexString:@"00bfff"];
//    switchButton.tintColor = [UIColor colorWithHexString:@"cccccc"];
//    // 控件大小，不能设置frame，只能用缩放比例
//    switchButton.transform= CGAffineTransformMakeScale(0.8,0.75);
//    [backView addSubview:switchButton];
//    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(line.mas_bottom).offset(19*kiphone6);
//        make.right.offset(-10 *kiphone6);
//    }];
//    [switchButton setOn:NO];
//    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    UILabel *itemLabel = [UILabel labelWithText:@"其他小区可看" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];
//    [backView addSubview:itemLabel];
//    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(switchButton.mas_left).offset(-5*kiphone6);
//        make.centerY.equalTo(switchButton);
//    }];
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 158*kiphone6;
}
- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    //从userInfo里面取出来键盘最终的位置
//    NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect rect = [rectValue CGRectValue];
//    CGRect rectField = self.fieldBackView.frame;
//    CGRect newRect = CGRectMake(rectField.origin.x, rect.origin.y - rectField.size.height-64*kiphone6, rectField.size.width, rectField.size.height) ;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.fieldBackView.frame = newRect;
//    }];
    
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
//    
//    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
//    
//    NSUInteger location = replacementTextRange.location;
//    
//    if (textView.text.length + text.length > 500){
//        
//        if (location != NSNotFound){
//            
//            [textView resignFirstResponder];
//        }
//        return NO;
//        
//    }  else if (location != NSNotFound){
//        
//        [textView resignFirstResponder];
//                return NO;
//    }
//    return YES;
//}
- (void)postBtnClick:(UIButton*)sender {

    YJCreateActivitieTVCell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *title = [nameCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJCreateActivitieTVCell *addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *address = [addressCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJCreateActivitieTVCell *numberCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *number = [numberCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YJCreateActivitieTVCell *telCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//    NSString *telN = [telCell.contentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSInteger telNum = [telCell.contentField.text integerValue];
    NSString *content = [self.contentView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *starttimeString = [self.begainTimeBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *endtimeString = [self.endTimeBtn.titleLabel.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
http://localhost:8080/smarthome/mobileapi/activity/PublishActivity.do?token=ACDCE729BCE6FABC50881A867CAFC1BC
//    &activityTheme=%E5%94%B1%E6%AD%8C
//    &activityContent=%E7%BA%A6%E5%A5%B3%E6%9C%8B%E5%8F%8B%E5%8E%BB%E5%94%B1%E6%AD%8C
//    &activityAddress=KTV
//    &activityNumber=3
//    &starttimeString=2017-5-31%2011:11:11
//    &endtimeString=2017-5-31%2018:30:30
    [SVProgressHUD show];// 动画开始
    NSString *postUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/PublishActivity.do?token=%@&activityTheme=%@&activityContent=%@&activityAddress=%@&activityNumber=%@&starttimeString=%@&endtimeString=%@&activityTelephone=%ld",mPrefixUrl,mDefineToken1,title,content,address,number,starttimeString,endtimeString,telNum];
    [[HttpClient defaultClient]requestWithPath:postUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
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
