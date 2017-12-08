//
//  YJReportRepairVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJReportRepairVC.h"
#import "UILabel+Addition.h"
#import "YJRepairBaseInfoTableViewCell.h"
#import "BRPlaceholderTextView.h"
#import "YJPhotoFlowLayout.h"
#import "YJPhotoAddBtnCollectionViewCell.h"
#import <HUImagePickerViewController.h>
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import "YJRepairSectionTwoTableViewCell.h"
#import "YJRepairRecordTableViewCell.h"
#import "AFNetworking.h"
#import "YJReportRepairRecordModel.h"
#import <MJRefresh.h>
//#import "UIViewController+Cloudox.h"
#import "YJRepairRecoderVC.h"
#import "YJPropertyAddressModel.h"
#import "YJHomeHouseInfoModel.h"

static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJReportRepairVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSMutableArray *dayArr;
@property(nonatomic,strong)NSArray *hourArr;
@property(nonatomic,strong)NSString *selectTime;//显示在cell上的时间
@property(nonatomic,strong)NSString *selectReportTime;//进行报修提交的时间
@property(nonatomic,strong)NSString *day;
@property(nonatomic,strong)NSString *hour;
@property(nonatomic,weak)UIPickerView *timePickerView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UITextField *telNumberField;
@property(nonatomic,weak)UITextField *passWordField;
@property(nonatomic,weak)UIButton *repairBtn;
@property(nonatomic,weak)UIButton *recordBtn;
@property(nonatomic,weak)UIButton *firstTypeBtn;
@property(nonatomic,weak)UIButton *secondTypeBtn;
@property(nonatomic,weak)UIButton *thirdTypeBtn;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,strong)NSString *repairType;
@property(nonatomic,strong)NSString *repairTypeId;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)BRPlaceholderTextView *titleView;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, assign)NSInteger stateFlag;//报修状态按钮标记
//
@property(nonatomic,weak)UITableView *recordTableView;
@property(nonatomic,strong)NSMutableArray *recordArr;
@property(nonatomic,strong)NSMutableArray *addresses;//当前用户认证的地址集合
@property(nonatomic, assign)long familyId;//当前用户所在家的ID
@property(nonatomic,weak)UIToolbar * topView;//时间选择器工具栏
@property(nonatomic,weak)UIView *coverView;//时间选择器背景蒙布
@end

