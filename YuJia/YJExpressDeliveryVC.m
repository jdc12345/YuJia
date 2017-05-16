//
//  YJExpressDeliveryVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJExpressDeliveryVC.h"
#import "UILabel+Addition.h"
#import "YJExpressReceiveTVCell.h"
#import "YJExpressSenderTVCell.h"

static NSString* receiveCellid = @"receive_cell";
static NSString* senderCellid = @"sender_cell";
@interface YJExpressDeliveryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *receiveBtn;
@property(nonatomic,weak)UIButton *senderdBtn;
//
@property(nonatomic,weak)UITableView *senderTableView;
@property(nonatomic,weak)UITableView *receiveTableView;
@end

@implementation YJExpressDeliveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快递收发";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"收快递"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"发快递"andTag:102];
    [self loadData];
}
-(void)loadData{
    
    [self selectItem:self.receiveBtn];
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        UIView *line = [[UIView alloc]init];//添加line
        line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [btn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.right.offset(0);
            make.width.offset(1*kiphone6/[UIScreen mainScreen].scale);
        }];

        self.receiveBtn = btn;
    }else{
        self.senderdBtn = btn;
    }
    [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.senderTableView.hidden = true;
        self.senderdBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.senderdBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        if (self.receiveTableView) {
            self.receiveTableView.hidden = false;
        }else{
            //添加tableView
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
            self.receiveTableView = tableView;
            [self.view addSubview:tableView];
            self.receiveTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.receiveBtn.mas_bottom);
                make.left.right.bottom.offset(0);
            }];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         [tableView registerClass:[YJExpressReceiveTVCell class] forCellReuseIdentifier:receiveCellid];
            tableView.delegate =self;
            tableView.dataSource = self;
            tableView.estimatedRowHeight = 186*kiphone6;
            tableView.rowHeight = UITableViewAutomaticDimension;
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 38*kiphone6)];
            headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            UILabel *noticeLabel = [UILabel labelWithText:@"提货码有效期为三天，失效后请到物业办公室处理。" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];
            [headerView addSubview:noticeLabel];
            [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.offset(10*kiphone6);
            }];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [headerView addSubview:line];
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*kiphone6, kScreenW, 1)];
            line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [headerView addSubview:line2];

            tableView.tableHeaderView = headerView;
        }
   
    }else{
        self.receiveTableView.hidden = true;
        self.senderTableView.hidden = false;
        self.receiveBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.receiveBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        if (self.senderTableView) {
            self.senderTableView.hidden = false;
            [self.senderTableView reloadData];
        }else{
            //添加tableView
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
            self.senderTableView = tableView;
            [self.view addSubview:tableView];
            self.senderTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.receiveBtn.mas_bottom);
                make.left.right.bottom.offset(0);
            }];
            tableView.estimatedRowHeight = 71*kiphone6;
            tableView.rowHeight = UITableViewAutomaticDimension;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[YJExpressSenderTVCell class] forCellReuseIdentifier:senderCellid];
            tableView.delegate =self;
            tableView.dataSource = self;
        }

    }
    
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
        return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.receiveTableView) {
        
        return 3;
    }else{
        return 4;//根据请求回来的数据定
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.receiveTableView) {
        YJExpressReceiveTVCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveCellid forIndexPath:indexPath];
        if (indexPath.row==0) {
//            cell.item = @"已收取";
        }else{
//            cell.item = @"未收取";
        }
        return cell;
    }else{
        YJExpressSenderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:senderCellid forIndexPath:indexPath];
        
        return cell;
    }
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
