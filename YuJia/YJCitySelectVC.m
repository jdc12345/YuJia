//
//  YJCitySelectVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/17.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCitySelectVC.h"
#import "UILabel+Addition.h"

static NSString* tableCellid = @"table_cell";
@interface YJCitySelectVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YJCitySelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}
-(void)setupUI{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
//    self.tableView = tableView;
    [self.view addSubview:tableView];
    //    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellid];
    tableView.rowHeight =  45*kiphone6;
    tableView.delegate =self;
    tableView.dataSource = self;
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 2;//根据请求回来的数据定
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellid];
    if (indexPath.section==0) {
        cell.textLabel.text = self.cityName;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"map"];
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10*kiphone6);
            make.centerY.equalTo(cell.contentView);
        }];

    }else{
        if (indexPath.row==0) {
            cell.textLabel.text = @"北京市";
        }else if (indexPath.row==1){
            cell.textLabel.text = @"保定市";
        }
    }
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UILabel *itemlabel = [UILabel labelWithText:@"定位城市" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];
    [backView addSubview:itemlabel];
    [itemlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(backView);
    }];
    if (section==1) {
        itemlabel.text = @"所在城市";
    }
    return backView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 45*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.popVCBlock(cell.textLabel.text);//给bolock赋值
    [self.navigationController popViewControllerAnimated:true];
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
