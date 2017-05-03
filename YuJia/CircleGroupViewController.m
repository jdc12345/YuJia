//
//  CircleGroupViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "CircleGroupViewController.h"
#import "UIColor+colorValues.h"
#import "YYCircleTableViewCell.h"
#import "YYPropertyFunctionList.h"

static NSString* cellid = @"cell_id";
@interface CircleGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, strong) NSArray* itemsData;//事项列表
@end

@implementation CircleGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = @"圈子";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
    [self loadData];

}
- (void)loadData{
    NSArray *items = @[@[@{@"name":@"友邻圈",@"icon":@"friends_circle"}],@[@{@"name":@"社区活动",@"icon":@"community_activities"}]
                       ,@[@{@"name":@"社区拼车",@"icon":@"community_carpool"}]];
    
    NSMutableArray* arrayItem = [NSMutableArray array];
    for (NSArray *itemArr in items) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (NSDictionary* dict in itemArr) {
            YYPropertyFunctionList *model = [YYPropertyFunctionList itemWithDict:dict];
            [arrayM addObject:model];
        }
        [arrayItem addObject:arrayM];
    }
    self.itemsData = arrayItem;
    [self setUpUI];
}
- (void)setUpUI {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YYCircleTableViewCell class] forCellReuseIdentifier:cellid];
    // 轮播器
    
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.model = self.itemsData[indexPath.section][indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5*kiphone6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*kiphone6;
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
