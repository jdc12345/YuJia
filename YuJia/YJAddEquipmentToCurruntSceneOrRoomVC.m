//
//  YJAddEquipmentToCurruntSceneOrRoomVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddEquipmentToCurruntSceneOrRoomVC.h"
#import "YJEquipmentListTVCell.h"

@interface YJAddEquipmentToCurruntSceneOrRoomVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation YJAddEquipmentToCurruntSceneOrRoomVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备管理";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
//    self.navigationController.navigationBar.translucent = false;
    [self httpRequestHomeInfo];
}
//请求所有设备数据
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mAllEquipment,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *equipmentList= responseObject[@"equipmentList"];
        for(NSDictionary *eDict in equipmentList){
            YJEquipmentModel *eModel = [YJEquipmentModel mj_objectWithKeyValues:eDict];
            [self.dataSource addObject:eModel];
            for (YJEquipmentModel *model in self.equipmentList) {
                if ([eModel.name isEqualToString:model.name]) {
                    [self.dataSource removeObject:eModel];//把已经存在的设备去除
                }
            }
        }
        if (self.dataSource.count==0) {
            [SVProgressHUD showInfoWithStatus:@"没有设备可以添加了"];
        }
        [self tableView];        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//布局列表
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[YJEquipmentListTVCell class] forCellReuseIdentifier:@"EquipmentManagerTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    return headView;
    
}
//懒加载
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJEquipmentModel *equipmentModel = self.dataSource[indexPath.row];
    self.itemClick(equipmentModel);//把选中的设备数据
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    YJEquipmentModel *equipmentModel = self.dataSource[indexPath.row];
    
    //    NSLog(@"第%ld row个数 %ld",tableView.tag -100,indexPath.row);
    // 图标  情景设置setting  灯light 电视tv 插座socket
    YJEquipmentListTVCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentManagerTableViewCell" forIndexPath:indexPath];
    homeTableViewCell.titleLabel.text = equipmentModel.name;
    if (equipmentModel.iconUrl.length >0) {//????
        
    }else{
//        homeTableViewCell.iconV.image = [UIImage imageNamed:mIcon[[equipmentModel.iconId integerValue]]];
        //设备类型序号枚举标签
        NSInteger equmentTag = [self getDeviceEnumWithIconid:equipmentModel.iconId];
        homeTableViewCell.iconV.image = [UIImage imageNamed:mIcon[equmentTag]];//根据类型序号确定图标
    }
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}
//public static int[]mIconId={0,1,2,3,4,5,6,7,8,9,10,11,12};
//public static String[]mDeviceName={"未识别的设备","门磁","门锁","开关","插座","灯","电视","窗帘","空调","温湿度计","情景面板","人体红外","网关"};
//根据设备iconid(类型序号)取对应图片
-(NSInteger)getDeviceEnumWithIconid:(NSString*)iconId{
    
    switch ([iconId integerValue]) {
        case 0:
            return mDeviceNameUnidentified;// 未识别的设备
        case 1:
            return mDeviceNameMagnetometer;// 门磁
        case 2:
            return mDeviceNameDoorLock;// 门锁
        case 3:
            return mDeviceNameSwitch;// 开关
        case 4:
            return mDeviceNameSocket;// 插座
        case 5:
            return mDeviceNameLight;// 灯
        case 6:
            return mDeviceNameTv;// 电视
        case 7:
            return mDeviceNameWindowCurtains;// 窗帘
        case 8:
            return mDeviceNameAirConditioner;// 空调
            
        case 9:
            return mDeviceNameHygrothermograph;// 温湿度计
            
        case 10:
            return mDeviceNameScenePanel;// 情景面板
            
        case 11:
            return mDeviceNameHumanInfrared;// 人体红外
            
        case 12:
            return mDeviceNameGateway;// 网关
            
            
        default:
            return mDeviceNameUnidentified;// 未识别的设备
    }
}
//- (void)action:(NSString *)actionStr{
//    NSLog(@"点什么点");
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navBarBgAlpha = @"1.0";
//}
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

