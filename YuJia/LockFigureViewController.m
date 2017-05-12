//
//  LockFigureViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LockFigureViewController.h"

@interface LockFigureViewController ()

@end

@implementation LockFigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSubViewInThis];
    // Do any additional setup after loading the view.
}
- (void)setSubViewInThis{
    UIImageView *keyBoardImageV = [[UIImageView alloc]init];
    keyBoardImageV.backgroundColor = [UIColor colorWithHexString:@"38d5cf"];
    keyBoardImageV.userInteractionEnabled = YES;
    
    [self.view addSubview:keyBoardImageV];
    
    [keyBoardImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        //        make.size.width.mas_equalTo(kScreenW);
    }];
    
    UIImageView *down_imageV = [[UIImageView alloc]init];
    down_imageV.image = [UIImage imageNamed:@"down_door"];
    [down_imageV sizeToFit];
    
    [keyBoardImageV addSubview:down_imageV];
    
    [down_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(keyBoardImageV).with.offset(-60);
        make.centerX.equalTo(keyBoardImageV);
    }];
    
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text = @"指纹解锁";
    textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    [keyBoardImageV addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(down_imageV.mas_top).with.offset(-10);
        make.centerX.equalTo(keyBoardImageV);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    UIImageView *figure_imageV = [[UIImageView alloc]init];
    figure_imageV.image = [UIImage imageNamed:@"fingerprint-big_door"];
    [figure_imageV sizeToFit];
    
    [keyBoardImageV addSubview:figure_imageV];
    
    [figure_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textLabel.mas_top).with.offset(-20);
        make.centerX.equalTo(keyBoardImageV);
    }];
    
    
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