@implementation YJReportRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报事报修";
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self addTypeViewWith:@[@"水电燃气",@"房屋报修",@"公共设施"]];
    self.selectTime = @"请选择您期望的维修时间";
    [self loadData];//请求当前用户地址id
    [self setupUI];
    [self timeData];
    //添加右侧报修记录按钮
    UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [deleateBtn setTitle:@"报修记录" forState:UIControlStateNormal];
    [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    deleateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleateBtn addTarget:self action:@selector(informationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
//查询业主(认证通过的家庭地址)地址
- (void)loadData {
    //    http://192.168.1.55:8080/smarthome/mobileapi/family/findFamilyAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC   查询业主(认证通过的家庭地址)地址
    [SVProgressHUD show];// 动画开始
    NSString *addressUrlStr = [NSString stringWithFormat:@"%@token=%@",mMyHomeListInfo,mDefineToken];
    [[HttpClient defaultClient]requestWithPath:addressUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *addressArr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *aDict in addressArr) {
                YJHomeHouseInfoModel *houseModle = [YJHomeHouseInfoModel mj_objectWithKeyValues:aDict];
                [mArr addObject:houseModle];
                if (houseModle.defaults) {
                    self.familyId = [houseModle.info_id integerValue];//当前用户地址id
                }
            }
            self.addresses = mArr;
            [SVProgressHUD dismiss];// 动画结束
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
                [SVProgressHUD showErrorWithStatus:@"你还没有进行地址认证"];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
}
//添加tableView
-(void)setupUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeView.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.bottom.offset(0);
    }];
    tableView.layer.cornerRadius = 10;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate =self;
    tableView.dataSource = self;
}
//报修记录页面跳转
-(void)informationBtnClick{
    YJRepairRecoderVC *vc = [[YJRepairRecoderVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
//计算时间数据
-(void)timeData{
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
//        dateFormatter.dateFormat = @"ee";
//        NSString *weekDayStr = [dateFormatter stringFromDate:curDate];
//        NSInteger w = [weekDayStr integerValue];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dayStr = [dateFormatter stringFromDate:curDate];
//        switch (w) {
//            case 01:
//                weekDayStr= @"星期天";
//                break;
//            case 02:
//                weekDayStr= @"星期一";
//                break;
//            case 03:
//                weekDayStr= @"星期二";
//                break;
//            case 04:
//                weekDayStr= @"星期三";
//                break;
//            case 05:
//                weekDayStr= @"星期四";
//                break;
//            case 06:
//                weekDayStr= @"星期五";
//                break;
//            case 07:
//                weekDayStr= @"星期六";
//                break;
//                
//            default:
//                break;
//        }
        
        //        NSString *dayTitle = [NSString stringWithFormat:@"%@ %@",dayStr,weekDayStr];
        NSString *dayTitle = [NSString stringWithFormat:@"%@ ",dayStr];
        [self.dayArr addObject:dayTitle];
        curDate = [NSDate dateWithTimeInterval:86400 sinceDate:curDate];
    }
    self.hourArr = @[@"09:00-13:00",@"13:00-18:00",@"18:00-22:00"];//小时时间段

}
-(void)addTypeViewWith:(NSArray*)typeArr{
    UIImageView *view = [[UIImageView alloc]init];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"address_backPhoto"];
    [self.view addSubview:view];
    self.typeView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64);
        make.left.right.offset(0);
        make.height.offset(89*kiphone6);
    }];
    NSArray *imageSelecteds = @[@"click-water",@"click-house",@"click-tree"];
    NSArray *imageNomals = @[@"water",@"house",@"tree"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:imageNomals[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageSelecteds[i]] forState:UIControlStateSelected];
        [btn setTitle:typeArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.frame = CGRectMake(35*kiphone6+i*120*kiphone6, 0*kiphone6, 70*kiphone6, 89*kiphone6);
        [self initButton:btn];
        btn.tag = 51+i;
        if (btn.tag == 51) {
            self.firstTypeBtn = btn;
            btn.selected = true;
        self.repairTypeId = [NSString stringWithFormat:@"%d",1];
        }else if (btn.tag == 52){
            self.secondTypeBtn = btn;
        }else{
            self.thirdTypeBtn = btn;
        }
        [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = true;
        btn.userInteractionEnabled = true;
    }
}
//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 10;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
-(void)selectType:(UIButton*)sender{
    self.stateFlag = sender.tag;//记录保修类型
    sender.selected = true;
    if (sender.tag == 51) {
        self.repairTypeId = [NSString stringWithFormat:@"%d",1];
        self.secondTypeBtn.selected = false;
        self.thirdTypeBtn.selected = false;
    }else if (sender.tag == 52){
        self.repairTypeId = [NSString stringWithFormat:@"%d",2];
        self.firstTypeBtn.selected = false;
        self.thirdTypeBtn.selected = false;
    }else{
        self.repairTypeId = [NSString stringWithFormat:@"%d",3];
        self.firstTypeBtn.selected = false;
        self.secondTypeBtn.selected = false;
    }
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section==0) {
        YJRepairBaseInfoTableViewCell *cell = [[YJRepairBaseInfoTableViewCell alloc]init];
        return cell;
    }
    
    YJRepairSectionTwoTableViewCell *cell = [[YJRepairSectionTwoTableViewCell alloc]init];;
    cell.item = self.selectTime;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20*kiphone6, 5*kiphone6)];
    if (section==0) {
        backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }else{
        backView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        //输入框
        BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
        [backView addSubview:titleView];
        self.titleView = titleView;
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10*kiphone6);
            make.bottom.equalTo(backView.mas_top).offset(70*kiphone6);
            make.right.offset(-10*kiphone6);
            make.height.offset(70*kiphone6);
        }];
        [titleView layoutIfNeeded];
        titleView.delegate = self;
        titleView.placeholder = @"请描述您要保修的详情...";
        titleView.font=[UIFont boldSystemFontOfSize:13];
        [titleView setBackgroundColor:[UIColor whiteColor]];
        [titleView setPlaceholderFont:[UIFont systemFontOfSize:13]];
        [titleView setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
        [titleView setPlaceholderOpacity:0.6];
        [titleView addMaxTextLengthWithMaxLength:300 andEvent:^(BRPlaceholderTextView *text) {
            
            NSLog(@"----------");
        }];
        
        [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
            NSLog(@"begin");
        }];
        
        [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
            self.content = self.titleView.text;
            NSLog(@"end");
        }];

        //photoCollectionView
        UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJPhotoFlowLayout alloc]init]];
        [backView addSubview:photoCollectionView];
        self.collectionView = photoCollectionView;
        photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.mas_bottom);
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

    }
     return backView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0*kiphone6;
    }else{
        if (self.imageArr.count>3) {
            return 173*kiphone6;
        }
        return 123*kiphone6;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    if (section==1) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
        btn.layer.borderWidth = 1;
        [backView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
            make.width.offset(325*kiphone6);
            make.height.offset(42*kiphone6);
        }];
        [btn addTarget:self action:@selector(reportRepair:) forControlEvents:UIControlEventTouchUpInside];
    }
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 140*kiphone6;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100*kiphone6;
    }
    return 50*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section==1&&indexPath.row==0) {
        if (!self.timePickerView) {
            self.edgesForExtendedLayout =UIRectEdgeNone;
            //        大蒙布View
            UIView *coverView = [[UIView alloc]init];
            coverView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
            coverView.alpha = 0.3;
            [self.view.window addSubview:coverView];
            self.coverView = coverView;
            [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.offset(0);
            }];
            coverView.userInteractionEnabled = YES;
            //添加tap手势：
                UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
//            将手势添加至需要相应的view中
            [coverView addGestureRecognizer:tapGesture];
            
            UIPickerView *pickView = [[UIPickerView alloc]init];
            [self.view.window addSubview:pickView];
            [self.view.window bringSubviewToFront:pickView];
            [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.height.offset(162*kiphone6);
            }];
            pickView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            pickView.dataSource = self;
            pickView.delegate = self;
            pickView.showsSelectionIndicator = YES;
            self.timePickerView = pickView;
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 52*kiphone6)];
            [topView setBarStyle:UIBarStyleDefault];
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame = CGRectMake(2, 5, 50, 25);
            [closeBtn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
            [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
            [closeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
            UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIButton *middelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            middelBtn.frame = CGRectMake(2, 5, 75, 25);
            [middelBtn setTitle:@"上门时间" forState:UIControlStateNormal];
            [middelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            UIBarButtonItem *titleBtn = [[UIBarButtonItem alloc]initWithCustomView:middelBtn];
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(2, 5, 50, 25);
            [btn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            NSArray * buttonsArray = [NSArray arrayWithObjects:cancleBtn,btnSpace1,titleBtn,btnSpace,doneBtn,nil];
            [topView setItems:buttonsArray];
            [self.view.window addSubview:topView];
            [self.view.window bringSubviewToFront:topView];
            self.topView = topView;
            [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.bottom.equalTo(pickView.mas_top);
            }];
            
            //            设置初始默认值
            [self pickerView:self.timePickerView didSelectRow:0 inComponent:0];
            [self pickerView:self.timePickerView didSelectRow:1 inComponent:1];
//            [self.timePickerView selectRow:0 inComponent:0 animated:true];
            [self.timePickerView selectRow:1 inComponent:1 animated:true];
        }else{
            self.timePickerView.hidden = false;
            self.coverView.hidden = false;
            self.topView.hidden = false;
        }
//        if (self.timePickerView) {
//            if (self.timePickerView.hidden) {
//                self.timePickerView.hidden = false;
//            }else{
//                self.timePickerView.hidden = true;
//            }
//        }else{
//            UIPickerView *pickView = [[UIPickerView alloc]init];
//            [self.view addSubview:pickView];
//            pickView.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
//            pickView.dataSource = self;
//            pickView.delegate = self;
//            pickView.showsSelectionIndicator = YES;
//            self.timePickerView = pickView;
//            CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//            CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
//            CGFloat y = CGRectGetMaxY(rect);
//            pickView.frame = CGRectMake(0, y+52*kiphone6, kScreenW, kScreenH-y-52*kiphone6);
//            //            设置初始默认值
//            [self pickerView:self.timePickerView didSelectRow:0 inComponent:0];
//            [self pickerView:self.timePickerView didSelectRow:0 inComponent:1];
//
//        }
    }
}
-(void)event:(UIGestureRecognizer*)tap{
    [self resignFirstResponderText];
}
-(void)resignFirstResponderText {
    [self.view endEditing:true];
    self.timePickerView.hidden = true;
    self.coverView.hidden = true;
    self.topView.hidden = true;
}
#pragma mark - pickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dayArr.count;
    }else{
        return self.hourArr.count;
    }

}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return pickerView.bounds.size.width/2;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 54*kiphone6;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.day = [NSString stringWithFormat:@"%@",self.dayArr[row]];
        
    }else if (component == 1){
        self.hour = [NSString stringWithFormat:@"%@",self.hourArr[row]];
    }
    self.selectTime = [NSString stringWithFormat:@"您期望的维修时间为:%@ %@",self.day,self.hour];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];  //你需要更新的组数中的cell
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    self.selectReportTime = [NSString stringWithFormat:@"%@%@",self.day,self.hour];
}

