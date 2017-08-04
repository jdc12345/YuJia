//
//  YJSceneSetVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJSceneSetVC.h"
#import "UIBarButtonItem+Helper.h"
#import "UIViewController+Cloudox.h"
#import "YJHomeSceneFlowLayout.h"
#import "YJHomeSceneCollectionViewCell.h"
#import "YJEquipmentListModel.h"
#import "YJEquipmentrCollectionVCell.h"
#import "PopListTableViewController.h"
#import "ZYAlertSView.h"
#import "UILabel+Addition.h"

#define inputW 254*[UIScreen mainScreen].bounds.size.width/375.0 // 输入框宽度
#define inputH 30*[UIScreen mainScreen].bounds.size.width/375.0  // 输入框高度
static NSString* collectionCellid = @"collection_cell";
static NSString *headerViewIdentifier =@"hederview";
static NSString* eqCellid = @"eq_cell";
@interface YJSceneSetVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property(nonatomic, weak) UITextField *roomNameTF;//房间名称
@property(nonatomic,weak)UICollectionView *equipmentColView;//情景collectionView
@property (nonatomic, strong) NSMutableArray* addedEquipmentListData;//添加过设备的房间设备列表，也是数据源
//@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) CGFloat leftPodding;//启动条件下拉列表左侧距离屏幕距离

/**
 * 启动条件选择框
 */
@property (nonatomic, copy) UIButton *curAccount;//启动条件按钮
@property (nonatomic, weak) UIButton *openBtn;//

@property (nonatomic, strong) ZYAlertSView *alertView;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) NSArray *proHourTimeList;
@property (nonatomic, copy) NSArray *proMinuteTimeList;
@property (nonatomic, weak) UITextField *sightNameF;//情景名称


@property (nonatomic, copy) NSArray *selectStart;//启动条件列表
@property (nonatomic, weak) UILabel *startModelLabel;
///**
// * 当前账号头像
// */
//@property (nonatomic, copy) UIImageView *icon;

/**
 *  启动条件下拉列表
 */
@property (nonatomic, strong) PopListTableViewController *accountList;

/**
 *  下拉列表的frame
 */
@property (nonatomic) CGRect listFrame;

@end

