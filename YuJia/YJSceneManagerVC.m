//
//  YJSceneManagerVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/28.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJSceneManagerVC.h"
#import "EquipmentManagerTableViewCell.h"
//#import "EquipmentSettingViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "YJSceneDetailModel.h"
#import "YJSceneSetVC.h"

@interface YJSceneManagerVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isSelecting;//判断是否正在选择设备
@property (nonatomic, assign) BOOL isAllSelected;//判断是否全选
@property (nonatomic, weak) UIButton *deletSelectedBtn;//删除所选btn
@property (nonatomic, weak) UIButton *deletedBtn;//删除btn
@property (nonatomic, weak) UIButton *addBtn;//添加btn
@property (nonatomic, weak) UIView *emptyView;//空页面

@end

@implementation YJSceneManagerVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-60*kiphone6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = 90*kiphone6;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[EquipmentManagerTableViewCell class] forCellReuseIdentifier:@"EquipmentManagerTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        //        _tableView.tableHeaderView = [self personInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情景管理";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isSelecting = NO;
    [self tableView];
    [self setBtn];
}
-(void)setBtn{
    //删除设备按钮
    UIButton *deletBtn = [[UIButton alloc]init];
    [self.view addSubview:deletBtn];
    [self.view bringSubviewToFront:deletBtn];
    [deletBtn setTitle:@"删除情景" forState:UIControlStateNormal];
    deletBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [deletBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [deletBtn setBackgroundColor:[UIColor colorWithHexString:@"#f34a52"]];
    [deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.width.offset(kScreenW*0.5);
        make.height.offset(60*kiphone6);
    }];
    [deletBtn addTarget:self action:@selector(deletedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deletedBtn = deletBtn;
    //添加设备按钮
    UIButton *addBtn = [[UIButton alloc]init];
    [self.view addSubview:addBtn];
    [self.view bringSubviewToFront:addBtn];
    [addBtn setTitle:@"添加情景" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor colorWithHexString:@"#0ddcbc"]];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.width.offset(kScreenW*0.5);
        make.height.offset(60*kiphone6);
    }];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    //删除设备按钮
    UIButton *deletSelectedBtn = [[UIButton alloc]init];
    [self.view addSubview:deletSelectedBtn];
    [self.view bringSubviewToFront:deletSelectedBtn];
    [deletSelectedBtn setTitle:@"删除情景" forState:UIControlStateNormal];
    deletSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [deletSelectedBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [deletSelectedBtn setBackgroundColor:[UIColor colorWithHexString:@"#f34a52"]];
    [deletSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(60*kiphone6);
    }];
    [deletSelectedBtn addTarget:self action:@selector(deletSelectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deletSelectedBtn = deletSelectedBtn;
    deletSelectedBtn.hidden = YES;
}
#pragma mark -btnClick
//删除设备
-(void)deletedBtnClick:(UIButton*)sender{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" normalColor:[UIColor colorWithHexString:@"#c5c5c5"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(selectAllEquipment:)];
    self.deletSelectedBtn.hidden = NO;
    self.isSelecting = YES;
    [self.tableView reloadData];
}
//添加设备
-(void)addBtnClick:(UIButton*)sender{
    //跳转情景设置页面
    YJSceneSetVC *vc = [[YJSceneSetVC alloc]init];
    vc.sceneModel = [[YJSceneDetailModel alloc]init];
    [self.navigationController pushViewController:vc animated:true];
//    YJAddEquipmentVC *addVc = [[YJAddEquipmentVC alloc]init];
//    [self.navigationController pushViewController:addVc animated:true];
}
//删除所选
-(void)deletSelectedBtnClick:(UIButton*)sender{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" normalColor:[UIColor colorWithHexString:@"#c5c5c5"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:nil];
    self.deletSelectedBtn.hidden = YES;
    self.isSelecting = NO;
    
    //删除所选情景
    NSString *ids = @"";
    for (int i = 0; i<self.dataSource.count; i++) {
        YJSceneDetailModel *sceneModel = self.dataSource[i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        EquipmentManagerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(cell.selectBtn.selected){
            if (ids.length>0) {
                ids = [NSString stringWithFormat:@"%@,%@",ids,sceneModel.info_id];
            }else{
                ids = [NSString stringWithFormat:@"%@",sceneModel.info_id];
            }
        }
    }
    if (ids.length>0) {//有选中设备，需要删除
        [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@ids=%@&token=%@",mRemoveSigh,ids,mDefineToken2] method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            [self.dataSource removeAllObjects];
            [self httpRequestHomeInfo];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    self.isAllSelected = NO;
    [self.tableView reloadData];
}
//全选/取消全选
-(void)selectAllEquipment:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.isAllSelected = YES;
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消全选" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(selectAllEquipment:)];
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        btn.selected = YES;
    }else{
        self.isAllSelected = NO;
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(selectAllEquipment:)];
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        btn.selected = NO;
    }
    //    [sender setTitleColor:[UIColor colorWithHexString:@"#0ddcbc"] forState:UIControlStateNormal];
}
#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*kiphone6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    YJSceneDetailModel *sceneModel = self.dataSource[indexPath.row];
    
    //    NSLog(@"第%ld row个数 %ld",tableView.tag -100,indexPath.row);
    // 图标  情景设置setting  灯light 电视tv 插座socket
    EquipmentManagerTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentManagerTableViewCell" forIndexPath:indexPath];
    homeTableViewCell.titleLabel.text = sceneModel.sceneName;
    NSString *imageName = [self getPicNameWith:sceneModel];
    homeTableViewCell.iconV.image = [UIImage imageNamed:imageName];
    
    homeTableViewCell.isSelecting = self.isSelecting;//是否处于正在选择状态
    homeTableViewCell.isAllSelected = self.isAllSelected;//是否全选
    //    [homeTableViewCell cellMode:YES];
    //    homeTableViewCell.switch0.hidden = YES;
    [homeTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return homeTableViewCell;
}
- (void)action:(NSString *)actionStr{
    NSLog(@"点什么点");
}
//根据图标序号确定图标
-(NSString *)getPicNameWith:(YJSceneDetailModel*)sceneModel{
    NSString *picName;
    if (sceneModel.sceneIcon) {//编辑已有情景
        switch ([sceneModel.sceneIcon integerValue]) {
            case 0:
                picName = @"getup";
                break;
            case 1:
                picName = @"rest";
                break;
            case 2:
                picName = @"leave";
                break;
            case 3:
                picName = @"gohome";
                break;
            case 4:
                picName = @"playgame";
                break;
            case 5:
                picName = @"time_scene";
                break;
            case 6:
                picName = @"rain_scene";
                break;
            case 7:
                picName = @"eatting_scene";
                break;
            case 8:
                picName = @"music_scene";
                break;
            case 9:
                picName = @"fire_scene";
                break;
            case 10:
                picName = @"sunning_scene";
                break;
            default:
                break;
        }
    }else{//添加新情景
        picName = @"add_home";
    }
    return picName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//请求所有情景数据
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mAllScene,mDefineToken2] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        if (self.dataSource.count>0) {
            [self.dataSource removeAllObjects];
        }
        NSArray *sceneList= responseObject[@"sceneList"];
        if (sceneList.count > 0) {
            if (self.emptyView) {
                [self.emptyView removeFromSuperview];
            }
            for(NSDictionary *sDict in sceneList){
                YJSceneDetailModel *sModel = [YJSceneDetailModel mj_objectWithKeyValues:sDict];
                [self.dataSource addObject:sModel];
            }
            [self.tableView reloadData];
        }else{
            if (self.emptyView) {
                self.emptyView.hidden = false;
            }else{
                [self createEmptyView];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//添加没有数据空页面图
- (void)createEmptyView{
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 500)];
    emptyView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.emptyView = emptyView;
    UIView *clickView = [[UIView alloc]init];
    clickView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emptyClick)];
    //    [clickView addGestureRecognizer:tapGest];
    [emptyView addSubview:clickView];
    [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyView).with.offset(125);
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(160, 230));
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nofamily"]];
    [clickView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clickView);
        make.centerX.equalTo(clickView);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"还没添加情景哦！";
    titleLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [clickView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).with.offset(15);
        make.centerX.equalTo(clickView);
        make.size.mas_equalTo(CGSizeMake(160, 13));
    }];
    
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.text = @"去添加吧！";
    titleLabel2.textColor = [UIColor colorWithHexString:@"cccccc"];
    titleLabel2.font = [UIFont systemFontOfSize:13];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [clickView addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(clickView);
        make.size.mas_equalTo(CGSizeMake(160, 13));
    }];
    
    [self.view addSubview:emptyView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self httpRequestHomeInfo];
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
