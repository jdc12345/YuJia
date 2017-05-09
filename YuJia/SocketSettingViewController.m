//
//  SocketSettingViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/9.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "SocketSettingViewController.h"

@interface SocketSettingViewController ()

@end

@implementation SocketSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客厅灯";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSubView];
    // Do any additional setup after loading the view.
}
- (void)setSubView{
    // 图标
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"socket-big"];
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(84);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(110 ,110));
    }];
    
    // 开关
    
    UISwitch *switch0 = [[UISwitch alloc]init];
    switch0.onTintColor= [UIColor colorWithHexString:@"00bfff"];
    switch0.tintColor = [UIColor colorWithHexString:@"cccccc"];
    // 控件大小，不能设置frame，只能用缩放比例
    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
    [self.view addSubview:switch0];
    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageV.mas_bottom).with.offset(20);
    }];
    
    
    // 中间灰条
    UILabel *grayLabelBottom = [[UILabel alloc]init];
    grayLabelBottom.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.view addSubview:grayLabelBottom];
    
    [grayLabelBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(switch0.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,kScreenH));
    }];
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
