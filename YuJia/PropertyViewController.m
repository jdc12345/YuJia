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
@interface PropertyViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *imagesURLStrings;
@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"物业管家";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 297)];
    headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:headerView];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:tableView];
    tableView.tableHeaderView = headerView;
    self.tableView = tableView;
    [self loadData];
}
- (void)loadData{
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    self.imagesURLStrings = imagesURLStrings;
    [self setUpUI];
}
- (void)setUpUI {
    // 轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 127) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#00bfff"]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    [self.tableView.tableHeaderView addSubview:cycleScrollView];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
    });
    
    
    //     block监听点击方式
    
    //     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
    //        NSLog(@">>>>>  %ld", (long)index);
    //          [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
    //     };
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