@implementation YJSceneSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情景设置";
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#333333"] highlightedColor:[UIColor colorWithHexString:@"#00bfff"] target:self action:@selector(changeInfo)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.selectStart = @[@"定时启动",@"定位启动"];
    [self setUPUI];
}
-(void)setEquipmentListData:(NSArray *)equipmentListData{
    _equipmentListData = equipmentListData;
    YJEquipmentListModel *model = [[YJEquipmentListModel alloc]init];//添加按钮的model
    model.name = @"添加";
    model.icon = @"add_home";
    self.addedEquipmentListData = [NSMutableArray arrayWithArray:equipmentListData];
    [self.addedEquipmentListData addObject:model];
    [self.equipmentColView reloadData];
}
- (void)setUPUI{
    //添加设备列表
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJHomeSceneFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.equipmentColView = collectionView;
    // 注册单元格
    [collectionView registerClass:[YJEquipmentrCollectionVCell class] forCellWithReuseIdentifier:eqCellid];
    [collectionView registerClass:[YJHomeSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    //注册头视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    
}
- (void)action:(UIButton *)sender{
    NSLog(@"点什么点");
}
- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 205*kiphone6)];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSString *picSelect = @"图 标 选 择";
    NSString *sightName = @"情 景 名 称";
    NSString *startW = @"启 动 条 件";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [sightName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    UILabel *picselectLabel = [UILabel labelWithText:picSelect andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    UIButton *selectPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPictureBtn setImage:[UIImage imageNamed:@"add_home"] forState:UIControlStateNormal];
    [selectPictureBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//    selectPictureBtn.layer.masksToBounds = YES;
//    selectPictureBtn.layer.cornerRadius = 3;
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
    sightNameText.text = self.sceneName;
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
    self.roomNameTF = sightNameText;
    
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 254*kiphone6, 30*kiphone6)];
    
    CGRect frame = CGRectMake(0, 0, 10.0, 30*kiphone6);
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    sightNameText.leftViewMode = UITextFieldViewModeAlways;
    sightNameText.leftView = leftview;
    
    UILabel *sightNameLabel = [[UILabel alloc]init];
    sightNameLabel.text = sightName;
    sightNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *startWLabel = [[UILabel alloc]init];
    startWLabel.text = startW;
    startWLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    startWLabel.font = [UIFont systemFontOfSize:14];
    
    [headView addSubview:picselectLabel];
    [headView addSubview:selectPictureBtn];
    [headView addSubview:sightNameText];
    [headView addSubview:_curAccount];
    [headView addSubview:sightNameLabel];
    [headView addSubview:startWLabel];
    
    //    WS(ws);
    [selectPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).with.offset(25*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake(55*kiphone6 ,55*kiphone6));
    }];
    [picselectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectPictureBtn.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    [sightNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).with.offset(100*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake(254*kiphone6 ,30*kiphone6));
    }];
    [_curAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sightNameText.mas_bottom).with.offset(20*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake(254*kiphone6 ,30*kiphone6));
    }];
    
    [sightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sightNameText.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    [startWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_curAccount.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    
    // 设置下拉菜单
    self.leftPodding = 35*kiphone6 +rect.size.width;//下拉菜单距离左侧距离
    [self setPopMenu];
    return headView;
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{    
    return self.addedEquipmentListData.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row<self.addedEquipmentListData.count-1) {
        YJEquipmentrCollectionVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:eqCellid forIndexPath:indexPath];
        cell.functionList = self.addedEquipmentListData[indexPath.row];
        return cell;
    }
    // 去缓存池找
    YJHomeSceneCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.equipmentListModels = self.addedEquipmentListData[indexPath.row];
    //    cell.selected = false;
    return cell;
}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    
    
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        //添加头视图的内容
        UIView *headerView = [self personInfomation];
        [header addSubview:headerView];
        
        UIButton *addBtn = [[UIButton alloc]init];
        NSString *btnTitle = @"执 行 任 务";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect rect = [btnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
        [addBtn setTitle:btnTitle forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [header addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16*kiphone6);
            make.centerY.equalTo(headerView.mas_bottom).offset(25*kiphone6);
            make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
        }];
        //        [addBtn addTarget:self action:@selector(roomBtnClick) forControlEvents:UIControlEventTouchUpInside];//设备添加按钮的点击事件
        //        self.roomBtn = roomBtn;
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //
    //    }
    return nil;
}
//设置宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(kScreenW,255*kiphone6);
    
}


/**
 * 设置下拉菜单
 */
- (void)setPopMenu {
    
    // 1.1帐号选择框
    
    //    _curAccount.center = CGPointMake(self.view.center.x, 200);
    // 默认当前账号为已有账号的第一个
    //    Account *acc = _dataSource[0];
    [_curAccount setTitle:@"一键启动" forState:UIControlStateNormal];
    
    _curAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _curAccount.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    // 字体
    [_curAccount setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _curAccount.titleLabel.font = [UIFont systemFontOfSize:14.0];
    // 边框
    _curAccount.layer.cornerRadius = 2.5;
    _curAccount.clipsToBounds = YES;
    _curAccount.layer.borderWidth = 0.5;
    _curAccount.layer.borderColor = [UIColor colorWithHexString:@"#e9e9e9"].CGColor;
    // 显示框背景色
    [_curAccount setBackgroundColor:[UIColor whiteColor]];
    [_curAccount addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_curAccount];
    // 1.2图标
//    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, inputH-10, inputH-10)];
//    _icon.layer.cornerRadius = (inputH-10)/2;
//    [_icon setImage:[UIImage imageNamed:@""]];
    //    [_curAccount addSubview:_icon];
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn = [[UIButton alloc]init];
    [openBtn setImage:[UIImage imageNamed:@"v"] forState:UIControlStateNormal];
    [openBtn setImage:[UIImage imageNamed:@"^"] forState:UIControlStateSelected];
    [openBtn addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [openBtn sizeToFit];
    [_curAccount addSubview:openBtn];
    self.openBtn = openBtn;
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_curAccount.mas_centerY).with.offset(0);
        make.right.equalTo(_curAccount).with.offset(-10);
    }];
    
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList.delegate = self;
    // 数据
    _accountList.accountSource = self.selectStart;
    _accountList.isOpen = NO;
    _accountList.isCenter = NO;
    _accountList.cellHigh = 30*kiphone6;
    // 初始化frame
    [self updateListH];
    // 隐藏下拉菜单
    _accountList.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList];
    [self.view addSubview:_accountList.view];
}
/**
 *  监听代理更新下拉菜单
 */
