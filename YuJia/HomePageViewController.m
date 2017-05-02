//
//  HomePageViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "HomePageViewController.h"
#import "UIColor+Extension.h"
#import "JXSegment.h"
#import "JXPageView.h"

@interface HomePageViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate, UITabBarDelegate,UITableViewDataSource>{
    JXPageView *pageView;
    JXSegment *segment;
    UIImageView *navBarHairlineImageView;
    UIImageView *tabBarHairlineImageView;
}
//@property (nonatomic, strong) FDSlideBar *slideBar;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Left item
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBtn.frame = CGRectMake(10, 16, 60, 12);
    [leftNavBtn setTitle:@"切换实景" forState:UIControlStateNormal];
    [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:leftNavBtn];
    
    
    // Right item
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(kScreenW -22, 16, 12, 12);
    [rightNavBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [rightNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightNavBtn];
    
    // .TitleVeiw - Segmented Control
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"情景",@"设备",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake((kScreenW -150)/2.0, 7,150, 30.0);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithHexString:@"00bfff"];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"666666"], NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"666666"] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:segmentedControl];
    
    
    
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // 改变navBar 下面的线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    UILabel *coverView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    coverView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [navBarHairlineImageView removeFromSuperview];
    [navBarHairlineImageView addSubview:coverView];
    
    
    [self setupSlideBar];
    
    // Do any additional setup after loading the view.
}
/**
 * PS:navigation  下面的线
 */
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
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
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 40)];
    [segment updateChannels:@[@"首页",@"文章",@"好东西",@"早点与宵夜",@"电子小物",@"苹果",@"收纳集合",@"JBL",@"装b利器",@"测试机啦啦",@"乱七八糟的"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 104, kScreenW, self.view.bounds.size.height - 100)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
    [pageView changeToItemAtIndex:0];
    [self.view addSubview:pageView];
}
#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return 11;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[self randomColor]];
    
    ////////////////////////////
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreenW, kScreenH -148) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.indicatorStyle =
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    //        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
//    [tableView registerClass:[YYHomeNewTableViewCell class] forCellReuseIdentifier:@"YYHomeNewTableViewCell"];
//    [tableView registerClass:[YYHomeMedicineTableViewCell class] forCellReuseIdentifier:@"YYHomeMedicineTableViewCell"];
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
}


- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
     UITableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    homeTableViewCell.textLabel.text = @"123";
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
