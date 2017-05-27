//
//  NotficViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "NotficViewController.h"
#import "YJNoticeListTVCell.h"
#import "YJFriendStateDetailVC.h"
#import "YJCommunityCarNoticesCenterVC.h"

@interface NotficViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *noticeArr;
@end

@implementation NotficViewController
- (NSMutableArray *)noticeArr{
    if (_noticeArr == nil) {
        _noticeArr = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _noticeArr;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 55;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[YJNoticeListTVCell class] forCellReuseIdentifier:@"YJNoticeListTVCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
//        _tableView.tableHeaderView = [self personInfomation];
        

        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}
//-(void)setNoticeArr:(NSArray *)noticeArr{
//    _noticeArr = noticeArr;
//    [self.tableView reloadData];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJNoticeListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YJNoticeListTVCell" forIndexPath:indexPath];
    
//    cell.noticeArr = self.noticeArr;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.noticeArr[0] isEqualToString:@"TIAN"]) {
//        YJFriendStateDetailVC *vc = [[YJFriendStateDetailVC alloc]init];
//        [self.navigationController pushViewController:vc animated:true];
//    }else{
//        YJCommunityCarNoticesCenterVC *vc = [[YJCommunityCarNoticesCenterVC alloc]init];
//        [self.navigationController pushViewController:vc animated:true];
//    }
    
    
}
@end