////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {
//        return [self.yearArr objectAtIndex:row];
//    } else if (component == 1){
//        return [self.monthArr objectAtIndex:row];
//        
//    } else if (component == 2){
//        return [self.dayArr objectAtIndex:row];
//        
//    }else if (component == 3){
//        return [self.hourArr objectAtIndex:row];
//        
//    }else {
//        return [self.minusArr objectAtIndex:row];
//        
//    }
//    
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    if (component == 0) {
        [label setText:[self.dayArr objectAtIndex:row]];
    }else if (component == 1){
        [label setText:[self.hourArr objectAtIndex:row]];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
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
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                self.titleView.text = self.content;//刷新后保存报修内容
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
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            self.titleView.text = self.content;//刷新后保存报修内容
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
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    self.titleView.text = self.content;//刷新后保存报修内容
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
- (void)reportRepair:(UIButton*)sender {
    YJRepairBaseInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.nameField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你的姓名"];
        return;
    }
    if (cell.telNumberField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你的电话号码"];
        return;
    }
    NSString *name = [cell.nameField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *telephone = [cell.telNumberField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (self.titleView.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你的报修内容"];
        return;
    }
    NSString *details = [self.titleView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (self.selectReportTime.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你期望的保修时间"];
        return;
    }
    NSString *processingTime = [self.selectReportTime stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

//http://192.168.1.55:8080/smarthome/mobileapi/repair/addRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC
//    &cname=风雪
//    &telephone=18782931356
//    &address=断天涯一单元一号楼
//    &details=屋顶漏水
//    &type=1
//    &processingTime=2017-05-08%2020:09:50
//http://192.168.1.55:8080/smarthome/mobileapi/repair/addRecord.do?token=ACDCE729BCE6FABC50881A867CAFC1BC（改过的）
//    &cname=风雪
//    &telephone=18782931356
//    &familyId =
//    &details=屋顶漏水
//    &type=1
//    &processingTime=2017-05-08%2020:09:50
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@/mobileapi/repair/addRecord.do?token=%@&cname=%@&telephone=%@&familyId=%ld&details=%@&type=%@&processingTime=%@",mPrefixUrl,mDefineToken1,name,telephone,self.familyId,details,self.repairTypeId,processingTime];    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:reportUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            [SVProgressHUD showSuccessWithStatus:@"报修成功!"];
            sender.enabled = true;
        }else{
            [SVProgressHUD showErrorWithStatus:message];
            sender.enabled = true;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息=====%@", error.description);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"报修失败!"];
        sender.enabled = true;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
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
