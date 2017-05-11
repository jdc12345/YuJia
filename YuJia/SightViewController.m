//
//  SightViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "SightViewController.h"
#import "UIColor+Extension.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "EquipmentTableViewCell.h"
#import "SightSettingViewController.h"
#import "AddEquipmentViewController.h"
#import "EquipmentViewController.h"
#import "SightViewController.h"
#import "SightModel.h"
#import "EquipmentModel.h"
#import "LightSettingViewController.h"
#import "AirConditioningViewController.h"
#import "TVSettingViewController.h"
@interface SightViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    JXPageView *pageView;
    JXSegment *segment;
    UIImageView *navBarHairlineImageView;
    UIImageView *tabBarHairlineImageView;
}
@property (nonatomic, strong) NSMutableArray *nameList;

@property (nonatomic, assign) NSInteger loadTableV;

@end

@implementation SightViewController

- (NSMutableArray *)nameList{
    if (_nameList == nil) {
        _nameList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _nameList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%ld",self.dataSource.count);
    for (SightModel *sightModel in self.dataSource) {
        [self.nameList addObject:sightModel.sceneName];
    }
    
    
    [self setupSlideBar];
    
    
    
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [starBtn setTitle:@"一键开启" forState:UIControlStateNormal];
    [starBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    starBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    starBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    starBtn.layer.cornerRadius = 40;
    starBtn.clipsToBounds = YES;
    [starBtn addTarget:self action:@selector(buttonClick_Start:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:starBtn];
    
    WS(ws);
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(-15 -49);
        make.right.equalTo(ws.view).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(80 ,80));
    }];
    
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"index = %ld",Index);
    switch (Index)
    {
            //        case 0:
            //            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_apple_small.png")]];
            //            break;
            //        case 1:
            //            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_orange_small.png")]];
            //            break;
            //        case 2:
            //            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_banana_small.png")]];
            //            break;
            //        default:
            //            break;
    }
}
- (void)setupSlideBar {
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
//    [segment updateChannels:@[@"首页",@"文章",@"好东西",@"早点与宵夜",@"电子小物",@"苹果",@"收纳集合",@"JBL",@"装b利器",@"测试机啦啦",@"乱七八糟的"]];
    [segment updateChannels:self.nameList];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 40, kScreenW, self.view.bounds.size.height - 100)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
//    for(int i = 0 ; i<self.nameList.count;i++){
//        NSLog(@"i === %d",i);
//        [pageView changeToItemAtIndex:i];
//    }
    [pageView changeToItemAtIndex:0];
    
    [self.view addSubview:pageView];
}
#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return self.dataSource.count;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
//    NSLog(@"view  index =  %ld",index);
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[self randomColor]];
    
    self.loadTableV = index;
    ////////////////////////////
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreenW, kScreenH -148 -5) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = 100 +index;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [tableView registerClass:[EquipmentTableViewCell class] forCellReuseIdentifier:@"EquipmentTableViewCell"];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    ////////////////////////////
    return tableView;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [segment didChengeToIndex:index];
//    NSLog(@"index = %ld",index);
}


- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
#pragma mark -
#pragma mark ------------TableView Delegeta----------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SightSettingViewController *sightVC = [[SightSettingViewController alloc]init];
        sightVC.sightModel = self.dataSource[segment.selectedIndex];
        [self.navigationController pushViewController:sightVC animated:YES];
    }else{
        TVSettingViewController *sightVC = [[TVSettingViewController alloc]init];
//        sightVC.sightModel = self.dataSource[segment.selectedIndex];
        [self.navigationController pushViewController:sightVC animated:YES];
    }
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        SightModel* sightModel;
        if (self.dataSource.count == 0) {
            return 0;
        }else{
            
            sightModel = self.dataSource[tableView.tag - 100];
            
            return sightModel.equipmentList.count;
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"select = %ld",tableView.tag -100);
    SightModel* sightModel;
    EquipmentModel *equipmentModel;
    if (self.dataSource.count == 0) {
    }else{
        sightModel = self.dataSource[tableView.tag -100];
    }
    if (sightModel.equipmentList.count != 0) {
        equipmentModel = sightModel.equipmentList[indexPath.row];
    }
//    NSLog(@"第%ld row个数 %ld",tableView.tag -100,indexPath.row);
    // 图标  情景设置setting  灯light 电视tv 插座socket
    EquipmentTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentTableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        homeTableViewCell.titleLabel.text = @"情景设置";
        homeTableViewCell.iconV.image = [UIImage imageNamed:@"setting"];
        [homeTableViewCell cellMode:NO];
    }else{
        homeTableViewCell.titleLabel.text = equipmentModel.name;
        if (equipmentModel.iconUrl.length >0) {
            
        }else{
            homeTableViewCell.titleLabel.text = equipmentModel.name;
//            homeTableViewCell.iconV.image = [UIImage imageNamed:mIcon[[equipmentModel.iconId integerValue] +1]];
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
- (void)segmentAction:(UISegmentedControl *)action{
//    NSLog(@"  %ld",action.selectedSegmentIndex);
//    if (action.selectedSegmentIndex == 0) {
//        [segment updateChannels:@[@"首页",@"文章",@"好东西",@"早点与宵夜",@"电子小物",@"苹果",@"收纳集合",@"JBL",@"装b利器",@"测试机啦啦",@"乱七八糟的"]];
//    }else{
//        [segment updateChannels:@[@"客厅",@"lim的卧室",@"厨房",@"卫生间",@"电子小物"]];
//    }
}
- (void)addEquipment{
    AddEquipmentViewController *addEquipmentVC  = [[AddEquipmentViewController alloc]init];
    [self.navigationController pushViewController:addEquipmentVC animated:YES];
}
- (void)buttonClick_Start:(UIButton *)btn{
    NSLog(@"点点");
//    id=1&state=1&token=9DB2FD6FDD2F116CD47CE6C48B3047EE
    
//    NSArray *theData = @[@{@"token":@"9DB2FD6FDD2F116CD47CE6C48B3047EE",@"token":@"9DB2FD6FDD2F116CD47CE6C48B3047EE"},@{@"token":@"9DB2FD6FDD2F116CD47CE6C48B3047EE",@"token":@"9DB2FD6FDD2F116CD47CE6C48B3047EE"}];
//    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = @{@"id":@"1",@"scene_state":@"1",@"token":@"9DB2FD6FDD2F116CD47CE6C48B3047EE"};
    
//    NSLog(@"%@",jsonText);
    [[HttpClient defaultClient]requestWithPath:mSightStart method:1 parameters:dict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"提交成功%@",responseObject);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
            //       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            //       [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
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
