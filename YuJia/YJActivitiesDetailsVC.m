//
//  YJActivitiesDetailsVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJActivitiesDetailsVC.h"
#import "YJActivitiesDetailsTVCell.h"
#import "YJLikeActivitiesTVCell.h"
#import "YJActivitesCommentTVCell.h"
#import <HUImagePickerViewController.h>
#import "YJActivitesPhotoTVCell.h"

static NSString* tableDetailsCell = @"tableDetailsCell_cell";
static NSString* LikeCell = @"Like_cell";
static NSString* friendCommentCellid = @"friendComment_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJActivitiesDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *communityBtn;
@property(nonatomic,weak)UIButton *likeBtn;
@property(nonatomic,weak)UIButton *joinBtn;
@end

@implementation YJActivitiesDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区活动";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = true;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    int i = 1;
    if (i) {
        //添加右侧发送按钮
        UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [deleateBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    [self loadData];

}
-(void)loadData{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [tableView registerClass:[YJActivitiesDetailsTVCell class] forCellReuseIdentifier:tableDetailsCell];
    [tableView registerClass:[YJLikeActivitiesTVCell class] forCellReuseIdentifier:LikeCell];
    [tableView registerClass:[YJActivitesCommentTVCell class] forCellReuseIdentifier:friendCommentCellid];
    [tableView registerClass:[YJActivitesPhotoTVCell class] forCellReuseIdentifier:photoCellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 235*kiphone6;
    //底部bar
    [self setBtnWithFrame:CGRectMake(0, kScreenH-38*kiphone6, kScreenW/3, 38*kiphone6) WithTitle:@"评论"andTag:101 andImage:@"comment"];
    [self setBtnWithFrame:CGRectMake(kScreenW/3, kScreenH-38*kiphone6, kScreenW/3, 38*kiphone6) WithTitle:@"兴趣"andTag:102 andImage:@"like"];
    [self setBtnWithFrame:CGRectMake(kScreenW/3*2, kScreenH-38*kiphone6, kScreenW/3, 38*kiphone6) WithTitle:@"参加"andTag:102 andImage:@"gray_add"];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-38*kiphone6, kScreenW, 1*kiphone6)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.view addSubview:line];
    [self.view bringSubviewToFront:line];

}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag andImage:(NSString*)image{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 1*kiphone6,38*kiphone6)];
    [btn addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:line];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    btn.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
//    btn.layer.borderWidth = 1/[UIScreen mainScreen].scale;
//    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, -5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.communityBtn = btn;
    }else if(btn.tag==102){
        self.likeBtn = btn;
    }else{
        self.joinBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        YJActivitiesDetailsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableDetailsCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1) {
        
        YJLikeActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:LikeCell forIndexPath:indexPath];
        cell.image = @"blue-like";
        return cell;
    }else if (indexPath.row == 2) {
        
        YJLikeActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:LikeCell forIndexPath:indexPath];
        cell.image = @"blue-add";
        return cell;
    }else if (indexPath.row == 3) {
        
        YJActivitesCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCommentCellid forIndexPath:indexPath];
        return cell;
    }else{
        
        YJActivitesPhotoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCellid forIndexPath:indexPath];
        
        cell.clickAddBlock = ^(HUImagePickerViewController *picker){
            [self presentViewController:picker animated:YES completion:nil];
        };
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
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
