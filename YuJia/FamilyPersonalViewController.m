//
//  FamilyPersonalViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "FamilyPersonalViewController.h"
#import "FamilyPersonalTableViewCell.h"
@interface FamilyPersonalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *iconV;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 , kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[FamilyPersonalTableViewCell class] forCellReuseIdentifier:@"FamilyPersonalTableViewCell"];
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
//    [self.view addSubview:[self personInfomation]];
    [self tableView];
    // Do any additional setup after loading the view.
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
    iconV.layer.cornerRadius = 30;
    iconV.clipsToBounds = YES;
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"LIM   家人";
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    //
    UILabel *idName = [[UILabel alloc]init];
    idName.text = @"18328887563";
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
    FamilyPersonalTableViewCell *familyCell = [tableView cellForRowAtIndexPath:indexPath];
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
    FamilyPersonalTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"FamilyPersonalTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.row];
//    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
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
