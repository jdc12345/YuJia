//
//  YJEquipmentSettingVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/25.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJEquipmentSettingVC.h"
#import "UIBarButtonItem+Helper.h"
//#import "UIViewController+Cloudox.h"
#import "PopListTableViewController.h"
#import "ZYAlertSView.h"
#import "UILabel+Addition.h"
//#import "YJAddScenePictureVC.h"
#import "YJEquipmentModel.h"
//#import "YJAddEquipmentToCurruntSceneOrRoomVC.h"
#import "YJRoomDetailModel.h"

#define inputW 254*[UIScreen mainScreen].bounds.size.width/375.0 // 输入框宽度
#define inputH 30*[UIScreen mainScreen].bounds.size.width/375.0  // 输入框高度

@interface YJEquipmentSettingVC ()<UITextFieldDelegate,AccountDelegate>
@property(nonatomic, weak) UITextField *sceneNameTF;//情景名称
//@property(nonatomic,weak)UICollectionView *equipmentColView;//情景collectionView
@property (nonatomic, strong) NSMutableArray* addedEquipmentListData;//添加过设备的房间设备列表，也是数据源
@property (nonatomic, strong) NSMutableArray *roomModelArr;//房间模型列表
@property (nonatomic, assign) CGFloat leftPodding;//启动条件下拉列表左侧距离屏幕距离

/**
 * 启动条件选择框
 */
@property (nonatomic, copy) UIButton *curAccount;//房间选择按钮
@property (nonatomic, weak) UIButton *openBtn;//
@property (nonatomic, weak) UIButton *selectPicBtn;//选择图标的btn
@property (nonatomic, strong) ZYAlertSView *alertView;

//@property (nonatomic, weak) UITextField *sightNameF;//情景名称


@property (nonatomic, copy) NSMutableArray *selectStart;//启动条件列表
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


@implementation YJEquipmentSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备设置";
    //    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = false;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#333333"] highlightedColor:[UIColor colorWithHexString:@"#00bfff"] target:self action:@selector(changeInfo:)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    self.selectStart = @[@"房间1",@"房间2"];
    [self httpRoomInfo];
//    [self setUPUI];
}

