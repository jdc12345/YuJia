//
//  YJNoticeListTableVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNoticeListTableVC.h"
#import "YJNoticeListTVCell.h"
#import "YJFriendStateDetailVC.h"
#import "YJCommunityCarNoticesCenterVC.h"
#import "YJNoticeListModel.h"
#import "YJCommunityCarDetailVC.h"
#import "YJActivitiesDetailsVC.h"

static NSString* tableCell = @"table_cell";
@interface YJNoticeListTableVC ()
@property(nonatomic,strong)NSMutableArray *noticesArr;//消息数据源
@end

@implementation YJNoticeListTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[YJNoticeListTVCell class] forCellReuseIdentifier:tableCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 55;

}
-(void)setNoticeArr:(NSArray *)noticeArr{
    _noticeArr = noticeArr;
    [self.tableView reloadData];
}
-(void)setNoticeType:(NSInteger)noticeType{
    _noticeType = noticeType;
    [SVProgressHUD show];// 动画开始
    NSString *noticeUrlStr = [NSString string];
    if (noticeType == 1) {
        //    http://192.168.1.55:8080/smarthome/mobileapi/message/findPage.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE&msgType=&msgTypeBegin=2&msgTypeEnd=3
        noticeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/message/findPage.do?token=%@&msgType=&msgTypeBegin=11&msgTypeEnd=30",mPrefixUrl,mDefineToken1];
    }
    if (noticeType == 2) {
        //    http://192.168.1.55:8080/smarthome/mobileapi/message/findPage.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE&msgType=&msgTypeBegin=2&msgTypeEnd=3
        noticeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/message/findPage.do?token=%@&msgType=&msgTypeBegin=31&msgTypeEnd=50",mPrefixUrl,mDefineToken1];
    }
    if (noticeType == 3) {
        //    http://192.168.1.55:8080/smarthome/mobileapi/message/findPage.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE&msgType=&msgTypeBegin=2&msgTypeEnd=3
        noticeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/message/findPage.do?token=%@&msgType=&msgTypeBegin=51&msgTypeEnd=70",mPrefixUrl,mDefineToken1];
    }

    [[HttpClient defaultClient]requestWithPath:noticeUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        NSString *total = responseObject[@"total"];
        if ([total integerValue]>0) {
            NSArray *arr = responseObject[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJNoticeListModel *infoModel = [YJNoticeListModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.noticesArr = mArr;
            //            start = self.statesArr.count;
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }else{
            [SVProgressHUD showInfoWithStatus:@"你目前没有消息可以查看"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.noticesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJNoticeListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
    cell.model = self.noticesArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJNoticeListModel *model = self.noticesArr[indexPath.row];
    if (self.noticeType == 1) {
        YJFriendStateDetailVC *vc = [[YJFriendStateDetailVC alloc]init];
        vc.stateId = model.referId;
        [self.navigationController pushViewController:vc animated:true];
    }else if (self.noticeType == 2){
        YJActivitiesDetailsVC *vc = [[YJActivitiesDetailsVC alloc]init];
        vc.activityId = model.referId;
        [self.navigationController pushViewController:vc animated:true];
    }else if (self.noticeType == 3){
        if (model.msgType == 52 || model.msgType == 53) {//52=司机接单，53=乘客加入
            YJCommunityCarNoticesCenterVC *vc = [[YJCommunityCarNoticesCenterVC alloc]init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:true];
        }else if (model.msgType == 51){
            YJCommunityCarDetailVC *vc = [[YJCommunityCarDetailVC alloc]init];
            vc.carpoolingId = model.referId;
            [self.navigationController pushViewController:vc animated:true];
        }
        
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*kiphone6;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = false;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
