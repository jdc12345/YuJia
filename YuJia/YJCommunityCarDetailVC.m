//
//  YJCommunityCarDetailVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityCarDetailVC.h"
#import "UILabel+Addition.h"
#import "UIButton+Badge.h"
#import "YJFriendCommentTableViewCell.h"
#import "YJSelfReplyTableViewCell.h"
#import "YJActivitesCommentTVCell.h"
#import "YJPostActivitesCommentVC.h"

static NSString* tablecell = @"table_cell";

@interface YJCommunityCarDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *communityBtn;

@property(nonatomic,weak)UIButton *joinBtn;
@property(nonatomic,strong)NSString *type;

@end

@implementation YJCommunityCarDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区拼车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.type = @"乘客";
    if ([self.type isEqualToString:@"乘客"]) {
        //添加右侧消息中心按钮
        UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
        [informationBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
        informationBtn.badgeValue = @" ";
        informationBtn.badgeBGColor = [UIColor redColor];
        informationBtn.badgeFont = [UIFont systemFontOfSize:0.1];
        informationBtn.badgeOriginX = 16;
        informationBtn.badgeOriginY = 1;
        informationBtn.badgePadding = 0.1;
        informationBtn.badgeMinSize = 5;
        [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    [self loadData];

}
-(void)loadData{
    //添加大tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [tableView registerClass:[YJActivitesCommentTVCell class] forCellReuseIdentifier:tablecell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 235*kiphone6;
    //添加大tb头部试图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200*kiphone6)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *iconView = [[UIImageView alloc]init];//头像图片
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerView.mas_top).offset(31*kiphone6);
        make.width.height.offset(40*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//姓名
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_top).offset(31*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *stateLabel = [UILabel labelWithText:@"5月6日 6:30" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//开始时间
    [headerView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *begainTimeLabel = [UILabel labelWithText:@"5月6日 6:30" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//开始时间
    [headerView addSubview:begainTimeLabel];
    [begainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.right.equalTo(stateLabel.mas_left).offset(-10*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(headerView.mas_top).offset(62*kiphone6);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];

    UILabel *typeLabel = [UILabel labelWithText:@"身份" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:15];//发起人类型标题
    [headerView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(29*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *typeContentLabel = [UILabel labelWithText:@"司机" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//发起人类型
    [headerView addSubview:typeContentLabel];
    [typeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(29*kiphone6);
        make.left.equalTo(typeLabel.mas_right).offset(10*kiphone6);
    }];
    UILabel *timeItemLabel = [UILabel labelWithText:@"出发时间" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//时间标题
    [headerView addSubview:timeItemLabel];
    [timeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(typeLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"5.6 6:30" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//时间内容
    [headerView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(timeItemLabel);
    }];
    UILabel *AddressItemLabel = [UILabel labelWithText:@"出发地" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//地点标题
    [headerView addSubview:AddressItemLabel];
    [AddressItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(timeItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *AddressLabel = [UILabel labelWithText:@"名流一品" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//地点内容
    [headerView addSubview:AddressLabel];
    [AddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(AddressItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(AddressItemLabel);
    }];
    UILabel *destinationItemLabel = [UILabel labelWithText:@"目的地" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//目的地标题
    [headerView addSubview:destinationItemLabel];
    [destinationItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(AddressItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *limiteNumberLabel = [UILabel labelWithText:@"风景区公园" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//目的地内容
    [headerView addSubview:limiteNumberLabel];
    [limiteNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(destinationItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(destinationItemLabel);
    }];
    
    tableView.tableHeaderView = headerView;
    //底部bar
    [self setBtnWithFrame:CGRectMake(0, kScreenH-102*kiphone6, kScreenW/2, 38*kiphone6) WithTitle:@"评论"andTag:101 andImage:@"comment"];
    if ([self.type isEqualToString:@"乘客"]) {
        [self setBtnWithFrame:CGRectMake(kScreenW/2, kScreenH-102*kiphone6, kScreenW/2, 38*kiphone6) WithTitle:@"接单"andTag:102 andImage:nil];
    }else if ([self.type isEqualToString:@"司机"]){
        [self setBtnWithFrame:CGRectMake(kScreenW/2, kScreenH-102*kiphone6, kScreenW/2, 38*kiphone6) WithTitle:@"参加"andTag:102 andImage:@"gray_add"];
    }

    
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag andImage:(NSString*)image{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-1, 0, 1*kiphone6,38*kiphone6)];
    [btn addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,1*kiphone6)];
    [btn addSubview:line2];
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
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
    }else{
        self.joinBtn = btn;
        if ([self.type isEqualToString:@"乘客"]) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];//进行中和已结束颜色不同
        }
        
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    if (sender.tag==101) {
        YJPostActivitesCommentVC *vc = [[YJPostActivitesCommentVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJActivitesCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tablecell forIndexPath:indexPath];
    WS(ws);
    cell.clickForReplyBlock = ^(NSString *str){
        YJPostActivitesCommentVC *vc = [[YJPostActivitesCommentVC alloc]init];
        vc.replyType = [NSString stringWithFormat:@"%@",str];
        [ws.navigationController pushViewController:vc animated:true];
    };
    return cell;
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