- (void)setUPUI{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 205*kiphone6)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    NSString *picSelect = @"设 备 图 标";
    NSString *sightName = @"设 备 名 称";
    NSString *startW = @"所 属 房 间";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [sightName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    UILabel *picselectLabel = [UILabel labelWithText:picSelect andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    UIButton *selectPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectPicBtn = selectPictureBtn;
    NSString *picName;
    if (self.eqipmentModel.iconUrl.length >0) {
        
    }else{
        picName = mIcon[[self.eqipmentModel.iconId integerValue]];//根据图标序号确定图标
    }
    [selectPictureBtn setImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
    [selectPictureBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    //    selectPictureBtn.layer.masksToBounds = YES;
    //    selectPictureBtn.layer.cornerRadius = 3;
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
//    sightNameText.text = mName[[self.eqipmentModel.iconId integerValue]];
    sightNameText.text = self.eqipmentModel.name;
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
    self.sceneNameTF = sightNameText;
    sightNameText.delegate = self;
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 254*kiphone6, 30*kiphone6)];
    for (YJRoomDetailModel *roomModel in self.roomModelArr) {
        if (self.eqipmentModel.roomId == roomModel.info_id) {
            [_curAccount setTitle:roomModel.roomName forState:UIControlStateNormal];
        }
    }
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
    
}
//点击更换图标按钮事件
- (void)action:(UIButton *)sender{
//    YJAddScenePictureVC *presentedVC = [[YJAddScenePictureVC alloc]init];
////    if (self.sceneModel.sceneIcon) {
////        presentedVC.curruntPicNum = [self.sceneModel.sceneIcon integerValue];
////    }
////    presentedVC.clickBtnBlock = ^(NSInteger curruntPicNum) {
////        self.sceneModel.sceneIcon = [NSString stringWithFormat:@"%ld",curruntPicNum];
////        NSString *picName = [self getPicName];
////        [self.selectPicBtn setImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
////    };
//    [self.navigationController pushViewController:presentedVC animated:true];
}

/**
 * 设置下拉菜单
 */
- (void)setPopMenu {
    
    // 1.1帐号选择框
    
    //    _curAccount.center = CGPointMake(self.view.center.x, 200);
    // 默认当前账号为已有账号的第一个
    //    Account *acc = _dataSource[0];
    for (YJRoomDetailModel *roomModel in self.roomModelArr) {
        if (roomModel.info_id == self.eqipmentModel.roomId) {
            [_curAccount setTitle:roomModel.roomName forState:UIControlStateNormal];
        }
//        else{
//            [_curAccount setTitle:@"所属房间" forState:UIControlStateNormal];
//        }
    }    
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
    _accountList.cellHigh = inputH;
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
        CGFloat listH;
        // 数据大于3个现实3个半的高度，否则显示完整高度
        if (self.selectStart.count > 3) {
            listH = inputH * 3.5;
        }else{
            listH = inputH * self.selectStart.count;
        }
    _listFrame = CGRectMake(_leftPodding, 180*kiphone6, inputW, listH);
    _accountList.view.frame = _listFrame;
}
/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList {
    //    NSLog(@"123123");
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
/**
 * 监听代理选定cell获取选中账号
 */
- (void)selectedCell:(NSInteger)index {
    // 更新当前选中账号
    //    Account *acc = _dataSource[index];
    
    NSString *title = self.selectStart[index];
    YJRoomDetailModel *roomModel = self.roomModelArr[index];
    self.eqipmentModel.roomId = roomModel.info_id;//赋值所选房间的id
    [_curAccount setTitle:title forState:UIControlStateNormal];
//    if ([title isEqualToString:@"定时启动"]) {
////        self.sceneModel.sceneModel = @"2";
////        [self back_click];
////        self.selectStart = @[@"一键启动",@"定位启动"];
//    }else if([title isEqualToString:@"定位启动"]){
////        self.sceneModel.sceneModel = @"3";
//        [self back_click_location];
////        self.selectStart = @[@"一键启动",@"定时启动"];
//    }else{
////        self.sceneModel.sceneModel = @"1";
////        self.selectStart = @[@"定时启动",@"定位启动"];
//    }
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

- (void)back_click_location{
    
    
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    self.sceneModel.sceneName = textField.text;
}
//请求用户房间数据
- (void)httpRoomInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mFindRoomList,mDefineToken2] method:0 parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
//        NSMutableArray *roomArray = [[NSMutableArray alloc]init];
        NSArray *roomList = responseObject[@"result"];
        for (NSDictionary *roomDict in roomList) {
            YJRoomDetailModel *roomModel = [YJRoomDetailModel mj_objectWithKeyValues:roomDict];
            [self.selectStart addObject:roomModel.roomName];//用以让列表显示房间名字
            [self.roomModelArr addObject:roomModel];//房间列表
        }
//        self.selectStart = roomArray;
        [self setUPUI];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请重试"];
    }];
}
//改变设备设置
-(void)changeInfo:(UIButton*)sender{
    sender.enabled = false;
    self.eqipmentModel.name = self.sceneNameTF.text;
   //保存或更新设备接口  // 单一设备改变状态
    //Method:POST
//    参数列表:
//    |参数名          |类型      |必需  |描述
//    |-----          |----     |---- |----
//    |token          |String   |Y    |令牌
//    |id             |Long     |Y    |编号
//    |name           |String   |Y    |设备名称
//    |iconId         |Long     |N    |设备图标编号
//    |iconUrl        |String   |N    |设备图标URL
//    |state          |Integer  |Y    |状态0=开1=关
//    |roomId         |Long     |Y    |房间编号外键
//    |serialNumber   |String   |N    |设备序列号唯一标识符
//    |extendState    |String   |N    |扩展状态控制，如灯的亮度，空调的温度等
//    |familyId       |Long     |Y    |家庭编号

    NSDictionary *dict = @{
                           @"id":self.eqipmentModel.info_id,
                           @"token":mDefineToken2,
                           @"name":self.eqipmentModel.name,
                           @"iconId":self.eqipmentModel.iconId,
                           @"iconUrl":self.eqipmentModel.iconUrl,
                           @"state":self.eqipmentModel.state,
                           @"roomId":self.eqipmentModel.roomId,
                           @"serialNumber":self.eqipmentModel.serialNumber,
                           @"extendState":self.eqipmentModel.toExtendState,
                           @"familyId":self.eqipmentModel.familyId,

                           };
//    [SVProgressHUD show];
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mEquipmentSave] method:1 parameters:dict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        [self.navigationController popViewControllerAnimated:true];//修改添加情景成功后返回上级页面
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        sender.enabled = true;
    }];
//
}
//懒加载
-(NSMutableArray *)selectStart{
    if (_selectStart == nil) {
        _selectStart = [NSMutableArray array];
    }
    return _selectStart;
}
-(NSMutableArray *)roomModelArr{
    if (_roomModelArr == nil) {
        _roomModelArr = [NSMutableArray array];
    }
    return _roomModelArr;
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
