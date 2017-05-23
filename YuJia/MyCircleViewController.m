//
//  MyCircleViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MyCircleViewController.h"

@interface MyCircleViewController ()
@property (nonatomic, assign) BOOL isCircle;
@end
@implementation MyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *titleView = [[UIView alloc]init];

    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"我的圈子";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    [titleView addSubview:titleLabel];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView).with.offset(0);
        make.left.equalTo(titleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(64, 17));
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
