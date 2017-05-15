//
//  YJCommunityCarNoticesCenterVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/15.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityCarNoticesCenterVC.h"
#import "YJCommunityCarNoticesCenterTVCell.h"

static NSString* otherCellid = @"other_cell";
@interface YJCommunityCarNoticesCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView* tableView;

@end

@implementation YJCommunityCarNoticesCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
}
// 初始化UI
- (void)setupUI
{
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    // 设置数据源和代理
    tableView.dataSource = self;
    tableView.delegate = self;
    
    // 把tableView添加到控制器的视图上
    [self.view addSubview:tableView];
    
    // 设置自动布局
    [tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView = tableView;
    
    // 注册单元格

    [self.tableView registerClass:[YJCommunityCarNoticesCenterTVCell class] forCellReuseIdentifier:otherCellid];
    
    // 估算行高
    self.tableView.estimatedRowHeight = 80;
    // 自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 滑动tableView的时候 隐藏键盘
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
// 有多少行
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// cell内容
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
            // 获取other的cell
    YJCommunityCarNoticesCenterTVCell* cell = [tableView dequeueReusableCellWithIdentifier:otherCellid forIndexPath:indexPath];
        
        // 取消点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    cell.backgroundColor = [UIColor clearColor];
        return cell;
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
