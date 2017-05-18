//
//  AboutYuJiaViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AboutYuJiaViewController.h"
#define bLoodStr  @"宇医app，希望通过网上医疗的形式能够解决用户的一些医疗的基本需求，包括：测量监控自己及家人的健康数据；足不出户解决购药问题；提前预约专家挂号问题；在家与医生面对面交流，解决一些简单的问诊等。"
@interface AboutYuJiaViewController ()

@end

@implementation AboutYuJiaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imageV.backgroundColor = [UIColor grayColor];
    imageV.layer.cornerRadius = 2.5;
    imageV.clipsToBounds = YES;
    
    [self.view addSubview:imageV];
    
    WS(ws);
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(92 *kiphone6 +64);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(70 *kiphone6,70 *kiphone6));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"宇家1.0";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).with.offset(15 *kiphone6);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW,17));
    }];
    
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.numberOfLines = 0;
    promptLabel.textColor = [UIColor colorWithHexString:@"333333"];
    promptLabel.font = [UIFont systemFontOfSize:14];
    //////////////
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:bLoodStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [bLoodStr length])];
    promptLabel.attributedText = attributedString;
    
    [self.view addSubview:promptLabel];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20 *kiphone6);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW -100, 200 *kiphone6));
    }];
    
    
    
    UILabel *editionLabel = [[UILabel alloc]init];
    editionLabel.text = @"当前版本号：1.0（wanyu2017）";
    editionLabel.textColor = [UIColor colorWithHexString:@"aaaaaa"];
    editionLabel.font = [UIFont systemFontOfSize:12];
    editionLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:editionLabel];
    
    [editionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).with.offset(-25 *kiphone6);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW,12));
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
