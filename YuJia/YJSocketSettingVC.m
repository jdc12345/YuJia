//
//  YJSocketSettingVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/21.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJSocketSettingVC.h"

@interface YJSocketSettingVC ()

@end

@implementation YJSocketSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"窗帘";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSubView];
    // Do any additional setup after loading the view.
}
- (void)setSubView{
    // 图标
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"equipment_set_socket"];
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(260 ,260));
    }];
    
    // 开关
    UISwitch *switch0 = [[UISwitch alloc]init];
    switch0.onTintColor= [UIColor colorWithHexString:@"#0ddcbc"];
    switch0.tintColor = [UIColor colorWithHexString:@"#8e9096"];
    // 控件大小，不能设置frame，只能用缩放比例
    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
    [switch0 addTarget:self action:@selector(httpRequestInfo) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switch0];
    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageV.mas_bottom).with.offset(5);
    }];
}
- (void)httpRequestInfo{
    
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