- (void)updateListH {
//    CGFloat listH;
//    // 数据大于3个现实3个半的高度，否则显示完整高度
//    if (_dataSource.count > 3) {
//        listH = inputH * 3.5;
//    }else{
//        listH = inputH * _dataSource.count;
//    }
    _listFrame = CGRectMake(_leftPodding, 180*kiphone6, inputW, 2*inputH);
    _accountList.view.frame = _listFrame;
}
/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList {
    NSLog(@"123123");
    [self.view bringSubviewToFront:_accountList.view];
    _accountList.isOpen = !_accountList.isOpen;
    self.openBtn.selected = _accountList.isOpen;
    if (_accountList.isOpen) {
        _accountList.view.frame = _listFrame;
    }
    else {
        _accountList.view.frame = CGRectZero;
    }
}
- (void)back_click{
    
    CGFloat alertW = kScreenW;
    CGFloat alertH = 390*kiphone6;
    
    // titleView
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertW, alertH)];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择时间段";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
    _proHourTimeList = [[NSArray alloc]initWithObjects:@"0时",@"1时",@"2时",@"3时",@"4时",@"5时",@"6时",@"7时",@"8时",@"9时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时",nil];
    
    NSMutableArray *minute = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0 ; i<60 ; i++) {
        NSString *minuteStr = [NSString stringWithFormat:@"%d分",i];
        [minute addObject:minuteStr];
    }
    _proMinuteTimeList = minute;
    
    UILabel *repeatLabel = [[UILabel alloc]init];
    repeatLabel.text = @"重复";
    repeatLabel.textColor = [UIColor colorWithHexString:@"333333"];
    repeatLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:pickerView];
    [titleView addSubview:repeatLabel];
    [titleView addSubview:lineLabel];
    
