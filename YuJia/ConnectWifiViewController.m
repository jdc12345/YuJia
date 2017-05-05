//
//  ConnectWifiViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "ConnectWifiViewController.h"
#import "SuccessConnectViewController.h"

@interface ConnectWifiViewController ()

@end

@implementation ConnectWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连接wifi";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WS(ws);
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
//    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(ws.view).with.offset(0);
//        make.centerX.equalTo(ws.view);
//        make.size.mas_equalTo(CGSizeMake(kScreenW, 100));
////        make.bottom.mas_equalTo(sightNameText.mas_bottom);
////        make.left.right.equalTo(ws.view);
//    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"wifi"];
    [imageV sizeToFit];
    
    
    UILabel *wifiLabel = [[UILabel alloc]init];
    wifiLabel.text = @"TP-LINK-LIM";
    wifiLabel.textColor = [UIColor colorWithHexString:@"333333"];
    wifiLabel.font = [UIFont systemFontOfSize:15];
    wifiLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
    
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    
    
    [mainView addSubview:imageV];
    [mainView addSubview:wifiLabel];
    [mainView addSubview:sightNameText];
    

    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView).with.offset(0);
        make.centerX.equalTo(mainView);
    }];
    
    [wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).with.offset(15);
        make.centerX.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,15));
    }];
    
    [sightNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wifiLabel.mas_bottom).with.offset(30);
        make.centerX.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(290 ,40));
    }];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.view).with.offset(0);
        make.centerX.equalTo(ws.view);
//        make.size.mas_equalTo(CGSizeMake(kScreenW, 100));
                make.bottom.mas_equalTo(sightNameText.mas_bottom);
                make.left.right.equalTo(ws.view);
    }];
//    mainView.backgroundColor = [UIColor yellowColor];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(-30);
        make.centerX.equalTo(ws.view);
                make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    
    // Do any additional setup after loading the view.
}
- (void)action{
    SuccessConnectViewController *addEquipmentVC  = [[SuccessConnectViewController alloc]init];
    [self.navigationController pushViewController:addEquipmentVC animated:YES];
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
