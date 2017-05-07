//
//  YJModifyAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJModifyAddressVC.h"
#import "YJAddPropertyBillAddressVC.h"
#import "YJPropertyBillVC.h"

static NSString* detailInfoCellid = @"detailInfo_cell";
@interface YJModifyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@end

@implementation YJModifyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业账单";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
}
- (void)setupUI {
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.bottom.left.right.offset(0);
    }];
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:detailInfoCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"添加地址" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    tableView.tableFooterView = footerView;
    
}
- (void)addAddress{
    YJAddPropertyBillAddressVC *vc = [[YJAddPropertyBillAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellid forIndexPath:indexPath];
        cell.textLabel.text = @"河北名流一品3单元2层205";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];

        return cell;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YJPropertyBillVC class]]) {
            YJPropertyBillVC *revise =(YJPropertyBillVC *)controller;
            revise.clickBtnBlock(cell.textLabel.text);
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*kiphone6;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了修改");
        
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [self.wineArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    return @[action1, action0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
