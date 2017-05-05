//
//  SuccessConnectViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "SuccessConnectViewController.h"

@interface SuccessConnectViewController ()

@end

@implementation SuccessConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"连接wifi";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"wifi"];
    [imageV sizeToFit];
    
    
    UILabel *wifiLabel = [[UILabel alloc]init];
    wifiLabel.text = @"连接成功";
    wifiLabel.textColor = [UIColor colorWithHexString:@"333333"];
    wifiLabel.font = [UIFont systemFontOfSize:15];
    wifiLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    [self.view addSubview:imageV];
    [self.view addSubview:wifiLabel];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(130 +64);
        make.centerX.equalTo(self.view);
    }];
    
    [wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,15));
    }];
    


    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"去设置" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiLabel.mas_bottom).with.offset(66);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    // Do any additional setup after loading the view.
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
