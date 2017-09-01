//
//  FamilyPersonalViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "FamilyPersonalViewController.h"
//#import "FamilyPersonalTableViewCell.h"
#import "AddFamilyInfoTableViewCell.h"
#import "PersonalModel.h"
#import <UIImageView+WebCache.h>
#import "UIBarButtonItem+Helper.h"
@interface FamilyPersonalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;

@property (nonatomic, strong) PersonalModel *personalModel;

@end

@implementation FamilyPersonalViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[AddFamilyInfoTableViewCell class] forCellReuseIdentifier:@"FamilyPersonalTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家人信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    
    [self.dataSource addObjectsFromArray:@[@"控制我的设备",@"控制我的门锁",@"添加设备到我的家",@"从我的家删除设备"]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更改" normalColor:[UIColor colorWithHexString:@"00bfff"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(httpRequestChangeInfo)];
    
    [self httpRequestHomeInfo];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(httpRequestDelete) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithHexString:@"#e00610"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth =  1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#e00610"].CGColor;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-40*kiphone6);
        make.centerX.equalTo(self.view);
        make.width.offset(150*kiphone6);
        make.height.offset(45*kiphone6);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 110)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenW -20, 90)];
    personV.backgroundColor = [UIColor whiteColor];

//    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick)];
//    [personV addGestureRecognizer:tapGest];
    
    UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
        [iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]]];
    iconV.layer.cornerRadius = 30;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
//    nameLabel.text = @"LIM   家人";
    nameLabel.text = [NSString stringWithFormat:@"%@  %@",self.personalModel.userName,self.personalModel.comment];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    //
    UILabel *idName = [[UILabel alloc]init];
//    idName.text = @"18328887563";
    idName.text = self.telePhone;
    idName.textColor = [UIColor colorWithHexString:@"333333"];
    idName.font = [UIFont systemFontOfSize:14];
    //
    [personV addSubview:iconV];
    [personV addSubview:nameLabel];
    [personV addSubview:idName];
    //
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV).with.offset(0);
        make.left.equalTo(personV).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60 , 60));
    }];
    //
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV).with.offset(23.5 );
        make.left.equalTo(iconV.mas_right).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(140 , 14 ));
    }];
    //
    [idName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(15 );
        make.left.equalTo(nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(260, 14));
    }];
    
    self.nameLabel = nameLabel;
    self.idLabel = idName;
    self.iconV = iconV;
    
    
    
    [headView addSubview:personV];
    return headView;
}

#pragma mark -
#pragma mark ------------TableView Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.navigationController pushViewController:[[FamilyPersonalViewController alloc]init] animated:YES];
    AddFamilyInfoTableViewCell *familyCell = [tableView cellForRowAtIndexPath:indexPath];
    familyCell.iconBtn.selected  = !familyCell.iconBtn.selected;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    headView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    UIView *personV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenW -20, 40)];
    personV.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"权限选择";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    [personV addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personV).with.offset(0);
        make.left.equalTo(personV).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(50 ,12));
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [personV addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personV.mas_bottom).with.offset(0);
        make.left.equalTo(personV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 20 , 1));
    }];
    
    [headView addSubview:personV];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFamilyInfoTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"FamilyPersonalTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.row];
//    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}

// 获取家人权限
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&id=%@",mseeFamilyInfo,mDefineToken2,self.homeID] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        self.personalModel = [PersonalModel mj_objectWithKeyValues:responseObject[@"MyFamily"]];
        [self tableView];
        
        
        
        NSMutableArray *pmsnArray = [[NSMutableArray alloc]initWithObjects:self.personalModel.pmsnCtrlDevice,self.personalModel.pmsnCtrlDoor,self.personalModel.pmsnCtrlAdd,self.personalModel.pmsnCtrlDel, nil];
        for (int i = 0; i<4; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            AddFamilyInfoTableViewCell *familyCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([pmsnArray[i] isEqualToString:@"1"]) {
                familyCell.iconBtn.selected = YES;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
// 修改家人权限
- (void)httpRequestChangeInfo{
    NSMutableArray *pmsnArray = [[NSMutableArray alloc]initWithCapacity:2];;
    for (int i = 0; i<4; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AddFamilyInfoTableViewCell *familyCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(familyCell.iconBtn.selected){
            [pmsnArray addObject:@"1"];
        }else{
            [pmsnArray addObject:@"0"];
        }
    }
    NSDictionary *dict2 = @{
                            @"token":mDefineToken2,
                            @"pmsnCtrlDevice":pmsnArray[0],
                            @"pmsnCtrlDoor":pmsnArray[1],
                            @"pmsnCtrlAdd":pmsnArray[2],
                            @"pmsnCtrlDel":pmsnArray[3]
                            };
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@id=%@",mChangeFamilyInfo,self.homeID] method:1 parameters:dict2 prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
//        [self.navigationController popViewControllerAnimated:true];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//删除我的家人接口
- (void)httpRequestDelete{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@ids=%@&token=%@",mRemoveFamily,self.homeID,mDefineToken2] method:1 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.navigationController popViewControllerAnimated:true];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//在页面消失时候请求更改权限设置
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self httpRequestChangeInfo];
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