//    WS(ws);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).with.offset(20);
        make.top.equalTo(titleView).with.offset(25);;
        make.size.mas_equalTo(CGSizeMake(120 ,14));
    }];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleLabel).with.offset(20);;
        make.size.mas_equalTo(CGSizeMake(kScreenW ,90));
    }];
    [repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).with.offset(20);
        make.top.equalTo(titleLabel).with.offset(135);;
        make.size.mas_equalTo(CGSizeMake(120 ,14));
    }];
    
    
    
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.bottom.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(alertW ,1));
    }];
    
    
    CGFloat btnW_Change = (kScreenW - 375)/4.0;
    NSArray *btnText_Array = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"全部"];
    
    for (int i = 0;  i<8 ; i++) {
        NSInteger row = 0;
        if (i >= 4)
            row = 1;
        
        UIButton *weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weekBtn.frame = CGRectMake(20 + (76 +10 +btnW_Change)*(i%4), 213 +row *45, 76 +btnW_Change, 30);
        weekBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [weekBtn setTitle:btnText_Array[i] forState:UIControlStateNormal];
        weekBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [weekBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [weekBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
        weekBtn.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
        weekBtn.layer.borderWidth = 1;
        weekBtn.layer.cornerRadius = 10;
        weekBtn.clipsToBounds = YES;
        [weekBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:weekBtn];
        
        NSLog(@"x = %d  y = %ld",i%4,213 +row *45);
    }
    
    
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    [sureBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 20;
    sureBtn.layer.masksToBounds = true;
    [titleView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleView).with.offset(-30);
        make.centerX.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    
    
    
    
    
    
    
    
    
    
    ZYAlertSView *alertV = [[ZYAlertSView alloc]initWithContentSize:CGSizeMake(alertW, alertH) TitleView:titleView selectView:nil sureView:nil andIsCenter:NO];
    [alertV show];
    self.alertView = alertV;
    
}
/**
 * 监听代理选定cell获取选中账号
 */
- (void)selectedCell:(NSInteger)index {
    // 更新当前选中账号
    //    Account *acc = _dataSource[index];
    
    NSString *title = self.selectStart[index];
    [_curAccount setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"定时启动"]) {
        [self back_click];
        self.selectStart = @[@"一键启动",@"定位启动"];
    }else if([title isEqualToString:@"定位启动"]){
        [self back_click_location];
        self.selectStart = @[@"一键启动",@"定时启动"];
    }else{
        self.selectStart = @[@"定时启动",@"定位启动"];
    }
    _accountList.accountSource = self.selectStart;
    [_accountList reloadDataSource];
    //    if (index == 0) {
    //        [self back_click];
    //    }else{
    //        [self back_click_location];
    //    }
    
    
//    [_icon setImage:[UIImage imageNamed:@""]];
    // 关闭菜单
    [self openAccountList];
}

- (void)btnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    }else{
        sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
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
    return 30;
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
        NSLog(@"nameStr=%@",_proNameStr);
    } else {
        NSString  *_proTimeStr = [_proMinuteTimeList objectAtIndex:row];
        NSLog(@"_proTimeStr=%@",_proTimeStr);
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

- (void)back_click_location{
    
    CGFloat alertW = kScreenW;
    CGFloat alertH = 258;
    
    // titleView
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertW, alertH)];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"启动条件 距家";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
    
    NSMutableArray *minute = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0 ; i<10 ; i++) {
        NSString *minuteStr = [NSString stringWithFormat:@"%dm",i*100];
        [minute addObject:minuteStr];
    }
    _proMinuteTimeList = minute;
    
    NSMutableArray *kmArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0 ; i<10 ; i++) {
        NSString *minuteStr = [NSString stringWithFormat:@"%dkm",i];
        [kmArray addObject:minuteStr];
    }
    _proHourTimeList = kmArray;
    
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:pickerView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).with.offset(20);
        make.top.equalTo(titleView).with.offset(25);;
        make.size.mas_equalTo(CGSizeMake(120 ,14));
    }];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);;
        make.size.mas_equalTo(CGSizeMake(kScreenW ,90));
    }];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    [sureBtn addTarget:self action:@selector(surePost) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 20;
    sureBtn.layer.masksToBounds = true;
    
    [titleView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleView).with.offset(-30);
        make.centerX.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    
    
    ZYAlertSView *alertV = [[ZYAlertSView alloc]initWithContentSize:CGSizeMake(alertW, alertH) TitleView:titleView selectView:nil sureView:nil andIsCenter:NO];
    [alertV show];
    self.alertView = alertV;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 6) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 6)];
    }
    
    if (range.location <6) {
        return YES;
    }else{
        return NO;
    }
}

- (void)surePost{
    // 定位启动
    if (_proHourTimeList.count == 10) {
        
        
    }else{  // 定时启动
        
    }
}

- (void)httpRequestInfo{
//    NSMutableArray *equipmentList = [[NSMutableArray alloc]initWithCapacity:2];;
//    for (EquipmentModel *equipment in self.sightModel.equipmentList) {
//        [equipmentList addObject: [equipment properties_aps]];
//    }
//    NSLog(@"%@",equipmentList);
//    if (self.sightNameF.text.length >0) {
//        self.sightModel.sceneName = self.sightNameF.text;
//    }
//    
//    
//    NSData *dictData = [NSJSONSerialization dataWithJSONObject:equipmentList options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
//    NSDictionary *dict = @{
//                           @"id":self.sightModel.info_id,
//                           @"token":mDefineToken,
//                           @"equipmentList":jsonString,
//                           @"sceneName":self.sightModel.sceneName,
//                           @"sceneModel":@"1",
//                           @"sceneTime":@"12:30",
//                           @"sceneDistance":@"11111",
//                           @"repeatMode":@"1,2,3"
//                           };
//    
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mSightSave] method:1 parameters:dict prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];
}
-(void)changeInfo{;
//    NSDictionary *dict = @{
//                           @"ids":self.sightModel.info_id,
//                           @"token":mDefineToken
//                           };
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mRemoveSigh] method:1 parameters:dict prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";    
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
