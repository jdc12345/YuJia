//
//  YJFriendNeighborVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJFriendNeighborVC.h"
#import "YJHeaderTitleBtn.h"
#import "YJFriendStateTableViewCell.h"
#import "YJPostFriendStateVC.h"
#import "UIButton+Badge.h"
#import "YJFriendStateDetailVC.h"
#import "YJPostFriendStateVC.h"
#import "YJNoticeListTableVC.h"

static NSString* tableCellid = @"table_cell";
@interface YJFriendNeighborVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *myCommunityBtn;
@property(nonatomic,weak)UIButton *otherCommunityBtn;
@property(nonatomic,weak)UIView *blueView;
@property(nonatomic,weak)UITableView *tableView;
@end

@implementation YJFriendNeighborVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"友邻圈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
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
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"我的小区"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"其他小区"andTag:102];
    UIView *barView = [[UIView alloc]init];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.myCommunityBtn.mas_bottom);
        make.height.offset(30*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [barView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];

    NSArray *itemArr = @[@"全部",@"健康",@"居家",@"母婴",@"旅游",@"美食",@"宠物"];
    for (int i=0; i<itemArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 51+i;
        [btn setTitle:itemArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [barView addSubview:btn];
        [btn sizeToFit];
        CGSize size = btn.bounds.size;
        CGFloat margen = (kScreenW-20*kiphone6-7*size.width)/6;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10*kiphone6+i*(margen+size.width));
            make.centerY.equalTo(barView);
        }];
        
        [btn addTarget:self action:@selector(scrollBlueView:) forControlEvents:UIControlEventTouchUpInside];

    }
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];
    [barView addSubview:blueView];
    self.blueView = blueView;
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.bottom.offset(0);
        make.width.offset(28*kiphone6);
        make.height.offset(2.5*kiphone6);
    }];
    [self loadData];
    
}
-(void)loadData{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueView.mas_bottom).offset(5*kiphone6);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJFriendStateTableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight =  235*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
    UIButton *postBtn = [[UIButton alloc]init];
    [postBtn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
//    postBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    postBtn.layer.cornerRadius = 25*kiphone6;
    postBtn.layer.masksToBounds = YES;
    [postBtn addTarget:self action:@selector(postBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
    WS(ws);
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(-54*kiphone6);
        make.right.equalTo(ws.view).with.offset(-12*kiphone6);
        make.size.mas_equalTo(CGSizeMake(49*kiphone6 ,49*kiphone6));
    }];

}
-(void)scrollBlueView:(UIButton*)sender{
    [UIView animateWithDuration:0.3 animations:^{
        [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.width.offset(28*kiphone6);
            make.height.offset(2.5*kiphone6);
            make.centerX.equalTo(sender);
        }];
    }];
    
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.myCommunityBtn = btn;
    }else{
        self.otherCommunityBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.otherCommunityBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.otherCommunityBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.otherCommunityBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }else{
        self.myCommunityBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.myCommunityBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.myCommunityBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
    }
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

 return 3;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJFriendStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 235*kiphone6;
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJFriendStateDetailVC *detailVc = [[YJFriendStateDetailVC alloc]init];
    [self.navigationController pushViewController:detailVc animated:true];
    
}

- (void)postBtn:(UIButton*)sender {
    YJPostFriendStateVC *vc = [[YJPostFriendStateVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
-(void)informationBtnClick:(UIButton*)sender{
    NSArray *noticeArr = @[@"TIAN",@"用户TIAN给你点赞了"];
    YJNoticeListTableVC *vc = [[YJNoticeListTableVC alloc]init];
    vc.noticeArr = noticeArr;
    [self.navigationController pushViewController:vc animated:true];
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
