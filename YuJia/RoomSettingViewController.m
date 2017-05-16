//
//  RoomSettingViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "RoomSettingViewController.h"
#import "EquipmentTableViewCell.h"
#import "EquipmentModel.h"
@interface RoomSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation RoomSettingViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:@"EquipmentTableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        _tableView.tableFooterView = [self customFootView];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UILabel *sectionTitleLabel  = [[UILabel alloc]init];
    sectionTitleLabel.text = @"所 属 设 备";
    sectionTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    sectionTitleLabel.font = [UIFont systemFontOfSize:14];
    
    
    [sectionView addSubview:sectionTitleLabel];
    WS(ws);
    [sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionView).with.offset(18);
        make.left.equalTo(sectionView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,14));
    }];
    
    return sectionView;
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.roomModel.equipmentList.count +1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    // 图标  情景设置setting  灯light 电视tv 插座socket
    EquipmentTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentTableViewCell" forIndexPath:indexPath];
    if(indexPath.row == self.roomModel.equipmentList.count){
        homeTableViewCell.titleLabel.text = @"添加";
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"+-1"];
        [homeTableViewCell cellMode:YES];
        homeTableViewCell.switch0.hidden = YES;
    }else{
        EquipmentModel *equipmentModel;
        equipmentModel = self.roomModel.equipmentList[indexPath.row];
        homeTableViewCell.titleLabel.text = equipmentModel.name;
        if (equipmentModel.iconUrl.length >0) {
            
        }else{
            homeTableViewCell.titleLabel.text = equipmentModel.name;
            homeTableViewCell.iconV.image = [UIImage imageNamed:mIcon[[equipmentModel.iconId integerValue] ]];
        }
        [homeTableViewCell cellMode:YES];
        if ([equipmentModel.state isEqualToString:@"0"]) {
            homeTableViewCell.switch0.on = YES;
        }else{
            homeTableViewCell.switch0.on = NO;
        }
    }
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}
- (void)action:(NSString *)actionStr{
    NSLog(@"点什么点");
}
- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 135)];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSString *sightName = @"房 间 名 称";
    NSString *startW = @"添 加 照 片";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [sightName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
    sightNameText.text = self.roomModel.roomName;
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add_roomSet"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn sizeToFit];

    
    
    CGRect frame = CGRectMake(0, 0, 10.0, 30);
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    sightNameText.leftViewMode = UITextFieldViewModeAlways;
    sightNameText.leftView = leftview;
    
    
    UILabel *sightNameLabel = [[UILabel alloc]init];
    sightNameLabel.text = sightName;
    sightNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    sightNameLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *startWLabel = [[UILabel alloc]init];
    startWLabel.text = startW;
    startWLabel.textColor = [UIColor colorWithHexString:@"333333"];
    startWLabel.font = [UIFont systemFontOfSize:14];
    
    
    [headView addSubview:sightNameText];
    [headView addSubview:addBtn];
    [headView addSubview:sightNameLabel];
    [headView addSubview:startWLabel];
    
    WS(ws);
    [sightNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).with.offset(25);
        make.left.equalTo(headView).with.offset(35 +rect.size.width);
        make.size.mas_equalTo(CGSizeMake(210 ,30));
    }];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sightNameText.mas_bottom).with.offset(25);
        make.left.equalTo(headView).with.offset(35 +rect.size.width);
//        make.size.mas_equalTo(CGSizeMake(210 ,30));
    }];
    
    [sightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sightNameText.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(rect.size.width +5,14));
    }];
    [startWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addBtn.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(rect.size.width +5,14));
    }];
    
    return headView;
}\
- (UIView *)customFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 74)];
    footView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(httpRequestInfo) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [footView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(30);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    
    return footView;
}
- (void)httpRequestInfo{
    NSMutableArray *equipmentList = [[NSMutableArray alloc]initWithCapacity:2];;
    for (EquipmentModel *equipment in self.roomModel.equipmentList) {
        [equipmentList addObject: [equipment properties_aps]];
    }
    NSLog(@"%@",equipmentList);
    NSData *picData = UIImageJPEGRepresentation([UIImage imageNamed:@"add"], 0.5);
//    id formData;
//    [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"uploadFile%ld",(long)1] fileName:@"123" mimeType:@"image/png"];

    
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:equipmentList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{
                           @"id":self.roomModel.info_id,
                           @"token":mDefineToken,
                           @"equipmentList":jsonString,
                           @"roomName":self.roomModel.roomName,
                           @"oid":self.roomModel.oid,
                           @"familyId":self.roomModel.familyId,
                           @"file":picData
                           };
//    NSLog(@"id == %@",self.roomModel.info_id);
    
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mRoomSave] method:1 parameters:dict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
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
