//
//  YJCommunityCarVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityCarVC.h"
#import "UIButton+Badge.h"
#import "YJCommunityCarTVCell.h"
#import "YJCommunityCarDetailVC.h"
#import "YJPostCommunityCarVC.h"
#import "YJNoticeListTableVC.h"

static NSString* tableCellid = @"table_cell";
@interface YJCommunityCarVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *underwayBtn;
@property(nonatomic,weak)UIButton *endBtn;
//@property(nonatomic,weak)UIView *blueView;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *informationBtn;

@end

@implementation YJCommunityCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区拼车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加右侧消息中心按钮
    UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [informationBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    self.informationBtn = informationBtn;
//    informationBtn.badgeValue = @" ";
//    informationBtn.badgeBGColor = [UIColor redColor];
//    informationBtn.badgeFont = [UIFont systemFontOfSize:0.1];
//    informationBtn.badgeOriginX = 16;
//    informationBtn.badgeOriginY = 1;
//    informationBtn.badgePadding = 0.1;
//    informationBtn.badgeMinSize = 5;
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"正在进行"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"已完成"andTag:102];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.underwayBtn.mas_bottom).offset(-1*kiphone6/[UIScreen mainScreen].scale);
        make.right.left.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    [self loadData];

}
-(void)loadData{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    //    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.underwayBtn.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[YJCommunityCarTVCell class] forCellReuseIdentifier:tableCellid];
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
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = tag;
    if (btn.tag==101) {
        self.underwayBtn = btn;
    }else{
        self.endBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.endBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.endBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        //更新数据源
        
        [self.tableView reloadData];
    }else{
        self.underwayBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.underwayBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        //更新数据源
        
        [self.tableView reloadData];
    }
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;//根据请求回来的数据定
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJCommunityCarTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.type = @"司机";
    }else{
       cell.type = @"乘客"; 
    }
    WS(ws);
    cell.clickForAddBlock = ^(UIButton *sender){
        ws.informationBtn.badgeValue = @" ";
        ws.informationBtn.badgeBGColor = [UIColor redColor];
        ws.informationBtn.badgeFont = [UIFont systemFontOfSize:0.1];
        ws.informationBtn.badgeOriginX = 16;
        ws.informationBtn.badgeOriginY = 1;
        ws.informationBtn.badgePadding = 0.1;
        ws.informationBtn.badgeMinSize = 5;
    };
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YJCommunityCarDetailVC *detailVc = [[YJCommunityCarDetailVC alloc]init];
    [self.navigationController pushViewController:detailVc animated:true];
    
}

- (void)postBtn:(UIButton*)sender {
    YJPostCommunityCarVC *vc = [[YJPostCommunityCarVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
-(void)informationBtnClick:(UIButton*)sender{
    NSArray *noticeArr = @[@"社区拼车消息",@"司机T接单了"];
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
