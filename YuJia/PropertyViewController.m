//
//  PropertyViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "PropertyViewController.h"
#import "SDCycleScrollView.h"
#import "UIColor+colorValues.h"
#import "YYFunctionListFlowLayout.h"
#import "YYFunctionCollectionViewCell.h"
#import "NSArray+Addition.h"
#import "UILabel+Addition.h"
#import "YYPropertyTableViewCell.h"
#import "YYPropertyItemModel.h"
static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
@interface PropertyViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *imagesURLStrings;
@property (nonatomic, strong) NSArray* functionListData;//功能列表
@property (nonatomic, strong) NSArray* itemsData;//事项列表
@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"物业管家";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}
- (void)loadData{
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    self.imagesURLStrings = imagesURLStrings;
    NSArray *items = @[@[@{@"item":@"2017年5月物业费",@"event":@"立即缴费"}],@[@{@"item":@"您有2个快递",@"event":@"查看"}]
                       ,@[@{@"item":@"您预约了今天上午9：00上门维修",@"event":@"查看"}]];
    
    NSMutableArray* arrayItem = [NSMutableArray array];
    for (NSArray *itemArr in items) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (NSDictionary* dict in itemArr) {
            YYPropertyItemModel *model = [YYPropertyItemModel itemWithDict:dict];
            [arrayM addObject:model];
        }
        [arrayItem addObject:arrayM];
    }
    self.itemsData = arrayItem;

    [self setUpUI];
}
- (void)setUpUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 297*kiphone6)];
    headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:headerView];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.view addSubview:tableView];
    tableView.tableHeaderView = headerView;
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YYPropertyTableViewCell class] forCellReuseIdentifier:tableCellid];
    // 轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, 127*kiphone6) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#00bfff"]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    [self.tableView.tableHeaderView addSubview:cycleScrollView];
    //         --- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
//    });
    
    
    //     block监听点击方式
    
//         cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
//            NSLog(@">>>>>  %ld", (long)index);
//              [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
//         };
    //功能列表(CollectionView)
    // 用来接收数据 方便设置数据源
    self.functionListData = [self loadFunctionListData];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 127*kiphone6, kScreenW, 170*kiphone6) collectionViewLayout:[[YYFunctionListFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.tableView.tableHeaderView addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册单元格
    [collectionView registerClass:[YYFunctionCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
   
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.functionListData.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YYFunctionCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.functionList = self.functionListData[indexPath.row];
    return cell;
}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    UIViewController* vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 解析数据
- (NSArray*)loadFunctionListData
{
    return [NSArray objectListWithPlistName:@"FunctionsList.plist" clsName:@"YYPropertyFunctionList"];
}


#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
//                    NSLog(@">>>>>  %ld", (long)index);
        UIViewController* vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor redColor];
        [self.navigationController pushViewController:vc animated:YES];
                 };
    cell.model = self.itemsData[indexPath.section][indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *items = @[@"需交费用",@"快递通知",@"报修通知"];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 24*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIImageView *rectView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rectangle"]];
    [backView addSubview:rectView];
    [rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(backView);
        make.width.offset(6*kiphone6);
        make.height.offset(15*kiphone6);
    }];
    UILabel *itemLabel = [UILabel labelWithText:items[section] andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [backView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rectView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(backView);
    }];
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24*kiphone6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
